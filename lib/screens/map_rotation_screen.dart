import 'dart:async';
import 'package:flutter/material.dart';
import '../models/map_rotation.dart';
import '../services/apex_api_service.dart';

class MapRotationScreen extends StatefulWidget {
  const MapRotationScreen({super.key});

  @override
  State<MapRotationScreen> createState() => _MapRotationScreenState();
}

class _MapRotationScreenState extends State<MapRotationScreen> {
  late Future<MapRotation> _mapRotationFuture;
  Timer? _timer;
  MapRotation? _currentRotation;
  Duration _remainingDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _fetchRotation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _fetchRotation() {
    _timer?.cancel();
    setState(() {
      _mapRotationFuture = ApexApiService().fetchMapRotation();
    });

    _mapRotationFuture.then((rotation) {
      _currentRotation = rotation;
      _remainingDuration = _parseTimerString(rotation.remainingTime);
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data Map Rotation berhasil dimuat!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal memuat data Map Rotation!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingDuration.inSeconds > 0) {
        setState(() {
          _remainingDuration = _remainingDuration - const Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
        _fetchRotation();
      }
    });
  }

  Duration _parseTimerString(String timerString) {
    try {
      final parts = timerString.split(':');
      if (parts.length == 3) {
        final h = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        final s = int.parse(parts[2]);
        return Duration(hours: h, minutes: m, seconds: s);
      }
    } catch (_) {}
    return Duration.zero;
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        title: const Text(
          'Map Rotation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<MapRotation>(
        future: _mapRotationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            );
          } else if (_currentRotation != null) {
            return _buildRotationView(_currentRotation!);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildRotationView(MapRotation rotation) {
    final liveRemainingTime = _formatDuration(_remainingDuration);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        color: const Color(0xFF2E2E2E),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (rotation.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    rotation.imageUrl,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                      size: 80,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                rotation.mode.toUpperCase(),
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Colors.white24, thickness: 1, height: 24),
              _buildStatRow('Map Saat Ini', rotation.currentMap),
              _buildStatRow('Sisa Waktu', liveRemainingTime),
              _buildStatRow('Map Berikutnya', rotation.nextMap),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70)),
          Text(value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/apex_api_service.dart';
import '../models/player_stats_model.dart';

class PlayerStatsScreen extends StatefulWidget {
  const PlayerStatsScreen({super.key});

  @override
  State<PlayerStatsScreen> createState() => _PlayerStatsScreenState();
}

class _PlayerStatsScreenState extends State<PlayerStatsScreen> {
  final TextEditingController _playerController = TextEditingController();
  String _selectedPlatform = 'PC';
  Future<PlayerStatsModel>? _statsFuture;

  final List<String> platforms = ['PC'];
  String? _errorMessage; // untuk pesan kesalahan kecil tanpa snackbar

  void _searchStats() {
    final playerName = _playerController.text.trim();

    if (playerName.isEmpty) {
      setState(() {
        _errorMessage = '⚠️ Masukkan ID pemain terlebih dahulu.';
        _statsFuture = null;
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _statsFuture = ApexApiService().fetchPlayerStats(
        playerName: playerName,
        platform: _selectedPlatform,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10), // 🎨 warna sama seperti dashboard
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Apex Player Stats',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputForm(),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.w500),
                ),
              ),
            const SizedBox(height: 20),
            _buildStatsResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Card(
      color: const Color(0xFF1A1A1C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.redAccent),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _playerController,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.redAccent,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF121214),
                labelText: 'Username EA',
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.person, color: Colors.redAccent),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Platform',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF121214),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
              ),
              dropdownColor: const Color(0xFF1A1A1C),
              style: const TextStyle(color: Colors.white),
              value: _selectedPlatform,
              items: platforms.map((String platform) {
                return DropdownMenuItem<String>(
                  value: platform,
                  child: Text(platform),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() => _selectedPlatform = newValue!);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _searchStats,
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text(
                'Cari Stats',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsResult() {
    if (_statsFuture == null) {
      return const Center(
        child: Text(
          'Masukkan ID dan Platform untuk mencari stats.',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return FutureBuilder<PlayerStatsModel>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(30),
            child: CircularProgressIndicator(color: Colors.redAccent),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              '❌ Gagal memuat data: ${snapshot.error}',
              style: const TextStyle(color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
          );
        } else if (snapshot.hasData) {
          final player = snapshot.data!;
          return Card(
            color: const Color(0xFF1A1A1C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.redAccent),
            ),
            margin: const EdgeInsets.only(top: 12),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      player.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  const Divider(height: 30, color: Colors.white24),
                  if (player.rankImg.isNotEmpty)
                    Center(
                      child: Image.network(
                        player.rankImg,
                        height: 90,
                        width: 90,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.military_tech, size: 80, color: Colors.amber);
                        },
                      ),
                    ),
                  const SizedBox(height: 15),
                  _buildStatRow('Rank Saat Ini', player.rankName),
                  _buildStatRow('Platform', player.platform),
                  _buildStatRow('Level', player.level.toString()),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70)),
          Text(value,
              style: const TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}

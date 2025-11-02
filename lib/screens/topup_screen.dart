import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/topup_record.dart';
import 'topup_history_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final List<String> _currencies = ['IDR', 'USD', 'YEN', 'YUAN'];
  String _selectedCurrency = 'IDR';
  double _result = 0;
  int? _selectedCoin;
  final double _coinRate = 100; // 1 Apex Coin = 100 IDR
  final List<int> _presetCoins = [500, 1000, 2150, 4350, 6700, 11500];

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initNotification();
  }

  void _initNotification() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> _showNotification(String message) async {
    const androidDetails = AndroidNotificationDetails(
      'topup_channel',
      'Top-Up Notifications',
      channelDescription: 'Notifikasi setelah top-up berhasil',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const details = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Top-Up Berhasil 🎉',
      message,
      details,
    );
  }

  void _processTopUp() async {
    if (_selectedCoin == null) {
      _showErrorDialog('Pilih jumlah Apex Coins terlebih dahulu!');
      return;
    }

    final double idrValue = _selectedCoin! * _coinRate;
    final double convertedValue = _convertCurrency(idrValue, _selectedCurrency);

    final box = Hive.box<TopUpRecord>('topup_history');
    final record = TopUpRecord(
      apexCoins: _selectedCoin!,
      idrAmount: idrValue,
      currency: _selectedCurrency,
      timestamp: DateTime.now(),
    );
    await box.add(record);

    await _showNotification(
        'Kamu berhasil membeli $_selectedCoin Apex Coins menggunakan $_selectedCurrency!');

    setState(() {
      _result = convertedValue;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text('⚠️ Kesalahan',
            style: TextStyle(color: Colors.redAccent)),
        content: Text(message, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            child: const Text('Tutup', style: TextStyle(color: Colors.redAccent)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  double _convertCurrency(double idr, String currency) {
    switch (currency) {
      case 'USD':
        return idr / 16000;
      case 'YEN':
        return idr / 110;
      case 'YUAN':
        return idr / 2200;
      default:
        return idr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Top Up Coins',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: 'Riwayat Top Up',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TopUpHistoryScreen()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildCoinButtons(),
            const SizedBox(height: 25),
            _buildCurrencySelector(),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: _processTopUp,
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: const Text(
                'Beli Sekarang',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (_result > 0) ...[
              const SizedBox(height: 25),
              Text(
                'Total: ${_result.toStringAsFixed(2)} $_selectedCurrency',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildCoinButtons() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: _presetCoins.map((coin) {
        final isSelected = _selectedCoin == coin;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCoin = coin;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 150,
            height: 100,
            decoration: BoxDecoration(
              color: isSelected ? Colors.redAccent : Colors.red[400],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? Colors.blue.withOpacity(0.7) : Colors.black54,
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$coin Coins',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCurrencySelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _selectedCurrency,
        dropdownColor: Colors.red[400],
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: 'Pilih Mata Uang',
          labelStyle: TextStyle(color: Colors.white),
        ),
        items: _currencies
            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
            .toList(),
        onChanged: (val) {
          setState(() => _selectedCurrency = val!);
        },
      ),
    );
  }
}

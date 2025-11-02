import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/topup_record.dart';

class DetailHistoryScreen extends StatelessWidget {
  final TopUpRecord record;

  const DetailHistoryScreen({super.key, required this.record});

  Map<String, double> _convertAllCurrencies(double idr) {
    return {
      'IDR': idr,
      'USD': idr / 16000,
      'YEN': idr / 110,
      'YUAN': idr / 2200,
    };
  }

  Map<String, String> _convertAllTimes(DateTime original) {
    final format = DateFormat('dd MMM yyyy HH:mm');
    return {
      'WIB': format.format(original.toUtc().add(const Duration(hours: 7))),
      'WITA': format.format(original.toUtc().add(const Duration(hours: 8))),
      'WIT': format.format(original.toUtc().add(const Duration(hours: 9))),
      'London (GMT)': format.format(original.toUtc()),
    };
  }

  @override
  Widget build(BuildContext context) {
    final currencyMap = _convertAllCurrencies(record.idrAmount);
    final timeMap = _convertAllTimes(record.timestamp);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5A5F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detail Top-Up',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "TOP-UP DETAIL",
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow("Jumlah Apex Coins", "${record.apexCoins} Coins"),
                    const Divider(color: Colors.white24),
                    _buildInfoRow("Tanggal Pembelian", DateFormat('dd MMM yyyy HH:mm').format(record.timestamp)),
                    const Divider(color: Colors.white24),
                    _buildInfoRow("Nominal (IDR)", "Rp ${record.idrAmount.toStringAsFixed(0)}"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Konversi Mata Uang",
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...currencyMap.entries.map(
                      (e) => _buildInfoRow(
                        e.key,
                        e.value.toStringAsFixed(2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Konversi Waktu",
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...timeMap.entries.map(
                      (e) => _buildInfoRow(e.key, e.value),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5A5F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Terima Kasih!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

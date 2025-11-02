import 'package:flutter/material.dart';
import '../models/legend_model.dart';

class LegendDetailScreen extends StatelessWidget {
  final LegendModel legend;
  const LegendDetailScreen({super.key, required this.legend});

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.redAccent),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(legend.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: legend.imageUrl.isNotEmpty
                    ? Image.network(
                        legend.imageUrl,
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 220,
                            color: Colors.grey[900],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                                size: 80,
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 220,
                            color: Colors.grey[900],
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.redAccent),
                            ),
                          );
                        },
                      )
                    : const Icon(Icons.person,
                        size: 100, color: Colors.white54),
              ),
            ),
            const Divider(height: 40, color: Colors.white24),
            _buildDetailRow('Nama Asli', legend.realName),
            _buildDetailRow('Role', legend.role),
            _buildDetailRow('Keterangan', legend.description),
            const Divider(height: 40, color: Colors.white24),
            _buildDetailRow('Taktikal Skill (Q)', legend.tactical),
            _buildDetailRow('Ultimate Skill (Z)', legend.ultimate),
          ],
        ),
      ),
    );
  }
}

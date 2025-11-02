import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/topup_record.dart';
import 'detail_history_screen.dart';

class TopUpHistoryScreen extends StatefulWidget {
  const TopUpHistoryScreen({super.key});

  @override
  State<TopUpHistoryScreen> createState() => _TopUpHistoryScreenState();
}

class _TopUpHistoryScreenState extends State<TopUpHistoryScreen> {
  Future<void> _confirmAndClearAll(Box<TopUpRecord> box) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Hapus semua riwayat?', style: TextStyle(color: Colors.white)),
        content: const Text('Semua riwayat top-up akan dihapus. Lanjutkan?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal', style: TextStyle(color: Colors.grey))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
    if (ok == true) {
      await box.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TopUpRecord>('topup_history');

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Riwayat Top-Up', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            tooltip: 'Hapus semua riwayat',
            onPressed: () => _confirmAndClearAll(box),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<TopUpRecord> b, _) {
            if (b.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada riwayat top-up.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              );
            }

            final records = b.values.toList().cast<TopUpRecord>().reversed.toList();

            return ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: records.length,
              itemBuilder: (context, idx) {
                final rec = records[idx];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent.shade400,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: const Icon(Icons.monetization_on,
                        color: Colors.white, size: 36),
                    title: Text(
                      '${rec.apexCoins} Apex Coins',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: Text(
                      'Mata Uang: ${rec.currency}\nTanggal: ${rec.timestamp.toLocal()}',
                      style: const TextStyle(color: Colors.white70, height: 1.4),
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailHistoryScreen(record: rec),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white70),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: const Color(0xFF1E1E1E),
                            title: const Text('Hapus Riwayat Ini?',
                                style: TextStyle(color: Colors.white)),
                            content: const Text(
                                'Apakah kamu yakin ingin menghapus riwayat ini?',
                                style: TextStyle(color: Colors.white70)),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Batal',
                                      style: TextStyle(color: Colors.grey))),
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Hapus',
                                      style:
                                          TextStyle(color: Colors.redAccent))),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          final keyToDelete = b.keys.firstWhere(
                            (k) {
                              final r = b.get(k);
                              if (r == null) return false;
                              return r.timestamp == rec.timestamp &&
                                  r.apexCoins == rec.apexCoins &&
                                  r.idrAmount == rec.idrAmount;
                            },
                            orElse: () => null,
                          );
                          if (keyToDelete != null) {
                            await b.delete(keyToDelete);
                          }
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

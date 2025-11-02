import 'package:flutter/material.dart';
import '../models/legend_model.dart';
import '../services/apex_api_service.dart';
import 'legend_detail_screen.dart';

class LegendsListScreen extends StatefulWidget {
  const LegendsListScreen({super.key});

  @override
  State<LegendsListScreen> createState() => _LegendsListScreenState();
}

class _LegendsListScreenState extends State<LegendsListScreen> {
  final ApexApiService _apiService = ApexApiService();
  late Future<List<LegendModel>> _legendsFuture;
  List<LegendModel> _allLegends = [];
  List<LegendModel> _filteredLegends = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _legendsFuture = _loadLegends();
  }

  Future<List<LegendModel>> _loadLegends() async {
    final legends = await _apiService.fetchLegends();
    _allLegends = legends;
    _filteredLegends = legends;
    return legends;
  }

  void _filterLegends(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredLegends = _allLegends.where((legend) {
        return legend.name.toLowerCase().contains(_searchQuery) ||
            legend.realName.toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10), 
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          "Legends Wiki",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: FutureBuilder<List<LegendModel>>(
        future: _legendsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Gagal memuat data",
                style: TextStyle(color: Colors.white70),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada data legend",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return Column(
            children: [
              
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.redAccent,
                  onChanged: _filterLegends,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1A1A1C),
                    hintText: "Cari Legend (nama / real name)...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.redAccent),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),

              
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredLegends.length,
                  itemBuilder: (context, index) {
                    final legend = _filteredLegends[index];
                    return Card(
                      color: const Color(0xFF1A1A1C),
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.redAccent, width: 1),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LegendDetailScreen(legend: legend),
                            ),
                          );
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: legend.imageUrl.isNotEmpty
                              ? Image.network(
                                  legend.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                                  },
                                )
                              : const Icon(Icons.person, size: 50, color: Colors.grey),
                        ),
                        title: Text(
                          legend.name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          legend.realName,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.redAccent, size: 18),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

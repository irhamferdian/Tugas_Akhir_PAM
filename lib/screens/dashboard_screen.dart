import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'region_screen.dart';
import 'map_rotation_screen.dart';
import 'legend_list_screen.dart';
import 'player_stats_screen.dart';
import 'topup_screen.dart';
import 'profile_page_screen.dart';
import 'message_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String username = 'Pengguna Apex';
  String? profileImagePath; // FOTO DINAMIS

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final name = prefs.getString('username') ?? 'Pengguna Apex';
    final image = prefs.getString('profileImage'); // PATH FOTO

    setState(() {
      username = name;
      profileImagePath = image;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Map Rotation',
      'icon': Icons.map_outlined,
      'page': const MapRotationScreen()
    },
    {
      'title': 'Legends Wiki',
      'icon': Icons.person_search_outlined,
      'page': const LegendsListScreen()
    },
    {
      'title': 'Player Stats',
      'icon': Icons.analytics_outlined,
      'page': const PlayerStatsScreen()
    },
    {
      'title': 'Top Up Coins',
      'icon': Icons.monetization_on_outlined,
      'page': const TopUpScreen()
    },
    {
      'title': 'Region Anda',
      'icon': Icons.public,
      'page': const RegionScreen()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade700,
        title: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Row(
            children: [
              const Icon(Icons.dashboard_customize, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Selamat datang, $username',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: _logout,
            ),
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor: const Color(0xFF1B1B1B),
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(username),
              accountEmail: const Text(""),
              currentAccountPicture: CircleAvatar(
                backgroundImage: profileImagePath != null
                    ? FileImage(File(profileImagePath!)) as ImageProvider
                    : const AssetImage('assets/images/aku.jpg'),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent, Colors.black87],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text("Profil Saya",
                  style: TextStyle(color: Colors.white)),
              onTap: () async {
                await Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const ProfilePage()));

                // Kembali dari ProfilePage → refresh foto
                _loadUserData();
              },
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Colors.white),
              title: const Text("Kesan & Pesan",
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const MessagePage())),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => item['page'])),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'], color: Colors.white, size: 42),
                    const SizedBox(height: 12),
                    Text(
                      item['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

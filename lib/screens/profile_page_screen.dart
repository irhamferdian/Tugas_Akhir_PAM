import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Profil Saya",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/aku.jpg'),
                ),
                const SizedBox(height: 20),

                
                const Text(
                  "Irham Ferdiansyah",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                const Divider(color: Colors.redAccent, thickness: 1),
                const SizedBox(height: 12),

                
                _buildInfoRow("NIM", "124230139"),
                const SizedBox(height: 8),

                
                _buildInfoRow("Tanggal Lahir", "16 Oktober 2004"),
                const SizedBox(height: 8),

                
                _buildInfoRow("Hobi", "Bermain game FPS Ranked PEaK",
                    isLongText: true),
                const SizedBox(height: 20),

                const Divider(color: Colors.redAccent, thickness: 1),
                const SizedBox(height: 12),

              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value,
      {bool isLongText = false}) {
    return Row(
      crossAxisAlignment:
          isLongText ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

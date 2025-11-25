import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? imagePath;
  String username = 'guest'; // default sementara

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // load username dan image berdasarkan username
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username') ?? 'guest';
    final savedImage = prefs.getString('profile_image_$savedUsername');

    setState(() {
      username = savedUsername;
      imagePath = savedImage;
    });
  }

  // simpan image untuk username saat ini
  Future<void> _pickImage(bool fromCamera) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_$username', picked.path);

      setState(() {
        imagePath = picked.path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto profil berhasil diperbarui!")),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Text(
                "Pilih Sumber Foto",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _pickImage(true);
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Kamera"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _pickImage(false);
                    },
                    icon: const Icon(Icons.photo),
                    label: const Text("Galeri"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // optional: tombol untuk menghapus foto akun ini (reset ke asset default)
  Future<void> _removeProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image_$username');
    setState(() {
      imagePath = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Foto profil direset ke default")),
    );
  }

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
          onPressed: () => Navigator.pop(context, true), // return true supaya caller tau ada perubahan
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
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: imagePath != null
                        ? FileImage(File(imagePath!))
                        : const AssetImage('assets/images/apex.png') as ImageProvider,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "(Tekan foto untuk mengganti)",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _showImageSourceDialog,
                      icon: const Icon(Icons.edit),
                      label: const Text("Ubah Foto"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _removeProfileImage,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text("Reset Foto"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    ),
                  ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value, {bool isLongText = false}) {
    return Row(
      crossAxisAlignment: isLongText ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

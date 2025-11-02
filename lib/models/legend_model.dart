class LegendModel {
  final String name;
  final String realName;
  final String tactical;
  final String ultimate;
  final String role;
  final String description;
  final String imageUrl;

  LegendModel({
    required this.name,
    required this.realName,
    required this.tactical,
    required this.ultimate,
    required this.role,
    required this.description,
    required this.imageUrl,
  });

  factory LegendModel.fromJson(Map<String, dynamic> json) {
    print('Legend data parsed: ${json['name']}');
    return LegendModel(
      name: json['name']?.toString() ?? 'Unknown Legend',
      realName: json['real_name']?.toString() ?? 'N/A',
      tactical: json['tactical']?.toString() ?? 'Tidak diketahui',
      ultimate: json['ultimate']?.toString() ?? 'Tidak diketahui',
      role: json['role']?.toString() ?? 'Unassigned',
      description: json['description']?.toString() ?? 'Tidak ada deskripsi.',
      imageUrl: json['image_url']?.toString() ?? '', // kosong aja biar aman
    );
  }
}

class PlayerStatsModel {
  final String name;
  final String platform;
  final int level;
  final String rankName;
  final String rankImg;

  PlayerStatsModel({
    required this.name,
    required this.platform,
    required this.level,
    required this.rankName,
    required this.rankImg,
  });

  factory PlayerStatsModel.fromJson(Map<String, dynamic> json) {
    final global = json['global'] as Map<String, dynamic>?;

    if (global == null) {
      throw Exception('Data pemain tidak ditemukan dalam respons global.');
    }

    final rank = global['rank'] as Map<String, dynamic>?;
    
    
    final rankName = rank?['rankName'] as String? ?? 'Unranked';
    final rankImg = rank?['rankImg'] as String? ?? ''; 

    return PlayerStatsModel(
      name: global['name'] as String? ?? 'N/A',
      platform: global['platform'] as String? ?? 'N/A',
      level: global['level'] as int? ?? 0,
      rankName: '$rankName ${rank?['rankDiv'] ?? ''}'.trim(), 
      rankImg: rankImg,
    );
  }
}
class MapRotation {
  final String currentMap;
  final String nextMap;
  final String remainingTime;
  final String mode; 
  final String imageUrl;

  MapRotation({
    required this.currentMap,
    required this.nextMap,
    required this.remainingTime,
    required this.mode,
    required this.imageUrl,
  });

  
  Duration _parseDuration(String time) {
    int hours = 0;
    int minutes = 0;
    

    RegExp hourRegex = RegExp(r'(\d+)\s*[jh]');
    var hourMatch = hourRegex.firstMatch(time);
    if (hourMatch != null) {
      
      hours = int.tryParse(hourMatch.group(1) ?? '0') ?? 0;
    }

    
    RegExp minuteRegex = RegExp(r'(\d+)\s*m');
    var minuteMatch = minuteRegex.firstMatch(time);
    if (minuteMatch != null) {
      minutes = int.tryParse(minuteMatch.group(1) ?? '0') ?? 0;
    }
    
    return Duration(hours: hours, minutes: minutes);
  }

  
  DateTime get endTimeUtc {
    
    final duration = _parseDuration(remainingTime);
    return DateTime.now().toUtc().add(duration);
  }


  factory MapRotation.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>?;
    final next = json['next'] as Map<String, dynamic>?;

    if (current == null || next == null) {
        
        throw FormatException("Struktur JSON Rotasi Peta tidak valid. Objek 'current' atau 'next' hilang.");
    }
    
    return MapRotation(
      
      currentMap: current['map']?.toString() ?? 'Unknown Current Map', 
      imageUrl: current['asset']?.toString() ?? '',
      nextMap: next['map']?.toString() ?? 'Unknown Next Map',
      
      remainingTime: current['remainingTimer']?.toString() ?? 'N/A', 
      mode: 'Mode:Trios', 
      
    );
  }
}

class ApiDataException implements Exception {
  final String message;
  ApiDataException({this.message = 'Gagal memuat data dari API.'});
  @override
  String toString() => 'ApiDataException: $message';
}

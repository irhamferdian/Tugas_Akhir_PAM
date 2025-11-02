import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/legend_model.dart';
import '../models/player_stats_model.dart';
import '../models/map_rotation.dart';


class ApiDataException implements Exception {
  final String message;
  ApiDataException({required this.message});
  @override
  String toString() => "ApiDataException: $message";
}

class ApexApiService {
  final String _mozaKey = ApiConfig.mozaApiKey;
  final String _mozaBaseUrl = ApiConfig.mozaBaseUrl;
  final String _jsonBinBaseUrl = ApiConfig.jsonBinBaseUrl;

  
 Future<List<LegendModel>> fetchLegends() async {
  final url = Uri.parse('$_jsonBinBaseUrl/${ApiConfig.jsonBinLegendsId}/latest');
  final response = await http.get(url, headers: {
    'X-Master-Key': _mozaKey,
  });

  if (response.statusCode == 200) {
    final body = json.decode(response.body);

    
    final List legendsJson = body['record']?['legends'] ?? [];

    if (legendsJson.isEmpty) {
      throw ApiDataException(message: "Data Legends kosong atau struktur JSON tidak sesuai.");
    }

    return legendsJson
        .map((e) => LegendModel.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw ApiDataException(
      message: 'Gagal memuat Legends (status: ${response.statusCode})',
    );
  }
}


  
 Future<MapRotation> fetchMapRotation() async {
  final url = Uri.parse('$_mozaBaseUrl/maprotation?auth=$_mozaKey');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      
      final br = data['battle_royale'] ?? data['br'] ?? data;

      return MapRotation.fromJson(br);
    } else {
      throw ApiDataException(
        message: 'Gagal memuat Map Rotation (status: ${response.statusCode})',
      );
    }
  } catch (e) {
    throw ApiDataException(message: 'Kesalahan jaringan: $e');
  }
}


  
  Future<PlayerStatsModel> fetchPlayerStats({
    required String playerName,
    String platform = 'PC',
  }) async {
    final url = Uri.parse(
        '$_mozaBaseUrl/bridge?auth=$_mozaKey&player=$playerName&platform=$platform');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PlayerStatsModel.fromJson(data);
      } else {
        throw ApiDataException(
          message: 'Gagal memuat Player Stats (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw ApiDataException(message: 'Kesalahan jaringan: $e');
    }
  }
}

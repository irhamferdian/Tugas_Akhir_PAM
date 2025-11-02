import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RegionScreen extends StatefulWidget {
  const RegionScreen({super.key});

  @override
  State<RegionScreen> createState() => _RegionScreenState();
}

class _RegionScreenState extends State<RegionScreen> {
  bool isLoading = false;
  String region = '';
  String locationInfo = '';
  String fullAddress = '';
  LatLng? currentLocation;

  Future<void> _cekRegion() async {
    setState(() {
      isLoading = true;
      region = '';
      locationInfo = '';
      fullAddress = '';
      currentLocation = null;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen.';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final country = p.country ?? 'Unknown';
        final detectedRegion = _getRegionFromCountry(country);

        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
          locationInfo =
              'Koordinat: (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})';
          fullAddress =
              '${p.street ?? ''}, ${p.locality ?? ''}, ${p.subAdministrativeArea ?? ''}, ${p.administrativeArea ?? ''}, ${p.country ?? ''}';
          region = detectedRegion;
        });
      }
    } catch (e) {
      setState(() {
        region = 'Gagal mendeteksi lokasi: $e';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  String _getRegionFromCountry(String country) {
    final apacSouth = [
      'China',
      'Indonesia',
      'Malaysia',
      'Singapore',
      'Philippines',
      'Thailand',
      'Vietnam',
      'Australia',
      'New Zealand'
    ];
    final apacNorth = ['Japan', 'South Korea'];
    final emea = [
      'United Kingdom',
      'Germany',
      'France',
      'Italy',
      'Spain',
      'Netherlands',
      'Turkey',
      'United Arab Emirates',
      'Saudi Arabia'
    ];
    final na = ['United States', 'Canada'];
    final sa = ['Brazil', 'Argentina', 'Chile', 'Peru'];

    if (apacSouth.contains(country)) return 'APAC South';
    if (apacNorth.contains(country)) return 'APAC North';
    if (emea.contains(country)) return 'EMEA';
    if (na.contains(country)) return 'North America';
    if (sa.contains(country)) return 'South America';
    return 'Unknown Region';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('Region Anda'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  if (currentLocation != null)
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: currentLocation!,
                            initialZoom: 14,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.apexapp',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: currentLocation!,
                                  width: 60,
                                  height: 60,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 45,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: Center(
                        child: Text(
                          'Tekan tombol di bawah untuk mendeteksi lokasi kamu.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  
                  ElevatedButton.icon(
                    icon: const Icon(Icons.my_location),
                    label: Text(currentLocation == null
                        ? 'Cek Region'
                        : 'Cek Ulang Lokasi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading ? null : _cekRegion,
                  ),

                  const SizedBox(height: 16),

                  
                  if (region.isNotEmpty) ...[
                    Card(
                      color: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('📍 Lokasi Terdeteksi',
                                style: TextStyle(
                                    color: Colors.redAccent.shade100,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(locationInfo,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            const SizedBox(height: 6),
                            Text(fullAddress,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14)),

                            const Divider(height: 20, color: Colors.white30),

                            Text('🌍 Region Apex Legends',
                                style: TextStyle(
                                    color: Colors.redAccent.shade100,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(region,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ]
                ],
              ),
      ),
    );
  }
}

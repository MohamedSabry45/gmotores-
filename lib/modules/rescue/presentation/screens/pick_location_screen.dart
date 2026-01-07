import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/config/style/app_spacing.dart';

class PickedLocation {
  final double latitude;
  final double longitude;

  const PickedLocation({required this.latitude, required this.longitude});
}

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
  });

  final double? initialLatitude;
  final double? initialLongitude;

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  final MapController _mapController = MapController();
  LatLng _selected = const LatLng(30.0444, 31.2357);
  bool _loadingLocation = false;

  @override
  void initState() {
    super.initState();
    final lat = widget.initialLatitude;
    final lng = widget.initialLongitude;
    if (lat != null && lng != null) {
      _selected = LatLng(lat, lng);
    }
  }

  Future<void> _goToMyLocation() async {
    setState(() => _loadingLocation = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError('الرجاء تشغيل خدمات الموقع');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        _showError('لم يتم منح صلاحية الموقع');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final latLng = LatLng(pos.latitude, pos.longitude);

      setState(() => _selected = latLng);
      _mapController.move(latLng, 16);
    } catch (_) {
      _showError('تعذر تحديد موقعك الحالي');
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _confirm() {
    Navigator.pop(
      context,
      PickedLocation(latitude: _selected.latitude, longitude: _selected.longitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تحديد الموقع'),
          actions: [
            TextButton(
              onPressed: _confirm,
              child: const Text('تأكيد'),
            ),
          ],
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _selected,
                initialZoom: 13,
                onTap: (tapPosition, point) => setState(() => _selected = point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'reservation_workshop',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selected,
                      width: 46,
                      height: 46,
                      child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE6E8EC)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 22,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Lat: ${_selected.latitude.toStringAsFixed(6)}\nLng: ${_selected.longitude.toStringAsFixed(6)}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87, height: 1.2),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        SizedBox(
                          height: 42,
                          child: OutlinedButton.icon(
                            onPressed: _loadingLocation ? null : _goToMyLocation,
                            icon: _loadingLocation
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.my_location, size: 18),
                            label: const Text('موقعي'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton.icon(
                      onPressed: _confirm,
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('تأكيد الموقع'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

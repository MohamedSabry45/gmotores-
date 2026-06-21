import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

import '../../../domain/entities/vehicle_details.dart';

class VehicleGallery extends StatefulWidget {
  final List<VehicleMedia> media;

  const VehicleGallery({
    super.key,
    required this.media,
  });

  @override
  State<VehicleGallery> createState() => _VehicleGalleryState();
}

class _VehicleGalleryState extends State<VehicleGallery> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = widget.media;
    if (media.isEmpty) {
      return Container(
        color: AppColors.brandSurface,
        alignment: Alignment.center,
        child: const Icon(Icons.directions_car, color: AppColors.grey7, size: 56),
      );
    }

    return PageView.builder(
      controller: _controller,
      onPageChanged: (v) {
        if (!mounted) return;
        setState(() => _index = v);
      },
      itemCount: media.length,
      itemBuilder: (context, index) {
        final item = media[index];
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item.filePath,
              fit: BoxFit.cover,
              errorBuilder: (context, _, __) {
                return Container(
                  color: AppColors.brandSurface,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined, color: AppColors.grey7, size: 40),
                );
              },
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  media.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _index ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _index ? Colors.white : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

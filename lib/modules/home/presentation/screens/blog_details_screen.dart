import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/modules/home/domain/entities/blog_post.dart';

class BlogDetailsScreen extends StatelessWidget {
  const BlogDetailsScreen({super.key, required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    final title = post.title.trim();
    final content = post.content.trim();
    final imageUrl = (post.imageUrl ?? '').trim();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'news.title'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: imageUrl.isEmpty
                ? Image.asset('assets/images/bummy.jpg', fit: BoxFit.cover)
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset('assets/images/bummy.jpg', fit: BoxFit.cover),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title.isEmpty ? '-' : title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.25,
              ),
            ),
          ),
          if (content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
      backgroundColor: AppColors.brandDark,
    );
  }
}

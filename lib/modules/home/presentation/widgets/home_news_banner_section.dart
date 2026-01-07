import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';
import 'package:reservation_workshop/modules/home/domain/entities/blog_post.dart';

class HomeNewsBannerSection extends StatelessWidget {
  const HomeNewsBannerSection({
    super.key,
    required this.posts,
  });

  final List<BlogPost> posts;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4),
          child: Text(
            t(context, 'home.news_title', ar: 'الاخبار', en: 'News'),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 176,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _NewsBannerCard(post: posts[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _NewsBannerCard extends StatelessWidget {
  const _NewsBannerCard({required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    final title = post.title.trim();
    final dateText = post.blogDate.trim();
    final imageUrl = (post.imageUrl ?? '').trim();

    return SizedBox(
      width: 320,
      child: AppCard(
        padding: EdgeInsets.zero,
        borderRadius: 0,
        borderColor: const Color(0xFFEFF1F5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
        ],
        child: SizedBox(
          height: 122,
          child: Row(
            children: [
              Container(
                width: 120,
                height: double.infinity,
                color: const Color(0xFFF3F4F6),
                child: imageUrl.isEmpty
                    ? Image.asset('assets/images/logo.png', fit: BoxFit.cover)
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title.isEmpty ? '-' : title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (dateText.isNotEmpty)
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.grey7),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                dateText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.grey7,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

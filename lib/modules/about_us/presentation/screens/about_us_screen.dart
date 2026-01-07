import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';

import '../cubit/about_us_cubit.dart';
import '../cubit/about_us_state.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: isLtr(context) ? ui.TextDirection.ltr : ui.TextDirection.rtl,
          child: BlocBuilder<AboutUsCubit, AboutUsState>(
            builder: (context, state) {
              if (state is AboutUsLoading || state is AboutUsInitial) {
                return const _LoadingView();
              }

              if (state is AboutUsError) {
                return _ErrorView(
                  message: state.message,
                  onRetry: () => context.read<AboutUsCubit>().load(),
                );
              }

              if (state is AboutUsSuccess) {
                return _ContentView(text: state.data.aboutUs);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  const _ContentView({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final normalized = text.replaceAll('\r\n', '\n').trim();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
      children: [
        AppCard(
          padding: const EdgeInsets.all(16),
          backgroundColor: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.brandPrimarySoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.info_outline, color: AppColors.brandPrimary, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t(context, 'about.about_center_title', ar: 'عن المركز', en: 'About the center'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.brandDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      t(
                        context,
                        'about.about_center_subtitle',
                        ar: 'معلومات مختصرة عن خبراتنا وخدماتنا ومعايير الجودة لدينا.',
                        en: 'A brief overview of our experience, services, and quality standards.',
                      ),
                      style: const TextStyle(color: Colors.black54, height: 1.35, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: SelectionArea(
            child: SelectableText(
              normalized.isEmpty ? t(context, 'about.no_data', ar: 'لا توجد بيانات حالياً', en: 'No data available') : normalized,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.9,
                color: AppColors.brandDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
      children: [
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 140, color: const Color(0xFFF1F3F5)),
                    const SizedBox(height: 10),
                    Container(height: 12, width: double.infinity, color: const Color(0xFFF1F3F5)),
                    const SizedBox(height: 6),
                    Container(height: 12, width: 220, color: const Color(0xFFF1F3F5)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const AppCard(
          padding: EdgeInsets.all(16),
          child: _LoadingLines(),
        ),
      ],
    );
  }
}

class _LoadingLines extends StatelessWidget {
  const _LoadingLines();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _LoadingLine(widthFactor: 1),
        SizedBox(height: 10),
        _LoadingLine(widthFactor: .95),
        SizedBox(height: 10),
        _LoadingLine(widthFactor: .9),
        SizedBox(height: 10),
        _LoadingLine(widthFactor: .96),
        SizedBox(height: 10),
        _LoadingLine(widthFactor: .8),
      ],
    );
  }
}

class _LoadingLine extends StatelessWidget {
  const _LoadingLine({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 12,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.brandPrimarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline, color: AppColors.brandPrimary, size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            t(context, 'about.load_failed', ar: 'تعذر تحميل البيانات', en: 'Failed to load data'),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRetry,
              child: Text(t(context, 'about.retry', ar: 'إعادة المحاولة', en: 'Retry')),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyCarScreen extends StatelessWidget {
  const BuyCarScreen({super.key});

  static const _cars = <_BuyCarListingItem>[
    _BuyCarListingItem(
      id: '1',
      brand: 'Mercedes',
      model: 'C180',
      year: '2024',
      trim: 'Unspecified Trim',
      priceEgp: 3125000,
      downPaymentEgp: 625000,
      condition: 'Used',
      km: 10000,
      transmission: 'Automatic',
      location: 'Giza, Sheikh Zayed',
      timeAgo: '18 minutes ago',
      isPremium: true,
    ),
    _BuyCarListingItem(
      id: '2',
      brand: 'Mercedes',
      model: 'GLC 200',
      year: '2023',
      trim: 'AMG Line',
      priceEgp: 4650000,
      downPaymentEgp: 930000,
      condition: 'Used',
      km: 22000,
      transmission: 'Automatic',
      location: 'Cairo, New Cairo',
      timeAgo: '2 hours ago',
      isPremium: true,
    ),
    _BuyCarListingItem(
      id: '3',
      brand: 'Mercedes',
      model: 'E200',
      year: '2022',
      trim: 'Exclusive',
      priceEgp: 3890000,
      downPaymentEgp: 780000,
      condition: 'Used',
      km: 35000,
      transmission: 'Automatic',
      location: 'Alexandria, Smouha',
      timeAgo: 'Yesterday',
      isPremium: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Buy car',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: _cars.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final item = _cars[index];
            return _BuyCarListingCard(
              item: item,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BuyCarDetailsScreen(item: item),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _BuyCarListingItem {
  final String id;
  final String brand;
  final String model;
  final String year;
  final String trim;
  final int priceEgp;
  final int downPaymentEgp;
  final String condition;
  final int km;
  final String transmission;
  final String location;
  final String timeAgo;
  final bool isPremium;

  const _BuyCarListingItem({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.trim,
    required this.priceEgp,
    required this.downPaymentEgp,
    required this.condition,
    required this.km,
    required this.transmission,
    required this.location,
    required this.timeAgo,
    required this.isPremium,
  });
}

String _formatEgp(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final idxFromEnd = s.length - i;
    buf.write(s[i]);
    if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
      buf.write(',');
    }
  }

  final raw = buf.toString();
  return raw.endsWith(',') ? raw.substring(0, raw.length - 1) : raw;
}

class _BuyCarListingCard extends StatelessWidget {
  final _BuyCarListingItem item;
  final VoidCallback onTap;

  const _BuyCarListingCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.brandOutline),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/mercedes.png',
                        fit: BoxFit.cover,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.45),
                              Colors.black.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Row(
                          children: [
                            if (item.isPremium)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.star, size: 14, color: Colors.black87),
                                    SizedBox(width: 6),
                                    Text(
                                      'Premium',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: Row(
                          children: [
                            _IconCircleButton(icon: Icons.share_outlined),
                            const SizedBox(width: 10),
                            _IconCircleButton(icon: Icons.notifications_none_outlined),
                            const SizedBox(width: 10),
                            _IconCircleButton(icon: Icons.favorite_border),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${_formatEgp(item.priceEgp)} EGP',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.brandPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.brandDark,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'D.P ${_formatEgp(item.downPaymentEgp)} EGP',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${item.brand} ${item.model} ${item.year}',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.trim,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey7,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _PillChip(text: item.brand),
                        _PillChip(text: item.model),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _InfoIconText(icon: Icons.history, text: item.condition),
                        const SizedBox(width: 12),
                        _InfoIconText(icon: Icons.speed, text: '${_formatEgp(item.km)} KM'),
                        const SizedBox(width: 12),
                        _InfoIconText(icon: Icons.settings, text: item.transmission),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.grey7),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.grey7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: AppColors.grey7),
                            const SizedBox(width: 6),
                            Text(
                              item.timeAgo,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.grey7,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.call,
                            label: 'WhatsApp',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.call,
                            label: 'Call',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  final IconData icon;

  const _IconCircleButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.92),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: AppColors.brandDark),
    );
  }
}

class _PillChip extends StatelessWidget {
  final String text;

  const _PillChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.brandOutline),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppColors.brandDark),
      ),
    );
  }
}

class _InfoIconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoIconText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.grey7),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.grey1),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white3,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.brandOutline),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.brandDark),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuyCarDetailsScreen extends StatelessWidget {
  final _BuyCarListingItem item;

  const BuyCarDetailsScreen({
    super.key,
    required this.item,
  });

  Future<void> _openSalesPurchaseReport(BuildContext context) async {
    const url = 'https://erp.gmotors-eg.com/checkcar/report/18/9c3486064deec66b62af10d5695a16be';
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to open report')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/mercedes.png',
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: _TopNavButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Row(
                        children: [
                          _TopNavButton(icon: Icons.share_outlined, onTap: () {}),
                          const SizedBox(width: 10),
                          _TopNavButton(icon: Icons.favorite_border, onTap: () {}),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: i == 2 ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == 2 ? Colors.white : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 76,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final selected = index == 0;
                  return Container(
                    width: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? AppColors.brandDark : AppColors.brandOutline,
                        width: selected ? 1.4 : 1.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset('assets/images/mercedes.png', fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.brandOutline),
                        ),
                        child: const Icon(Icons.directions_car_filled_outlined, color: AppColors.brandDark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.brand} ${item.model} ${item.year}',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.trim,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.grey7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.brandOutline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_formatEgp(item.priceEgp)} EGP',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.brandPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.account_balance_wallet_outlined, size: 18, color: AppColors.grey7),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Lowest Down Payment by the Showroom',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.grey7,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_formatEgp(item.downPaymentEgp)} EGP',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 18, color: AppColors.grey7),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.location,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.grey7,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 18, color: AppColors.grey7),
                            const SizedBox(width: 8),
                            Text(
                              item.timeAgo,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.grey7,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Material(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => _openSalesPurchaseReport(context),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.brandOutline),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.white2,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.brandOutline),
                              ),
                              child: const Icon(
                                Icons.description_outlined,
                                size: 18,
                                color: AppColors.brandDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'تفاصيل كشف البيع والشراء',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.brandDark,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.grey7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(icon: Icons.attach_money, label: 'Price Inquiry', onTap: () {}),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(icon: Icons.call, label: 'WhatsApp', onTap: () {}),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(icon: Icons.call, label: 'Call', onTap: () {}),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopNavButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white.withOpacity(0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: AppColors.brandDark),
        ),
      ),
    );
  }
}

/* ===================== CAR HEADER ===================== */

class _CarHeaderCard extends StatelessWidget {
  const _CarHeaderCard({
    required this.title,
    required this.updatedAt,
    required this.batteryPercent,
    required this.rangeKm,
    required this.imageAsset,
  });

  final String title;
  final String updatedAt;
  final int batteryPercent;
  final int rangeKm;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1a2942),
            Color(0xFF2d3f5f),
            Color(0xFF3d5275),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatChip(
                icon: Icons.battery_charging_full,
                text: '$batteryPercent%',
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: Icons.route,
                text: '$rangeKm km',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            updatedAt,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF8B94A8),
            ),
          ),
          const SizedBox(height: 20),
          Image.asset(
            imageAsset,
            height: 160,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == 2 ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == 2 ? Colors.white : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== STAT CHIP ===================== */

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== INFO BANNER ===================== */

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2B42),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Vehicle unlocked + 1 more',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
        ],
      ),
    );
  }
}

/* ===================== SECTION HEADER ===================== */

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF8B94A8),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        if (title == 'REMOTE CONTROLS')
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Customize',
              style: TextStyle(
                color: Color(0xFF60A5FA),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

/* ===================== REMOTE CONTROLS ===================== */

class _RemoteControlsCard extends StatelessWidget {
  const _RemoteControlsCard({required this.items});

  final List<_RemoteControlItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2B42),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((e) => _RemoteControlButton(item: e)).toList(),
      ),
    );
  }
}

class _RemoteControlItem {
  const _RemoteControlItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

class _RemoteControlButton extends StatelessWidget {
  const _RemoteControlButton({required this.item});

  final _RemoteControlItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF263750),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(item.icon, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          item.label,
          style: const TextStyle(
            color: Color(0xFFD1D5DB),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/* ===================== CHARGING ===================== */

class _ChargingCard extends StatelessWidget {
  const _ChargingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2B42),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Charging Cable Disconnected',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.ev_station, color: Color(0xFF8B94A8), size: 22),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Connect the charging cable to start charging.',
                  style: TextStyle(
                    color: Color(0xFF8B94A8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
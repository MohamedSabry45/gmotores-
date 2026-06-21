import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/modules/spare_parts/domain/entities/spare_cart_item.dart';
import 'package:reservation_workshop/modules/spare_parts/presentation/cubits/cart_cubit/cart_cubit_exports.dart';

class CartItemsList extends StatelessWidget {
  final List<SpareCartItem> items;

  const CartItemsList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CartItemTile(item: i),
            ),
          )
          .toList(),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final SpareCartItem item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brandOutline.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.brandPrimarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.build_outlined, color: AppColors.brandPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.brandDark,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'SKU: ${item.product.sku}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey7,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QtyButton(
                      icon: item.quantity <= 1 ? Icons.delete_outline : Icons.remove,
                      onTap: () => context.read<CartCubit>().decrement(item),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white2,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.brandOutline.withOpacity(0.35)),
                      ),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandDark),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _QtyButton(
                      icon: Icons.add,
                      onTap: () => context.read<CartCubit>().increment(item),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(item.unitPrice).toStringAsFixed(2)} EGP',
                          style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandDark),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total: ${(item.lineTotal).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.grey7, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.brandPrimary, width: 1.6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.brandPrimary, size: 22),
      ),
    );
  }
}

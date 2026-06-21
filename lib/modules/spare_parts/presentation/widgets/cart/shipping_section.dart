import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/modules/branch/presentation/cubits/branch_cubit/branch_cubit.dart';
import 'package:reservation_workshop/modules/branch/presentation/cubits/branch_cubit/branch_state.dart';
import 'package:reservation_workshop/modules/branch/domain/entities/branch.dart';

class ShippingSection extends StatefulWidget {
  final TextEditingController shippingDetailsController;
  final TextEditingController shippingAddressController;
  final TextEditingController shippingStatusController;
  final TextEditingController deliveredToController;

  final String? initialShippingType;
  final int? initialBranchId;
  final ValueChanged<String>? onShippingTypeChanged;
  final ValueChanged<int?>? onBranchChanged;

  const ShippingSection({
    super.key,
    required this.shippingDetailsController,
    required this.shippingAddressController,
    required this.shippingStatusController,
    required this.deliveredToController,
    this.initialShippingType,
    this.initialBranchId,
    this.onShippingTypeChanged,
    this.onBranchChanged,
  });

  @override
  State<ShippingSection> createState() => _ShippingSectionState();
}

class _ShippingSectionState extends State<ShippingSection> {
  static const List<String> _types = ['delivery', 'pickup'];
  String? _selectedType;
  int? _selectedBranchId;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialShippingType ?? 'delivery';
    _selectedBranchId = widget.initialBranchId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BranchCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors.brandOutline.withOpacity(0.35)),
    );

    InputDecoration decorate({String? hint}) {
      return InputDecoration(
        filled: true,
        fillColor: AppColors.white2,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.brandDark,
        ),
        hintText: hint,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.brandPrimary, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brandOutline.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.brandPrimarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.local_shipping_outlined, color: AppColors.brandPrimary),
              ),
              const SizedBox(width: 10),
              Text(
                'Shipping',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.brandDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Shipping type',
            style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandDark),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: decorate(hint: 'Select shipping type'),
            items: _types.map((t) {
              final label = t == 'delivery' ? 'Delivery' : 'Pickup';
              return DropdownMenuItem(value: t, child: Text(label));
            }).toList(),
            onChanged: (v) {
              setState(() {
                _selectedType = v;
                if (v != 'pickup') {
                  _selectedBranchId = null;
                }
              });
              widget.onShippingTypeChanged?.call(v ?? '');
              widget.onBranchChanged?.call(v == 'pickup' ? _selectedBranchId : null);
            },
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandDark),
          ),
          if (_selectedType == 'pickup') ...[
            const SizedBox(height: 12),
            const Text(
              'Branch',
              style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandDark),
            ),
            const SizedBox(height: 8),
            BlocBuilder<BranchCubit, BranchState>(
              builder: (context, state) {
                if (state is BranchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is BranchError) {
                  return DropdownButtonFormField<int>(
                    value: null,
                    decoration: decorate(hint: 'Failed to load branches'),
                    items: const [],
                    onChanged: null,
                    style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandDark),
                  );
                }
                final branches = state is BranchSuccess ? state.branches : <Branch>[];
                return DropdownButtonFormField<int>(
                  value: _selectedBranchId,
                  decoration: decorate(hint: 'Select branch'),
                  items: branches.map((b) {
                    return DropdownMenuItem(value: b.id, child: Text(b.name));
                  }).toList(),
                  onChanged: (v) {
                    setState(() => _selectedBranchId = v);
                    widget.onBranchChanged?.call(v);
                  },
                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandDark),
                );
              },
            ),
          ],
          const SizedBox(height: 12),
          const Text(
            'Shipping details',
            style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandDark),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.shippingDetailsController,
            decoration: decorate(),
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandDark),
          ),
          const SizedBox(height: 12),
          const Text(
            'Shipping address',
            style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandDark),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.shippingAddressController,
            decoration: decorate(),
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandDark),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Shipping status',
                  style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandDark),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Delivered to',
                  style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.shippingStatusController,
                  decoration: decorate(),
                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandDark),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: widget.deliveredToController,
                  decoration: decorate(),
                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandDark),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/config/style/app_spacing.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';

import '../../data/models/sell_invoice_model.dart';
import 'invoice_details_args.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  const InvoiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final invoice = args is InvoiceDetailsArgs ? args.invoice : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: invoice == null
              ? const Center(child: Text('No invoice selected'))
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: _Body(invoice: invoice),
                  ),
                ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final SellInvoiceModel invoice;

  const _Body({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            backgroundColor: AppColors.brandSurface,
            borderColor: AppColors.brandOutline,
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.invoiceNo.trim().isEmpty ? 'Invoice' : invoice.invoiceNo,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.brandDark,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _kv('Status', invoice.status),
                _kv('Payment', invoice.paymentStatus),
                _kv('Date', invoice.transactionDate),
                _kv('Total', invoice.finalTotal.toStringAsFixed(2)),
                if (invoice.contact != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Customer',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.brandDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _kv('Name', invoice.contact!.name),
                  _kv('Mobile', invoice.contact!.mobile),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Items',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...invoice.sellLines.map(
            (l) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                backgroundColor: AppColors.brandSurface,
                borderColor: AppColors.brandOutline,
                borderRadius: 16,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (l.note).trim().isEmpty ? 'Item #${l.id}' : l.note,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.brandDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _kv('Qty', l.quantity.toStringAsFixed(2)),
                    _kv('Unit price', l.unitPrice.toStringAsFixed(2)),
                    _kv('Inc tax', l.unitPriceIncTax.toStringAsFixed(2)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              k,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.grey7,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              v.trim().isEmpty ? '-' : v,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.brandDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

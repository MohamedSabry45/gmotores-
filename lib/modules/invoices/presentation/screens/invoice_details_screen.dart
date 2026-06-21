import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        title: const Text('Invoice details'),
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

    final invoiceNo = invoice.invoiceNo.trim().isEmpty ? '-' : invoice.invoiceNo.trim();
    final transactionDate = invoice.transactionDate.trim().isEmpty ? '-' : invoice.transactionDate.trim();
    final paymentMethod = '-';
    final paymentRef = '-';
    final paymentStatus = invoice.paymentStatus.trim().isEmpty ? '-' : invoice.paymentStatus.trim();
    final status = invoice.status.trim().isEmpty ? '-' : invoice.status.trim();

    final subtotal = invoice.totalBeforeTax;
    final discount = invoice.discountAmount;
    final tax = invoice.taxAmount;
    final total = invoice.finalTotal;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            backgroundColor: AppColors.brandSurface,
            borderColor: AppColors.brandOutline,
            borderRadius: 18,
            padding: const EdgeInsets.all(0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(color: AppColors.brandOutline.withValues(alpha: 0.9)),
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _headerRow(['No.', 'Transaction date', 'Payment method']),
                  _valueRow([invoiceNo, transactionDate, paymentMethod], textTheme),
                  _headerRow(['Payment status', 'Status', 'Payment ref']),
                  _valueRow([paymentStatus, status, paymentRef], textTheme),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: invoice.invoiceUrl.trim().isEmpty
                  ? null
                  : () async {
                      final url = invoice.invoiceUrl.trim();
                      final uri = Uri.tryParse(url);
                      if (uri == null) return;
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open invoice'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Items',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            backgroundColor: AppColors.brandSurface,
            borderColor: AppColors.brandOutline,
            borderRadius: 18,
            padding: const EdgeInsets.all(0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(color: AppColors.brandOutline.withValues(alpha: 0.9)),
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _headerRow(['Item', 'Qty', 'Total']),
                  for (final l in invoice.sellLines)
                    _valueRow(
                      [
                        (l.productName.trim().isEmpty ? (l.note.trim().isEmpty ? '-' : l.note) : l.productName.trim()),
                        _n(l.quantity),
                        _n(l.quantity * l.unitPriceIncTax),
                      ],
                      textTheme,
                      center: true,
                      firstAlignStart: true,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Summary',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            backgroundColor: AppColors.brandSurface,
            borderColor: AppColors.brandOutline,
            borderRadius: 18,
            padding: const EdgeInsets.all(0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(color: AppColors.brandOutline.withValues(alpha: 0.9)),
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _headerRow(['Subtotal', 'Discount', 'Tax', 'Total']),
                  _valueRow([
                    _n(subtotal),
                    _n(discount),
                    _n(tax),
                    _n(total),
                  ], textTheme, center: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }

  static TableRow _headerRow(List<String> titles) {
    return TableRow(
      decoration: const BoxDecoration(color: AppColors.brandSurface),
      children: [
        for (final t in titles)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Text(
              t,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.brandPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  static TableRow _valueRow(
    List<String> values,
    TextTheme textTheme, {
    bool center = false,
    bool firstAlignStart = false,
  }) {
    return TableRow(
      decoration: const BoxDecoration(color: AppColors.brandSurface),
      children: [
        for (var i = 0; i < values.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Text(
              values[i].trim().isEmpty ? '-' : values[i],
              textAlign: (firstAlignStart && i == 0)
                  ? TextAlign.start
                  : (center ? TextAlign.center : TextAlign.center),
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.brandDark,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ),
      ],
    );
  }

  static String _n(num v) {
    final asDouble = v.toDouble();
    if ((asDouble - asDouble.roundToDouble()).abs() < 0.000001) {
      return asDouble.toStringAsFixed(0);
    }
    return asDouble.toStringAsFixed(2);
  }
}

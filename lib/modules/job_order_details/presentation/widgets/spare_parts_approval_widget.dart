import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';

import '../../data/models/job_order_spare_part_model.dart';
import '../cubits/job_order_details_cubit/job_order_details_cubit.dart';

class SparePartsApprovalWidget extends StatefulWidget {
  const SparePartsApprovalWidget({super.key, required this.items});

  final List<JobOrderSparePartModel> items;

  @override
  State<SparePartsApprovalWidget> createState() => _SparePartsApprovalWidgetState();
}

class _SparePartsApprovalWidgetState extends State<SparePartsApprovalWidget> {
  String _selected = 'selected';
  bool _isApproving = false;

  double get _total {
    var sum = 0.0;
    for (final e in widget.items) {
      sum += e.lineTotal;
    }
    return sum;
  }

  double get _selectedTotal {
    var sum = 0.0;
    for (final e in widget.items) {
      if (e.clientApproval == 1) {
        sum += e.lineTotal;
      }
    }
    return sum;
  }

  String _formatMoney(double v) {
    final asInt = v.roundToDouble() == v;
    return asInt ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
  }

  Color _priorityColor(String raw) {
    final v = raw.trim().toLowerCase();
    if (v == 'urgent' || v == 'red') return const Color(0xFFEF4444);
    if (v == 'advisory' || v == 'orange' || v == 'yellow') return const Color(0xFFF59E0B);
    return const Color(0xFF111827);
  }

  Widget _priorityDot(String raw) {
    return Center(
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: _priorityColor(raw),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _tab(String value, String label) {
    final isActive = _selected == value;
    return InkWell(
      onTap: () => setState(() => _selected = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : const Color(0xFFF2F3F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE6E8EC)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: isActive ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selected == 'selected'
        ? widget.items.where((e) => e.clientApproval == 1).toList()
        : widget.items.where((e) => e.clientApproval != 1).toList();

    final approveItems = widget.items.where((e) => e.clientApproval == 1).toList();
    final canApprove = approveItems.isNotEmpty && !_isApproving;

    return AppCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      borderColor: const Color(0xFFEFF1F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'sparePartsApproval',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _tab('deselected', 'deselected'),
              const SizedBox(width: 8),
              _tab('selected', 'selected'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _legendDot(const Color(0xFF111827), 'Normal'),
              const SizedBox(width: 14),
              _legendDot(const Color(0xFFF59E0B), 'Advisory'),
              const SizedBox(width: 14),
              _legendDot(const Color(0xFFEF4444), 'Urgent'),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 34,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'item',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'priority',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'qty',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'total',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (filtered.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE6E8EC)),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'لا يوجد قطع غيار حالياً',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.grey7),
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                ...filtered.map((e) {
                  final lineTotal = e.lineTotal;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE6E8EC)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            e.productName.trim().isEmpty ? '-' : e.productName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Expanded(
                          child: _priorityDot(e.productStatus),
                        ),
                        Expanded(
                          child: Text(
                            e.quantityValue == 0 ? '-' : _formatMoney(e.quantityValue),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _formatMoney(lineTotal),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: !canApprove
                            ? null
                            : () async {
                                setState(() => _isApproving = true);
                                try {
                                  final jobOrderId = approveItems.first.jobOrderId;
                                  final productIds = approveItems.map((e) => e.productId).toSet().toList();
                                  final msg = await context.read<JobOrderDetailsCubit>().approveProducts(
                                        jobOrderId: jobOrderId,
                                        productIds: productIds,
                                      );
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(msg)),
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                } finally {
                                  if (mounted) setState(() => _isApproving = false);
                                }
                              },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: canApprove ? Colors.black : const Color(0xFF9CA3AF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _isApproving ? 'Approving...' : 'Approve total',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'total: ${_formatMoney(_selectedTotal)}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

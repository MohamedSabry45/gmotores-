import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';
import 'package:reservation_workshop/core/widgets/logo_image_widget.dart';
import 'package:reservation_workshop/modules/job_estimators/data/datasources/job_estimators_remote_datasource.dart';

import 'job_estimator_details_args.dart';

class JobEstimatorDetailsScreen extends StatefulWidget {
  const JobEstimatorDetailsScreen({super.key});

  @override
  State<JobEstimatorDetailsScreen> createState() => _JobEstimatorDetailsScreenState();
}

class _EstimatorPart {
  final int lineId;
  final int productId;
  final double quantity;
  final int clientApproval; // 1 approved, 0 not
  final String productStatus; // black/orange/red
  final String partName;
  final String partSku;
  final double endUserPrice;

  _EstimatorPart({
    required this.lineId,
    required this.productId,
    required this.quantity,
    required this.clientApproval,
    required this.productStatus,
    required this.partName,
    required this.partSku,
    required this.endUserPrice,
  });

  double get lineTotal => quantity * endUserPrice;

  factory _EstimatorPart.fromJson(Map<String, dynamic> json) {
    double _toDouble(String? s) => double.tryParse((s ?? '').toString()) ?? 0.0;
    int _toInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;
    return _EstimatorPart(
      lineId: _toInt(json['line_id']),
      productId: _toInt(json['product_id']),
      quantity: _toDouble(json['quantity']?.toString()),
      clientApproval: _toInt(json['client_approval']),
      productStatus: json['product_status']?.toString() ?? 'black',
      partName: json['part_name']?.toString() ?? '-',
      partSku: json['part_sku']?.toString() ?? '-',
      endUserPrice: _toDouble(json['end_user_price']?.toString()),
    );
  }
}

class _EstimatorSparePartsApprovalWidget extends StatefulWidget {
  const _EstimatorSparePartsApprovalWidget({
    required this.items,
    required this.onApproveTotal,
  });

  final List<_EstimatorPart> items;
  final Future<Map<String, dynamic>?> Function(List<int> productIds) onApproveTotal;

  @override
  State<_EstimatorSparePartsApprovalWidget> createState() => _EstimatorSparePartsApprovalWidgetState();
}

class _EstimatorSparePartsApprovalWidgetState extends State<_EstimatorSparePartsApprovalWidget> {
  bool _isApproving = false;
  bool _isSubmittingTotal = false;

  double get _total => widget.items.fold(0.0, (p, e) => p + e.lineTotal);
  double get _selectedTotal => widget.items.where((e) => e.clientApproval == 1).fold(0.0, (p, e) => p + e.lineTotal);

  String _formatMoney(double v) {
    final asInt = v.roundToDouble() == v;
    return asInt ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
  }
  String _currency(double v) => '${_formatMoney(v)} ج.م';

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

  String _priorityLabel(String raw) {
    final v = raw.trim().toLowerCase();
    if (v == 'urgent' || v == 'red') return 'عاجل';
    if (v == 'advisory' || v == 'orange' || v == 'yellow') return 'استشاري';
    return 'عادي';
  }

  Widget _mobilePartRow(_EstimatorPart e) {
    final isApproved = e.clientApproval == 1;
    final statusColor = _priorityColor(e.productStatus);
    final statusLabel = _priorityLabel(e.productStatus);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                final srcIndex = widget.items.indexWhere((x) => x.lineId == e.lineId);
                final current = srcIndex == -1 ? e : widget.items[srcIndex];
                final updated = _EstimatorPart(
                  lineId: current.lineId,
                  productId: current.productId,
                  quantity: current.quantity,
                  clientApproval: isApproved ? 0 : 1,
                  productStatus: current.productStatus,
                  partName: current.partName,
                  partSku: current.partSku,
                  endUserPrice: current.endUserPrice,
                );
                if (srcIndex == -1) return;
                widget.items[srcIndex] = updated;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF111827), width: 1.8),
                borderRadius: BorderRadius.circular(6),
                color: isApproved ? const Color(0xFF111827) : Colors.transparent,
              ),
              child: isApproved ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.partName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  e.partSku,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.grey7),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20))),
                    const SizedBox(width: 6),
                    Text(statusLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                    const Spacer(),
                    Text('العدد: ${_formatMoney(e.quantity)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('الإجمالي', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.grey7)),
              const SizedBox(height: 4),
              Text(
                _currency(e.lineTotal),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show all items always; approval only toggles selection, not visibility
    final filtered = widget.items;

    final canApproveAll = !_isApproving && widget.items.any((e) => e.clientApproval != 1);
    final canDeselectAll = !_isApproving && widget.items.any((e) => e.clientApproval == 1);
    final selectedProductIds = widget.items.where((e) => e.clientApproval == 1).map((e) => e.productId).toSet().toList();
    final canSubmitTotal = !_isSubmittingTotal && selectedProductIds.isNotEmpty;

    return AppCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      borderColor: const Color(0xFFEFF1F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الموافقة على قطع الغيار',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            children: [
              SizedBox(
                height: 36,
                child: FilledButton(
                  onPressed: canApproveAll
                      ? () async {
                          setState(() => _isApproving = true);
                          await Future<void>.delayed(const Duration(milliseconds: 150));
                          for (var i = 0; i < widget.items.length; i++) {
                            final it = widget.items[i];
                            if (it.clientApproval != 1) {
                              widget.items[i] = _EstimatorPart(
                                lineId: it.lineId,
                                productId: it.productId,
                                quantity: it.quantity,
                                clientApproval: 1,
                                productStatus: it.productStatus,
                                partName: it.partName,
                                partSku: it.partSku,
                                endUserPrice: it.endUserPrice,
                              );
                            }
                          }
                          setState(() => _isApproving = false);
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 16, color: Colors.white),
                      SizedBox(width: 6),
                      Text('تحديد الكل', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 36,
                child: OutlinedButton(
                  onPressed: canDeselectAll
                      ? () {
                          setState(() {
                            for (var i = 0; i < widget.items.length; i++) {
                              final it = widget.items[i];
                              if (it.clientApproval == 1) {
                                widget.items[i] = _EstimatorPart(
                                  lineId: it.lineId,
                                  productId: it.productId,
                                  quantity: it.quantity,
                                  clientApproval: 0,
                                  productStatus: it.productStatus,
                                  partName: it.partName,
                                  partSku: it.partSku,
                                  endUserPrice: it.endUserPrice,
                                );
                              }
                            }
                          });
                        }
                      : null,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF111827)),
                    foregroundColor: const Color(0xFF111827),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('إلغاء الكل', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: const [
              _LegendDot(color: Color(0xFFEF4444), label: 'عاجل'),
              _LegendDot(color: Color(0xFFF59E0B), label: 'استشاري'),
              _LegendDot(color: Color(0xFF111827), label: 'عادي'),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final e = filtered[index];
              return _mobilePartRow(e);
            },
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('المجموع الكلي: ${_currency(_total)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black87)),
                    const SizedBox(height: 6),
                    Text('الموافق عليه في المجموع: ${_currency(_selectedTotal)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.grey7)),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: canSubmitTotal
                      ? () async {
                          setState(() => _isSubmittingTotal = true);
                          try {
                            final res = await widget.onApproveTotal(selectedProductIds);
                            final message = res?['message']?.toString().trim();
                            final ok = message != null && message.isNotEmpty;

                            if (!context.mounted) return;
                            await showDialog<void>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(ok ? 'تمت العملية بنجاح' : 'حدث خطأ'),
                                  content: Text(ok ? (message ?? 'تمت الإضافة بنجاح') : (message ?? 'فشل تنفيذ الطلب')),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('حسناً'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            await showDialog<void>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('حدث خطأ'),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('حسناً'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } finally {
                            if (mounted) setState(() => _isSubmittingTotal = false);
                          }
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: _isSubmittingTotal
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('الموافقة على المجموع', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10))),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black87),
        ),
      ],
    );
  }
}

class _JobEstimatorDetailsScreenState extends State<JobEstimatorDetailsScreen> {
  final _remote = JobEstimatorsRemoteDataSource();
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  Widget _labeledField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.grey7,
          ),
        ),
        const SizedBox(height: 6),
        _fieldBox(value),
      ],
    );
  }

  Color? _tryParseHexColor(String? hex) {
    final h = hex?.trim();
    if (h == null || h.isEmpty) return null;
    var v = h;
    if (v.startsWith('#')) v = v.substring(1);
    if (v.length == 6) v = 'FF$v';
    if (v.length != 8) return null;
    final value = int.tryParse(v, radix: 16);
    if (value == null) return null;
    return Color(value);
  }

  Widget _fieldBox(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Text(
        value.trim().isEmpty ? '-' : value,
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
      height: 48,
      color: Colors.black,
      alignment: Alignment.center,
      child: const Text(
        'customerPortal',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _plateWidget(String plate) {
    final cleaned = plate.trim();
    final letters = StringBuffer();
    final numbers = StringBuffer();

    for (final codePoint in cleaned.runes) {
      final ch = String.fromCharCode(codePoint);
      final isDigit = RegExp(r'[0-9\u0660-\u0669]').hasMatch(ch);
      if (isDigit) {
        numbers.write(ch);
        continue;
      }
      final isLetter = RegExp(r'[A-Za-z\u0600-\u06FF]').hasMatch(ch);
      if (isLetter) {
        letters.write(ch);
      }
    }

    return Container(
      width: 160,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.brandPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'EGYPT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'مصر',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    child: Text(
                      numbers.toString().trim().isEmpty ? '-' : numbers.toString().trim(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    child: Text(
                      letters.toString().trim().isEmpty ? '-' : letters.toString().trim(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _load(int id, String phoneLast4) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _remote.getJobEstimatorDetails(id: id, phoneLast4: phoneLast4);
      setState(() {
        _data = res;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    final a = args is JobEstimatorDetailsArgs ? args : null;
    if (a != null) {
      _load(a.id, a.phoneLast4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final JobEstimatorDetailsArgs? detailsArgs =
        args is JobEstimatorDetailsArgs ? args : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F5),
      body: Column(
        children: [
          _topBar(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF7FAFF), Color(0xFFF4F7FB)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Builder(builder: (context) {
                if (detailsArgs == null) {
                  return const Center(
                    child: Text(
                      'بيانات غير صالحة',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey7,
                      ),
                    ),
                  );
                }
                if (_loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_error != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey7,
                        ),
                      ),
                    ),
                  );
                }
                final map = _data ?? const <String, dynamic>{};
                final estimator = (map['estimator'] as Map?)?.cast<String, dynamic>() ?? {};
                final meta = (map['meta'] as Map?)?.cast<String, dynamic>() ?? {};
                final customerName = estimator['customer_name']?.toString() ?? '-';
                final estimateNo = estimator['estimate_no']?.toString() ?? '-';
                final createdAt = estimator['created_at']?.toString() ?? '-';
                final color = estimator['color']?.toString() ?? '-';
                final brand = estimator['brand']?.toString() ?? '-';
                final model = estimator['model']?.toString() ?? '-';
                final year = estimator['manufacturing_year']?.toString() ?? '-';
                final chassis = estimator['chassis_number']?.toString() ?? '-';
                final plate = estimator['plate_number']?.toString() ?? (meta['plate_number']?.toString() ?? '');
                final service = estimator['service_name']?.toString() ?? '-';
                final branch = estimator['location_name']?.toString() ?? '-';
                final linesList = (map['lines'] as List?) ?? const <dynamic>[];
                final parts = linesList
                    .whereType<Map>()
                    .map((e) => _EstimatorPart.fromJson(e.cast<String, dynamic>()))
                    .toList();

                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 6),
                            const LogoImageWidget(),
                            const SizedBox(height: 10),
                            AppCard(
                              padding: const EdgeInsets.all(16),
                              borderRadius: 16,
                              borderColor: const Color(0xFFEFF1F5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sectionTitle('بيانات العميل'),
                                  const SizedBox(height: 8),
                                  _labeledField(label: 'اسم العميل', value: customerName),
                                  const SizedBox(height: 12),
                                  _labeledField(label: 'رقم التقدير', value: estimateNo),
                                  const SizedBox(height: 12),
                                  _labeledField(label: 'تاريخ الإنشاء', value: createdAt),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            AppCard(
                              padding: const EdgeInsets.all(16),
                              borderRadius: 16,
                              borderColor: const Color(0xFFEFF1F5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sectionTitle('معلومات السيارة'),
                                  const SizedBox(height: 8),
                                  _labeledField(label: 'السيارة', value: '$brand (${model}) $year'),
                                  const SizedBox(height: 12),
                                  _labeledField(label: 'الفرع', value: branch),
                                  const SizedBox(height: 12),
                                  _labeledField(label: 'الخدمة', value: service),
                                  const SizedBox(height: 12),
                                  _labeledField(label: 'اللون', value: color),
                                  const SizedBox(height: 12),
                                  _labeledField(label: 'رقم الشاسيه', value: chassis),
                                  const SizedBox(height: 14),
                                  Center(child: _plateWidget(plate)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            _EstimatorSparePartsApprovalWidget(
                              items: parts,
                              onApproveTotal: (productIds) {
                                return _remote.saveEstimatorProducts(estimatorId: detailsArgs.id, productIds: productIds);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

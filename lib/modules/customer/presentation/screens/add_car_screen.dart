import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/components/app_textfield.dart';
import 'package:reservation_workshop/core/components/dialogs/prograss_delay_dialog.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'package:reservation_workshop/modules/customer/data/datasources/car_remote_datasource.dart';
import 'package:reservation_workshop/modules/customer/data/models/brand_model.dart';
import 'package:reservation_workshop/modules/customer/data/models/car_model_model.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final CarRemoteDataSource _ds = CarRemoteDataSource();

  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _chassisController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  List<BrandModel> _brands = const <BrandModel>[];
  List<CarModelModel> _models = const <CarModelModel>[];

  BrandModel? _selectedBrand;
  CarModelModel? _selectedModel;

  final List<String> _carTypes = const <String>['ملاكي', 'اجره', 'نقل', 'نقل ثقيل'];
  String? _selectedCarType;

  bool _loadingBrands = false;
  bool _loadingModels = false;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  @override
  void dispose() {
    _colorController.dispose();
    _chassisController.dispose();
    _plateController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _loadBrands() async {
    setState(() => _loadingBrands = true);
    try {
      final list = await _ds.getBrands();
      if (!mounted) return;
      setState(() {
        _brands = list;
      });
    } catch (e) {
      Toasters.show(e.toString());
    } finally {
      if (mounted) {
        setState(() => _loadingBrands = false);
      }
    }
  }

  Future<void> _loadModels(int brandId) async {
    setState(() {
      _loadingModels = true;
      _models = const <CarModelModel>[];
      _selectedModel = null;
    });

    try {
      final list = await _ds.getModels(brandId: brandId);
      if (!mounted) return;
      setState(() {
        _models = list;
      });
    } catch (e) {
      Toasters.show(e.toString());
    } finally {
      if (mounted) {
        setState(() => _loadingModels = false);
      }
    }
  }

  String? _requiredValidator(String? v) {
    if (v == null) return 'مطلوب';
    if (v.trim().isEmpty) return 'مطلوب';
    return null;
  }

  Future<void> _submit() async {
    final brand = _selectedBrand;
    final model = _selectedModel;
    final carType = _selectedCarType;

    if (brand == null) {
      Toasters.show('اختر الماركة');
      return;
    }
    if (model == null) {
      Toasters.show('اختر الموديل');
      return;
    }
    if (carType == null || carType.trim().isEmpty) {
      Toasters.show('اختر نوع العربية');
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    showPrograssDelayDialog(context);
    try {
      final msg = await _ds.addCar(
        brandId: brand.id,
        modelId: model.id,
        color: _colorController.text.trim(),
        chassisNumber: _chassisController.text.trim(),
        plateNumber: _plateController.text.trim(),
        manufacturingYear: _yearController.text.trim(),
        carType: carType.trim(),
      );

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).maybePop();
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: const Text('تم'),
            content: Text(msg.isNotEmpty ? msg : 'تم إضافة السيارة بنجاح'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('موافق'),
              ),
            ],
          );
        },
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).maybePop();
      Toasters.show(e.toString());
    }
  }

  InputDecoration _dropdownDecoration({required String hint}) {
    return const InputDecoration(border: OutlineInputBorder()).copyWith(hintText: hint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE9F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'إضافة سيارة',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 26,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'معلومات السيارة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppTextFormField(
                          hintText: 'سنة الصنع',
                          controller: _yearController,
                          validator: _requiredValidator,
                          textDirection: ui.TextDirection.ltr,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<BrandModel>(
                          decoration: _dropdownDecoration(hint: 'الماركة'),
                          value: _selectedBrand,
                          items: _brands
                              .map(
                                (b) => DropdownMenuItem<BrandModel>(
                                  value: b,
                                  child: Text(b.name),
                                ),
                              )
                              .toList(),
                          onChanged: _loadingBrands
                              ? null
                              : (v) {
                                  setState(() {
                                    _selectedBrand = v;
                                  });
                                  if (v != null) {
                                    _loadModels(v.id);
                                  }
                                },
                        ),
                        if (_loadingBrands)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: LinearProgressIndicator(minHeight: 2),
                          ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<CarModelModel>(
                          decoration: _dropdownDecoration(hint: 'الموديل'),
                          value: _selectedModel,
                          items: _models
                              .map(
                                (m) => DropdownMenuItem<CarModelModel>(
                                  value: m,
                                  child: Text(m.name),
                                ),
                              )
                              .toList(),
                          onChanged: (_loadingModels || _selectedBrand == null) ? null : (v) => setState(() => _selectedModel = v),
                        ),
                        if (_loadingModels)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: LinearProgressIndicator(minHeight: 2),
                          ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          decoration: _dropdownDecoration(hint: 'نوع السيارة'),
                          value: _selectedCarType,
                          items: _carTypes
                              .map(
                                (t) => DropdownMenuItem<String>(
                                  value: t,
                                  child: Text(t),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _selectedCarType = v),
                        ),
                        const SizedBox(height: 12),
                        AppTextFormField(
                          hintText: 'اللون',
                          controller: _colorController,
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 12),
                        AppTextFormField(
                          hintText: 'رقم الشاسيه',
                          controller: _chassisController,
                          validator: _requiredValidator,
                          textDirection: ui.TextDirection.ltr,
                        ),
                        const SizedBox(height: 12),
                        AppTextFormField(
                          hintText: 'رقم اللوحة',
                          controller: _plateController,
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brandPrimary,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _submit,
                            child: const Text(
                              'إضافة سيارة',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

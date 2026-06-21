import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import '../../data/datasources/vehicle_filters_remote_datasource.dart';

class VehicleFiltersDialog extends StatefulWidget {
  final int? selectedBrandId;
  final int? selectedModelId;
  final int? selectedCityId;
  final int? selectedColorId;
  final int? selectedBodyTypeId;
  final int? selectedYearRangeId;
  final int? selectedPriceRangeId;

  const VehicleFiltersDialog({
    super.key,
    this.selectedBrandId,
    this.selectedModelId,
    this.selectedCityId,
    this.selectedColorId,
    this.selectedBodyTypeId,
    this.selectedYearRangeId,
    this.selectedPriceRangeId,
  });

  @override
  State<VehicleFiltersDialog> createState() => _VehicleFiltersDialogState();
}

class _VehicleFiltersDialogState extends State<VehicleFiltersDialog> {
  final VehicleFiltersRemoteDataSourceImpl _dataSource = VehicleFiltersRemoteDataSourceImpl();
  
  List<FilterItem> _brands = [];
  List<FilterItem> _models = [];
  List<FilterItem> _cities = [];
  List<FilterItem> _colors = [];
  List<FilterItem> _bodyTypes = [];
  List<FilterItem> _yearRanges = [];
  List<FilterItem> _priceRanges = [];
  
  FilterItem? _selectedBrand;
  FilterItem? _selectedModel;
  FilterItem? _selectedCity;
  FilterItem? _selectedColor;
  FilterItem? _selectedBodyType;
  FilterItem? _selectedYearRange;
  FilterItem? _selectedPriceRange;
  
  bool _isLoadingBrands = false;
  bool _isLoadingModels = false;
  bool _isLoadingCities = false;
  bool _isLoadingColors = false;
  bool _isLoadingBodyTypes = false;
  bool _isLoadingYearRanges = false;
  bool _isLoadingPriceRanges = false;

  @override
  void initState() {
    super.initState();
    _loadAllFilters();
  }

  Future<void> _loadAllFilters() async {
    await Future.wait([
      _loadBrands(),
      _loadCities(),
      _loadColors(),
      _loadBodyTypes(),
      _loadYearRanges(),
      _loadPriceRanges(),
    ]);
    
    // Set initial selections after loading
    if (widget.selectedBrandId != null) {
      _selectedBrand = _brands.firstWhere(
        (brand) => brand.id == widget.selectedBrandId,
        orElse: () => FilterItem(id: 0, name: 'None', brandCategoryId: null),
      );
      if (_selectedBrand != null && _selectedBrand!.id != 0) {
        await _loadModels(_selectedBrand!.id);
        if (widget.selectedModelId != null) {
          _selectedModel = _models.firstWhere(
            (model) => model.id == widget.selectedModelId,
            orElse: () => FilterItem(id: 0, name: 'None', brandCategoryId: null),
          );
        }
      }
    }
    
    if (widget.selectedCityId != null) {
      _selectedCity = _cities.firstWhere(
        (city) => city.id == widget.selectedCityId,
        orElse: () => FilterItem(id: 0, name: 'None', brandCategoryId: null),
      );
    }
    
    if (widget.selectedColorId != null) {
      _selectedColor = _colors.firstWhere(
        (color) => color.id == widget.selectedColorId,
        orElse: () => FilterItem(id: 0, name: 'None', brandCategoryId: null),
      );
    }
    
    if (widget.selectedBodyTypeId != null) {
      _selectedBodyType = _bodyTypes.firstWhere(
        (bodyType) => bodyType.id == widget.selectedBodyTypeId,
        orElse: () => FilterItem(id: 0, name: 'None', brandCategoryId: null),
      );
    }
    
    if (widget.selectedYearRangeId != null) {
      _selectedYearRange = _yearRanges.firstWhere(
        (yearRange) => yearRange.id == widget.selectedYearRangeId,
        orElse: () => FilterItem(id: 0, name: 'None', brandCategoryId: null),
      );
    }
    
    if (widget.selectedPriceRangeId != null) {
      _selectedPriceRange = _priceRanges.firstWhere(
        (priceRange) => priceRange.id == widget.selectedPriceRangeId,
        orElse: () => FilterItem(id: 0, name: 'None', brandCategoryId: null),
      );
    }
  }

  Future<void> _loadBrands() async {
    setState(() {
      _isLoadingBrands = true;
    });

    try {
      final brands = await _dataSource.getBrands(perPage: 15, page: 1);
      setState(() {
        _brands = brands;
        _isLoadingBrands = false;
        
        // Set selected brand if provided
        if (widget.selectedBrandId != null) {
          _selectedBrand = _brands.firstWhere(
            (brand) => brand.id == widget.selectedBrandId,
            orElse: () => _brands.isNotEmpty 
                ? FilterItem(id: 0, name: 'None', brandCategoryId: null)
                : FilterItem(id: 0, name: 'None', brandCategoryId: null),
          );
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingBrands = false;
      });
    }
  }

  Future<void> _loadModels(int brandId) async {
    setState(() {
      _isLoadingModels = true;
      _models = [];
      _selectedModel = null;
    });

    try {
      final models = await _dataSource.getModels(
        brandCategoryId: brandId,
        perPage: 5,
        page: 1,
      );
      setState(() {
        _models = models;
        _isLoadingModels = false;
        
        // Set selected model if provided
        if (widget.selectedModelId != null) {
          _selectedModel = _models.firstWhere(
            (model) => model.id == widget.selectedModelId,
            orElse: () => _models.isNotEmpty 
                ? _models.first 
                : FilterItem(id: 0, name: 'None', brandCategoryId: null),
          );
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingModels = false;
      });
    }
  }

  Future<void> _loadCities() async {
    setState(() => _isLoadingCities = true);
    try {
      final cities = await _dataSource.getCities();
      setState(() {
        _cities = cities;
        _isLoadingCities = false;
      });
    } catch (e) {
      setState(() => _isLoadingCities = false);
    }
  }

  Future<void> _loadColors() async {
    setState(() => _isLoadingColors = true);
    try {
      final colors = await _dataSource.getColors();
      setState(() {
        _colors = colors;
        _isLoadingColors = false;
      });
    } catch (e) {
      setState(() => _isLoadingColors = false);
    }
  }

  Future<void> _loadBodyTypes() async {
    setState(() => _isLoadingBodyTypes = true);
    try {
      final bodyTypes = await _dataSource.getBodyTypes();
      setState(() {
        _bodyTypes = bodyTypes;
        _isLoadingBodyTypes = false;
      });
    } catch (e) {
      setState(() => _isLoadingBodyTypes = false);
    }
  }

  Future<void> _loadYearRanges() async {
    setState(() => _isLoadingYearRanges = true);
    try {
      final yearRanges = await _dataSource.getYearRanges();
      setState(() {
        _yearRanges = yearRanges;
        _isLoadingYearRanges = false;
      });
    } catch (e) {
      setState(() => _isLoadingYearRanges = false);
    }
  }

  Future<void> _loadPriceRanges() async {
    setState(() => _isLoadingPriceRanges = true);
    try {
      final priceRanges = await _dataSource.getPriceRanges();
      setState(() {
        _priceRanges = priceRanges;
        _isLoadingPriceRanges = false;
      });
    } catch (e) {
      setState(() => _isLoadingPriceRanges = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.tune_outlined,
                      color: AppColors.brandPrimary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'buy_car.filters'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.locale.languageCode == 'ar' 
                        ? 'اختر الفلاتر المطلوبة'
                        : 'Select your desired filters',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF666666),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Brand & Model Row
                    Row(
                      children: [
                        Expanded(child: _buildDropdown(
                          label: 'buy_car.brand'.tr(),
                          value: _selectedBrand,
                          items: _brands,
                          isLoading: _isLoadingBrands,
                          onChanged: (FilterItem? brand) {
                            setState(() {
                              _selectedBrand = brand;
                              _selectedModel = null;
                            });
                            if (brand != null && brand.id != 0) {
                              _loadModels(brand.id);
                            }
                          },
                        )),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDropdown(
                          label: 'buy_car.model'.tr(),
                          value: _selectedModel,
                          items: _models,
                          isLoading: _isLoadingModels,
                          onChanged: _selectedBrand != null && _selectedBrand!.id != 0 ? (FilterItem? model) {
                            setState(() {
                              _selectedModel = model;
                            });
                          } : (FilterItem? _) {},
                          enabled: _selectedBrand != null && _selectedBrand!.id != 0 && !_isLoadingModels,
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // City Field
                    _buildTextField(
                      label: context.locale.languageCode == 'ar' ? 'المدينة' : 'City',
                      controller: TextEditingController()..text = _selectedCity?.name ?? '',
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            _selectedCity = null;
                          } else {
                            _selectedCity = FilterItem(id: 0, name: value, brandCategoryId: null);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Color Field
                    _buildTextField(
                      label: context.locale.languageCode == 'ar' ? 'اللون' : 'Color',
                      controller: TextEditingController(text: _selectedColor?.name ?? ''),
                      onChanged: (value) {
                        // Handle color text input
                        if (value.isEmpty) {
                          _selectedColor = null;
                        } else {
                          _selectedColor = FilterItem(id: 0, name: value, brandCategoryId: null);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Body Type & Year Range Row
                    Row(
                      children: [
                        Expanded(child: _buildTextField(
                          label: context.locale.languageCode == 'ar' ? 'نوع الهيكل' : 'Body Type',
                          controller: TextEditingController(text: _selectedBodyType?.name ?? ''),
                          onChanged: (value) {
                            // Handle body type text input
                            if (value.isEmpty) {
                              _selectedBodyType = null;
                            } else {
                              _selectedBodyType = FilterItem(id: 0, name: value, brandCategoryId: null);
                            }
                          },
                        )),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField(
                          label: context.locale.languageCode == 'ar' ? 'سنة الصنع' : 'Year',
                          controller: TextEditingController(text: _selectedYearRange?.name ?? ''),
                          onChanged: (value) {
                            // Handle year range text input
                            if (value.isEmpty) {
                              _selectedYearRange = null;
                            } else {
                              _selectedYearRange = FilterItem(id: 0, name: value, brandCategoryId: null);
                            }
                          },
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Price Range Field
                    _buildTextField(
                      label: context.locale.languageCode == 'ar' ? 'نطاق السعر' : 'Price Range',
                      controller: TextEditingController(text: _selectedPriceRange?.name ?? ''),
                      onChanged: (value) {
                        // Handle price range text input
                        if (value.isEmpty) {
                          _selectedPriceRange = null;
                        } else {
                          _selectedPriceRange = FilterItem(id: 0, name: value, brandCategoryId: null);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            
            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'buy_car.cancel'.tr(),
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop({
                          'brandId': _selectedBrand?.id,
                          'modelId': _selectedModel?.id,
                          'cityName': _selectedCity?.name,
                          'colorName': _selectedColor?.name,
                          'bodyTypeName': _selectedBodyType?.name,
                          'yearRangeName': _selectedYearRange?.name,
                          'priceRangeName': _selectedPriceRange?.name,
                          'brandName': _selectedBrand?.name,
                          'modelName': _selectedModel?.name,
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.brandPrimary),
                        ),
                      ),
                      child: Text(
                        'buy_car.clear_filters'.tr(),
                        style: TextStyle(
                          color: AppColors.brandPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _selectedBrand != null ? () {
                        Navigator.of(context).pop({
                          'brandId': _selectedBrand?.id,
                          'modelId': _selectedModel?.id,
                          'brandName': _selectedBrand?.name,
                          'modelName': _selectedModel?.name,
                        });
                      } : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.brandPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'buy_car.apply_filters'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF1A1A1A),
          ),
          decoration: InputDecoration(
            hintText: context.locale.languageCode == 'ar' ? 'اكتب $label' : 'Enter $label',
            hintStyle: const TextStyle(
              color: Color(0xFF999999),
              fontSize: 15,
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.brandPrimary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required FilterItem? value,
    required List<FilterItem> items,
    required bool isLoading,
    required Function(FilterItem?) onChanged,
    bool enabled = true,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: enabled ? Colors.white : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: enabled ? AppColors.brandPrimary.withValues(alpha: 0.3) : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: enabled ? [
              BoxShadow(
                color: AppColors.brandPrimary.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<FilterItem>(
                value: value,
                isExpanded: true,
                hint: Text(
                  label == 'buy_car.brand'.tr() 
                      ? 'buy_car.select_brand'.tr()
                      : label == 'buy_car.model'.tr()
                          ? 'buy_car.select_model'.tr()
                          : 'Select $label',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                items: items.map((item) {
                  return DropdownMenuItem<FilterItem>(
                    value: item,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: enabled ? onChanged : (FilterItem? _) {},
                icon: isLoading
                    ? Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(2),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandPrimary),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.brandPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.brandPrimary,
                          size: 20,
                        ),
                      ),
                selectedItemBuilder: (context) {
                  return items.map((item) {
                    return DropdownMenuItem<FilterItem>(
                      value: item,
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.brandPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }).toList();
                },
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(16),
                elevation: 8,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1A1A1A),
                ),
                onTap: enabled ? () {} : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../models/vehicle_model.dart';

class VehiclesPageResult {
  final List<VehicleModel> vehicles;
  final int currentPage;
  final int lastPage;
  final int total;

  const VehiclesPageResult({
    required this.vehicles,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}

class VehiclesRemoteDataSource {
  final http.Client _client;

  VehiclesRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<String> createSellerVehicle({required Map<String, dynamic> body}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.carMarketSellerVehicles}');

    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final res = await _client.post(uri, headers: headers, body: jsonEncode(body));
    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      String msg = 'Request failed';
      if (decoded is Map) {
        if (decoded['msg'] != null) {
          msg = decoded['msg'].toString();
        } else if (decoded['message'] != null) {
          msg = decoded['message'].toString();
        } else if (decoded['error'] != null) {
          msg = decoded['error'].toString();
        }
      }
      print('=== HTTP ${res.statusCode} ===');
      print('Response body: ${res.body}');
      print('========================');
      throw Exception(msg);
    }

    if (decoded is Map) {
      final success = decoded['success'] == true;
      final msg = decoded['msg']?.toString() ?? '';
      if (!success) {
        throw Exception(msg.isNotEmpty ? msg : 'Request failed');
      }
      return msg;
    }

    return '';
  }

  Future<VehiclesPageResult> getVehicles({
    int page = 1, 
    int? brandId, 
    int? modelId,
    int? cityId,
    int? colorId,
    int? bodyTypeId,
    int? yearRangeId,
    int? priceRangeId,
    String? cityName,
    String? colorName,
    String? bodyTypeName,
    String? yearRangeName,
    String? priceRangeName,
  }) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final queryParams = <String, String>{
      'page': page.toString(),
    };
    
    if (brandId != null) {
      queryParams['brand_category_id'] = brandId.toString();
    }
    
    if (modelId != null) {
      queryParams['model_id'] = modelId.toString();
    }
    
    if (cityName != null && cityName.isNotEmpty) {
      queryParams['location_city'] = cityName;
    }
    
    if (colorName != null && colorName.isNotEmpty) {
      queryParams['color'] = colorName;
    }
    
    if (bodyTypeName != null && bodyTypeName.isNotEmpty) {
      queryParams['body_type'] = bodyTypeName;
    }
    
    if (yearRangeName != null && yearRangeName.isNotEmpty) {
      queryParams['year'] = yearRangeName;
    }
    
    if (priceRangeName != null && priceRangeName.isNotEmpty) {
      queryParams['listing_price'] = priceRangeName;
    }

    final uri = Uri.parse('$baseUrl${ApiEndpoints.carMarketVehicles}').replace(
      queryParameters: queryParams,
    );

    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final res = await _client.get(uri, headers: headers);
    final decoded = _decodeJson(res.body);

    // Debug: Print the actual URL being called
    print('API URL: $uri');
    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request failed');
    }

    if (decoded is Map && decoded['success'] == true && decoded['data'] is Map) {
      final data = Map<String, dynamic>.from(decoded['data'] as Map);
      final innerList = (data['data'] is List) ? (data['data'] as List) : const <dynamic>[];

      final vehicles = innerList
          .whereType<Map>()
          .map((e) => VehicleModel.fromJson(Map<String, dynamic>.from(e), baseUrl: baseUrl))
          .where((e) => e.id != 0)
          .toList();

      return VehiclesPageResult(
        vehicles: vehicles,
        currentPage: _asInt(data['current_page']),
        lastPage: _asInt(data['last_page']),
        total: _asInt(data['total']),
      );
    }

    return const VehiclesPageResult(
      vehicles: <VehicleModel>[],
      currentPage: 1,
      lastPage: 1,
      total: 0,
    );
  }

  dynamic _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../models/brand_model.dart';
import '../models/car_model_model.dart';

class CarRemoteDataSource {
  final http.Client _client;

  CarRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<List<BrandModel>> getBrands() async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final uri = Uri.parse('$baseUrl${ApiEndpoints.brands}');
    final res = await _client.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request failed');
    }

    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((e) => BrandModel.fromJson(Map<String, dynamic>.from(e)))
          .where((e) => e.id != 0 && e.name.trim().isNotEmpty)
          .toList();
    }

    return const <BrandModel>[];
  }

  Future<List<CarModelModel>> getModels({required int brandId}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final uri = Uri.parse('$baseUrl${ApiEndpoints.models(brandId: brandId)}');
    final res = await _client.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request failed');
    }

    if (decoded is Map && decoded['models'] is List) {
      final List models = decoded['models'] as List;
      return models
          .whereType<Map>()
          .map((e) => CarModelModel.fromJson(Map<String, dynamic>.from(e)))
          .where((e) => e.id != 0 && e.name.trim().isNotEmpty)
          .toList();
    }

    return const <CarModelModel>[];
  }

  Future<String> addCar({
    required int brandId,
    required int modelId,
    required String color,
    required String chassisNumber,
    required String plateNumber,
    required String manufacturingYear,
    required String carType,
  }) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final uri = Uri.parse('$baseUrl${ApiEndpoints.addCar}').replace(
      queryParameters: <String, String>{
        'brand_id': brandId.toString(),
        'model_id': modelId.toString(),
        'color': color,
        'chassis_number': chassisNumber,
        'plate_number': plateNumber,
        'manufacturing_year': manufacturingYear,
        'car_type': carType,
      },
    );

    final res = await _client.post(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request failed');
    }

    if (decoded is Map && decoded['data'] is String) {
      return decoded['data'] as String;
    }

    return 'success';
  }

  dynamic _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../models/spare_product_model.dart';

class ProductsRemoteDataSource {
  final http.Client _client;

  ProductsRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<List<SpareProductModel>> getProducts({
    int perPage = 30,
    int page = 1,
    int businessId = 1,
    int locationId = 1,
  }) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.sparePartsEcomProducts}').replace(
      queryParameters: <String, String>{
        'business_id': businessId.toString(),
        'location_id': locationId.toString(),
        'per_page': perPage.toString(),
        'page': page.toString(),
      },
    );

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final res = await _client.get(uri, headers: headers);
    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request failed');
    }

    if (decoded is Map && decoded['data'] is List) {
      return (decoded['data'] as List)
          .whereType<Map>()
          .map((e) => SpareProductModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return const <SpareProductModel>[];
  }

  dynamic _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }
}

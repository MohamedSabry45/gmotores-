import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../models/vehicle_details_model.dart';

class VehicleDetailsRemoteDataSource {
  final http.Client _client;

  VehicleDetailsRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<VehicleDetailsModel> getVehicleDetails({required int id}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.carMarketVehicleDetails(id: id)}');

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

    if (decoded is Map && decoded['success'] == true && decoded['data'] is Map) {
      final data = Map<String, dynamic>.from(decoded['data'] as Map);
      if (data['vehicle'] is Map) {
        return VehicleDetailsModel.fromJson(
          Map<String, dynamic>.from(data['vehicle'] as Map),
          baseUrl: baseUrl,
        );
      }
    }

    throw Exception('Invalid response');
  }

  dynamic _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }
}

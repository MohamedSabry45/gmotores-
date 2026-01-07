import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../models/job_estimator_model.dart';

class JobEstimatorsRemoteDataSource {
  final http.Client _client;

  JobEstimatorsRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<List<JobEstimatorModel>> getJobEstimators({required int customerId}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }
    final uri = Uri.parse(baseUrl + ApiEndpoints.jobEstimators(customerId: customerId));
    final res = await _client.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request failed');
    }

    final decoded = _decodeJson(res.body);
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((e) => JobEstimatorModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return const <JobEstimatorModel>[];
  }

  Future<Map<String, dynamic>?> getJobEstimatorDetails({
    required int id,
    required String phoneLast4,
  }) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final uri = Uri.parse(baseUrl + ApiEndpoints.jobEstimatorDetails(id: id, phoneLast4: phoneLast4));
    final res = await _client.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request failed');
    }

    final decoded = _decodeJson(res.body);
    return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
  }

  Future<Map<String, dynamic>?> saveEstimatorProducts({
    required int estimatorId,
    required List<int> productIds,
  }) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final base = Uri.parse(baseUrl + ApiEndpoints.jobEstimatorSaveProducts);
    final queryParts = <String>[
      'estimator_id=${Uri.encodeQueryComponent(estimatorId.toString())}',
      ...productIds.map((id) => 'product_ids[]=${Uri.encodeQueryComponent(id.toString())}'),
    ];
    final uri = Uri.parse('${base.toString()}?${queryParts.join('&')}');
    final res = await _client.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      final decoded = _decodeJson(res.body);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      throw Exception('Request failed');
    }

    final decoded = _decodeJson(res.body);
    return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
  }

  dynamic _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }
}

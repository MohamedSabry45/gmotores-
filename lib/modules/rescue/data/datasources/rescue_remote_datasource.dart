import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../models/pickup_request_model.dart';
import '../models/pickup_request_response_model.dart';

class RescueRemoteDataSource {
  final http.Client _client;

  RescueRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<PickupRequestResponseModel> customerPickupRequest({required PickupRequestModel request}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final uri = Uri.parse('$baseUrl${ApiEndpoints.customerPickupRequest}');

    final res = await _client.post(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      final msg = _extractMessage(decoded) ?? 'Request failed';
      throw Exception(msg);
    }

    if (decoded is Map<String, dynamic>) {
      return PickupRequestResponseModel.fromJson(decoded);
    }

    return const PickupRequestResponseModel(success: true, message: 'success');
  }

  dynamic _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  String? _extractMessage(dynamic decoded) {
    if (decoded is Map) {
      final msg = decoded['message']?.toString();
      if (msg != null && msg.trim().isNotEmpty) return msg;
    }
    return null;
  }
}

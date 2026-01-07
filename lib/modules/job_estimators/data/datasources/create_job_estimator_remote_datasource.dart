import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../models/create_job_estimator_response_model.dart';

class CreateJobEstimatorRemoteDataSource {
  final http.Client _client;

  CreateJobEstimatorRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<CreateJobEstimatorResponseModel> createJobEstimator({
    required int contactId,
    required int deviceId,
    required int locationId,
    int? serviceTypeId,
    String? vehicleDetails,
    num? amount,
    int? sendNotificationValue,
  }) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final uri = Uri.parse('$baseUrl${ApiEndpoints.createJobEstimator}');

    final payload = <String, dynamic>{
      'contact_id': contactId,
      'device_id': deviceId,
      'location_id': locationId,
    };

    if (serviceTypeId != null) {
      payload['service_type_id'] = serviceTypeId;
    }
    if (vehicleDetails != null && vehicleDetails.trim().isNotEmpty) {
      payload['vehicle_details'] = vehicleDetails.trim();
    }
    if (amount != null) {
      payload['amount'] = amount;
    }
    if (sendNotificationValue != null) {
      payload['send_notification_value'] = sendNotificationValue;
    }

    final res = await _client.post(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      if (decoded is Map && decoded['message'] is String) {
        throw Exception(decoded['message']);
      }
      throw Exception('Request failed');
    }

    if (decoded is Map) {
      return CreateJobEstimatorResponseModel.fromJson(Map<String, dynamic>.from(decoded));
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

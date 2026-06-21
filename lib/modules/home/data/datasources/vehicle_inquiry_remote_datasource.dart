import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

abstract class VehicleInquiryRemoteDataSource {
  Future<void> submitInquiry({
    required int vehicleId,
    required String message,
    required String inquiryType,
    required int offeredPrice,
  });
}

class VehicleInquiryRemoteDataSourceImpl implements VehicleInquiryRemoteDataSource {
  final http.Client _client;

  VehicleInquiryRemoteDataSourceImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<void> submitInquiry({
    required int vehicleId,
    required String message,
    required String inquiryType,
    required int offeredPrice,
  }) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.vehicleInquiry(vehicleId: vehicleId)}');

    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final body = jsonEncode({
      'message': message,
      'inquiry_type': inquiryType,
      'offered_price': offeredPrice,
    });

    final response = await _client.post(uri, headers: headers, body: body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to submit inquiry: ${response.statusCode}');
    }
  }
}

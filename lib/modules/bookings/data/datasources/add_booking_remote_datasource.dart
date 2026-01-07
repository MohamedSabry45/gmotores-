import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

class AddBookingRemoteDataSource {
  final http.Client _client;

  AddBookingRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<String> addBooking({
    required String bookingStart,
    required int locationId,
    required String bookingNote,
    required int serviceId,
    required int deviceId,
  }) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final uri = Uri.parse('$baseUrl${ApiEndpoints.addBooking}').replace(
      queryParameters: <String, String>{
        'booking_start': bookingStart,
        'location_id': locationId.toString(),
        'booking_note': bookingNote,
        'service_id': serviceId.toString(),
        'device_id': deviceId.toString(),
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

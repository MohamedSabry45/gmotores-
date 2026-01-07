import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';
import 'package:reservation_workshop/modules/notifications/data/models/maintenance_notification_model.dart';

class MaintenanceNotificationsRemoteDataSource {
  final http.Client _client;

  MaintenanceNotificationsRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<List<MaintenanceNotificationModel>> getMaintenanceNotifications({
    String status = 'all',
    int perPage = 20,
  }) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final uri = Uri.parse('$baseUrl${ApiEndpoints.maintenanceNotifications}')
        .replace(queryParameters: <String, String>{
      'status': status,
      'per_page': perPage.clamp(1, 100).toString(),
    });

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

    if (decoded is Map && decoded['data'] is List) {
      return (decoded['data'] as List)
          .whereType<Map>()
          .map((e) => MaintenanceNotificationModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return const <MaintenanceNotificationModel>[];
  }

  Future<List<String>> markRead({required List<String> notificationIds}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final uri = Uri.parse('$baseUrl${ApiEndpoints.maintenanceNotificationsMarkRead}');
    final body = jsonEncode(<String, dynamic>{
      'notification_ids': notificationIds,
    });

    final res = await _client.post(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request failed');
    }

    if (decoded is Map && decoded['updated'] is List) {
      return (decoded['updated'] as List).map((e) => e.toString()).toList();
    }

    return const <String>[];
  }

  Future<void> markAllRead() async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final uri = Uri.parse('$baseUrl${ApiEndpoints.maintenanceNotificationsMarkAllRead}');

    final res = await _client.post(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request failed');
    }
  }

  dynamic _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }
}

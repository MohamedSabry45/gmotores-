import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

class AccountRemoteDataSource {
  final http.Client _client;

  AccountRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<void> softDeleteAccount() async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final uri = Uri.parse('$baseUrl${ApiEndpoints.softDeleteAccount}');
    final res = await _client.post(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{}),
    );

    final decoded = _decodeJson(res.body);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(_extractMessage(decoded) ?? 'Request failed');
    }

    final success = decoded['success'] == true || decoded['success']?.toString() == 'true';
    if (!success) {
      throw Exception(_extractMessage(decoded) ?? 'Request failed');
    }
  }

  Map<String, dynamic> _decodeJson(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  String? _extractMessage(Map<String, dynamic> decoded) {
    final msg = decoded['message']?.toString();
    if (msg != null && msg.trim().isNotEmpty) return msg;
    return null;
  }
}

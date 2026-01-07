import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';

import '../models/auth_session_model.dart';
import '../models/check_phone_result_model.dart';

class AuthRemoteDataSource {
  final http.Client _client;

  AuthRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<CheckPhoneResultModel> checkPhone({required String mobile}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final uri = Uri.parse('$baseUrl${ApiEndpoints.checkPhone}').replace(
      queryParameters: <String, String>{
        'mobile': mobile.trim(),
      },
    );

    final res = await _client.get(uri);
    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(_extractMessage(decoded) ?? 'Request failed');
    }

    final success = decoded['success'] == true || decoded['success']?.toString() == 'true';
    if (!success) {
      throw Exception(_extractMessage(decoded) ?? 'Request failed');
    }

    return CheckPhoneResultModel.fromJson(decoded);
  }

  Future<AuthSessionModel> register({
    required String name,
    required String mobile,
    required String password,
    required String code,
  }) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final uri = Uri.parse('$baseUrl${ApiEndpoints.register}').replace(
      queryParameters: <String, String>{
        'name': name,
        'mobile': mobile,
        'password': password,
        'code': code,
      },
    );

    final res = await _client.post(uri);
    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(_extractMessage(decoded) ?? 'Request failed');
    }

    final success = decoded['success'] == true || decoded['success']?.toString() == 'true';
    if (!success) {
      throw Exception(_extractMessage(decoded) ?? 'Request failed');
    }

    return AuthSessionModel.fromJson(decoded);
  }

  Future<AuthSessionModel> login({
    required String mobile,
    required String password,
  }) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final uri = Uri.parse('$baseUrl${ApiEndpoints.login}');

    final res = await _client.post(
      uri,
      headers: const <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'mobile': mobile.trim(),
        'password': password,
      }),
    );

    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(_extractMessage(decoded) ?? 'Request failed');
    }

    final success = decoded['success'] == true || decoded['success']?.toString() == 'true';
    if (!success) {
      throw Exception(_extractMessage(decoded) ?? 'Request failed');
    }

    return AuthSessionModel.fromJson(decoded);
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

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../models/about_us_model.dart';

class AboutUsRemoteDataSource {
  final http.Client _client;

  AboutUsRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<AboutUsModel> getAboutUs() async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.aboutUs}');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final res = await _client.get(uri, headers: headers);

    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      final msg = _extractMessage(decoded);
      throw Exception(msg ?? 'Request failed');
    }

    if (decoded is Map<String, dynamic>) {
      return AboutUsModel.fromJson(decoded);
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

  String? _extractMessage(dynamic decoded) {
    if (decoded is Map) {
      final msg = decoded['message']?.toString();
      if (msg != null && msg.trim().isNotEmpty) return msg;
    }
    return null;
  }
}

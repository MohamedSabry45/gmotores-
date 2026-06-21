import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../models/sell_proforma_response_model.dart';

class SellProformaRemoteDataSource {
  final http.Client _client;

  SellProformaRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<List<SellProformaResponseModel>> createProforma({required Map<String, dynamic> body}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final accessToken = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);
    final configToken = AppConstants.configToken ?? CacheHelper.getData<String>(key: PrefKeys.kConfigTokenCode);
    final token = (configToken != null && configToken.trim().isNotEmpty) ? configToken : accessToken;

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final uri = Uri.parse('$baseUrl${ApiEndpoints.sellProforma}');

    final res = await _client.post(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    final decoded = _decodeJson(res.body);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(_extractMessage(decoded) ?? 'Request failed');
    }

    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((e) => SellProformaResponseModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return const <SellProformaResponseModel>[];
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
      final error = decoded['error']?.toString();
      if (error != null && error.trim().isNotEmpty) return error;
    }
    return null;
  }
}

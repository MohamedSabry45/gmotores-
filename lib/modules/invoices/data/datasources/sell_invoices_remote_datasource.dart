import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../models/sell_invoice_model.dart';

class SellInvoicesRemoteDataSource {
  final http.Client _client;

  SellInvoicesRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<List<SellInvoiceModel>> getSellInvoices({required int contactId}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final accessToken = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);
    final configToken = AppConstants.configToken ?? CacheHelper.getData<String>(key: PrefKeys.kConfigTokenCode);
    final token = (configToken != null && configToken.trim().isNotEmpty) ? configToken : accessToken;
    final tokenSource = (configToken != null && configToken.trim().isNotEmpty) ? 'configToken' : 'accessToken';

    if (token == null || token.trim().isEmpty) {
      throw Exception('Unauthorized');
    }

    final uri = Uri.parse('$baseUrl${ApiEndpoints.sellInvoices(contactId: contactId)}');

    debugPrint('[InvoicesAPI] GET $uri (contactId=$contactId, tokenSource=$tokenSource)');

    final res = await _client.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      final snippet = res.body.length > 1200 ? res.body.substring(0, 1200) : res.body;
      debugPrint('[InvoicesAPI] FAILED status=${res.statusCode} body=$snippet');
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(_extractMessage(decoded) ?? 'Request failed');
    }

    final data = decoded['data'];
    final invoices = <SellInvoiceModel>[];
    if (data is List) {
      for (final item in data) {
        if (item is Map<String, dynamic>) {
          invoices.add(SellInvoiceModel.fromJson(item));
        }
      }
    }

    return invoices;
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
    final error = decoded['error']?.toString();
    if (error != null && error.trim().isNotEmpty) return error;
    return null;
  }
}

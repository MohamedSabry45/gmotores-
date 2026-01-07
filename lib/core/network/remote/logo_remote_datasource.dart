import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

class LogoRemoteDataSource {
  Future<String> uploadLogo({
    required File imageFile,
  }) async {
    final baseUrl = AppConstants.kBaseUrl.trim();

    final uri = Uri.parse('$baseUrl${ApiEndpoints.uploadImage}');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();

    final decoded = _decodeJson(body);

    if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
      throw Exception('Request failed');
    }

    if (decoded is Map && decoded['logo'] != null) {
      final logoPath = decoded['logo'].toString();
      await CacheHelper.saveData(key: PrefKeys.kBusinessLogoPath, value: logoPath);
      return logoPath;
    }

    throw Exception('Request failed');
  }

  dynamic _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }
}

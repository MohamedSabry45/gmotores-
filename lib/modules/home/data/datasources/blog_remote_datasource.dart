import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../models/blog_post_model.dart';

class BlogRemoteDataSource {
  final http.Client _client;

  BlogRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  String? _normalizeImageUrl({required String baseUrl, required String? imageUrl}) {
    final input = imageUrl?.trim();
    if (input == null || input.isEmpty) return null;
    if (input.startsWith('http://') || input.startsWith('https://')) return input;

    final normalizedBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final normalizedPath = input.startsWith('/') ? input.substring(1) : input;
    return '$normalizedBase/$normalizedPath';
  }

  Future<List<BlogPostModel>> getBlogPosts() async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.blog}');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final res = await _client.get(uri, headers: headers);
    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request failed');
    }

    if (decoded is Map && decoded['data'] is List) {
      return (decoded['data'] as List).whereType<Map>().map((e) {
        final map = Map<String, dynamic>.from(e);
        map['image_url'] = _normalizeImageUrl(baseUrl: baseUrl, imageUrl: map['image_url']?.toString());
        return BlogPostModel.fromJson(map);
      }).toList();
    }

    return const <BlogPostModel>[];
  }

  Future<BlogPostModel?> getBlogDetails({required int id}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.blogDetails(id: id)}');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final res = await _client.get(uri, headers: headers);
    final decoded = _decodeJson(res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request failed');
    }

    if (decoded is Map && decoded['data'] is Map) {
      final map = Map<String, dynamic>.from(decoded['data'] as Map);
      map['image_url'] = _normalizeImageUrl(baseUrl: baseUrl, imageUrl: map['image_url']?.toString());
      return BlogPostModel.fromJson(map);
    }

    return null;
  }

  dynamic _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }
}

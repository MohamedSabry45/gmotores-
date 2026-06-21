import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

class FilterItem {
  final int id;
  final String name;
  final int? brandCategoryId;

  FilterItem({
    required this.id,
    required this.name,
    this.brandCategoryId,
  });

  factory FilterItem.fromJson(Map<String, dynamic> json) {
    return FilterItem(
      id: json['id'] as int,
      name: json['name'] as String,
      brandCategoryId: json['brand_category_id'] as int?,
    );
  }
}

abstract class VehicleFiltersRemoteDataSource {
  Future<List<FilterItem>> getBrands({String? search, int perPage = 15, int page = 1});
  Future<List<FilterItem>> getModels({
    required int brandCategoryId,
    String? search,
    int perPage = 15,
    int page = 1,
  });
  Future<List<FilterItem>> getCities({String? search, int perPage = 15, int page = 1});
  Future<List<FilterItem>> getColors({String? search, int perPage = 15, int page = 1});
  Future<List<FilterItem>> getBodyTypes({String? search, int perPage = 15, int page = 1});
  Future<List<FilterItem>> getYearRanges();
  Future<List<FilterItem>> getPriceRanges();
}

class VehicleFiltersRemoteDataSourceImpl implements VehicleFiltersRemoteDataSource {
  final http.Client _client;

  VehicleFiltersRemoteDataSourceImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<List<FilterItem>> getBrands({String? search, int perPage = 15, int page = 1}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.carMarketFilters(
      type: 'brands',
      search: search,
      perPage: perPage,
      page: page,
    )}');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await _client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse['success'] == true) {
        final data = jsonResponse['data'] as List<dynamic>;
        return data.map((item) => FilterItem.fromJson(item as Map<String, dynamic>)).toList();
      }
    }

    throw Exception('Failed to load brands');
  }

  @override
  Future<List<FilterItem>> getModels({
    required int brandCategoryId,
    String? search,
    int perPage = 15,
    int page = 1,
  }) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.carMarketFilters(
      type: 'models',
      brandCategoryId: brandCategoryId,
      search: search,
      perPage: perPage,
      page: page,
    )}');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await _client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse['success'] == true) {
        final data = jsonResponse['data'] as List<dynamic>;
        return data.map((item) => FilterItem.fromJson(item as Map<String, dynamic>)).toList();
      }
    }

    throw Exception('Failed to load models');
  }

  @override
  Future<List<FilterItem>> getCities({String? search, int perPage = 15, int page = 1}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.carMarketFilters(
      type: 'cities',
      search: search,
      perPage: perPage,
      page: page,
    )}');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await _client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse['success'] == true) {
        final data = jsonResponse['data'] as List<dynamic>;
        return data.map((item) => FilterItem.fromJson(item as Map<String, dynamic>)).toList();
      }
    }

    throw Exception('Failed to load cities');
  }

  @override
  Future<List<FilterItem>> getColors({String? search, int perPage = 15, int page = 1}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.carMarketFilters(
      type: 'colors',
      search: search,
      perPage: perPage,
      page: page,
    )}');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await _client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse['success'] == true) {
        final data = jsonResponse['data'] as List<dynamic>;
        return data.map((item) => FilterItem.fromJson(item as Map<String, dynamic>)).toList();
      }
    }

    throw Exception('Failed to load colors');
  }

  @override
  Future<List<FilterItem>> getBodyTypes({String? search, int perPage = 15, int page = 1}) async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.carMarketFilters(
      type: 'body_types',
      search: search,
      perPage: perPage,
      page: page,
    )}');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await _client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse['success'] == true) {
        final data = jsonResponse['data'] as List<dynamic>;
        return data.map((item) => FilterItem.fromJson(item as Map<String, dynamic>)).toList();
      }
    }

    throw Exception('Failed to load body types');
  }

  @override
  Future<List<FilterItem>> getYearRanges() async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.carMarketFilters(
      type: 'year_range',
      perPage: 50,
    )}');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await _client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse['success'] == true) {
        final data = jsonResponse['data'] as List<dynamic>;
        return data.map((item) => FilterItem.fromJson(item as Map<String, dynamic>)).toList();
      }
    }

    throw Exception('Failed to load year ranges');
  }

  @override
  Future<List<FilterItem>> getPriceRanges() async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.carMarketFilters(
      type: 'price_range',
      perPage: 50,
    )}');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await _client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse['success'] == true) {
        final data = jsonResponse['data'] as List<dynamic>;
        return data.map((item) => FilterItem.fromJson(item as Map<String, dynamic>)).toList();
      }
    }

    throw Exception('Failed to load price ranges');
  }
}

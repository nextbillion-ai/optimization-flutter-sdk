part of '../optimization_flutter.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  final Dio _dio;

  factory ApiService() => _instance;

  ApiService._internal() : _dio = Dio();

  Future<Response> get(String url, {Options? options}) async {
    final response = await _dio.get(
      url,
      options: options,
    );
    return response;
  }

  Future<Response> post(String url, Map<String, dynamic> data,
      {Options? options}) async {
    final response = await _dio.post(url, data: data, options: options);
    return response;
  }
}

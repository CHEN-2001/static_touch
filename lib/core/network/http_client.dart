import 'package:dio/dio.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/core/network/api_endpoints.dart';
import 'package:static_touch/core/network/auth_interceptor.dart';
import 'api_exception.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  late final Dio dio;

  HttpClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.add(AuthInterceptor(dio));
  }

  // 统一封装 GET 请求
  Future<ResultEntity> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (e) {
      return ResultEntity.error(ApiException.format(e));
    }
  }

  // 统一封装 POST 请求
  Future<ResultEntity> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.post(path, data: data, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (e) {
      return ResultEntity.error(ApiException.format(e));
    }
  }

  // 统一封装 PUT 请求
  Future<ResultEntity> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.put(path, data: data, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (e) {
      return ResultEntity.error(ApiException.format(e));
    }
  }

  // 统一封装 DELETE 请求
  Future<ResultEntity> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.delete(path, data: data, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (e) {
      return ResultEntity.error(ApiException.format(e));
    }
  }

  ResultEntity _handleResponse(Response response) {
    final resData = response.data;

    if (resData is Map<String, dynamic>) {
      final int? code = resData['code'];
      if (code == 200) {
        return ResultEntity(status: true, message: resData['msg'] ?? '成功', data: resData['data'], code: code);
      }
      return ResultEntity.error(resData['msg'] ?? '请求失败', code: code);
    }
    return ResultEntity.error('无法解析的服务器数据格式');
  }
}

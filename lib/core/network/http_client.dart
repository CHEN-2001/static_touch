import 'package:dio/dio.dart';
import 'package:static_touch/core/utils/token_manager.dart';
import 'package:static_touch/core/result/result_model.dart';
import 'package:static_touch/core/navigation/nav_service.dart';
import 'api_exception.dart';

// 网络请求配置
class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  late Dio dio;

  HttpClient._internal() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.yourdomain.com/v1', connectTimeout: const Duration(seconds: 15)));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenManager.getToken();
          if (token != null) options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onError: (e, handler) {
          if (e.response?.statusCode == 401) {
            TokenManager.clearToken();
            NavService.go('/login');
          }
          return handler.next(e);
        },
      ),
    );
  }
  Future<ResultEntity> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      final resData = response.data;
      if (resData['code'] == 200) {
        return ResultEntity(status: true, message: resData['message'] ?? '成功', data: resData['data']);
      }
      return ResultEntity.error(resData['message'] ?? '请求失败');
    } catch (e) {
      return ResultEntity.error(ApiException.format(e));
    }
  }

  Future<ResultEntity> post(String path, {dynamic data}) async {
    try {
      final response = await dio.post(path, data: data);
      final resData = response.data;
      if (resData['code'] == 200) {
        return ResultEntity(status: true, message: resData['message'] ?? '成功', data: resData['data']);
      }
      return ResultEntity.error(resData['message'] ?? '请求失败');
    } catch (e) {
      return ResultEntity.error(ApiException.format(e));
    }
  }
}

import 'package:dio/dio.dart';

// api错误处理
class ApiException {
  static String format(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return '网络连接超时，请检查网络';
        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 401) return '登录已过期';
          return '服务器异常 (${error.response?.statusCode})';
        default:
          return '网络连接断开';
      }
    }
    return '客户端发生未知错误';
  }
}

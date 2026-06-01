import 'dart:async';
import 'package:dio/dio.dart';
import 'package:static_touch/core/utils/token_manager.dart';
import 'package:static_touch/core/navigation/nav_service.dart';
import 'package:static_touch/core/network/api_endpoints.dart';
import 'package:static_touch/shared/widgets/app_dialogs.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  bool _isRefreshing = false;

  final List<void Function(String)> _requestQueue = [];

  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return super.onError(err, handler);
    }

    final options = err.requestOptions;

    // 如果刷新 token 接口自己报 401，直接登出
    if (options.path.contains(ApiEndpoints.refreshToken)) {
      await _handleLogout();
      return super.onError(err, handler);
    }

    if (!_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await TokenManager.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          throw Exception("没有 RefreshToken，无法刷新");
        }

        final refreshDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

        final response = await refreshDio.post(ApiEndpoints.refreshToken, data: {'refreshToken': refreshToken});

        if (response.statusCode == 200 && response.data['code'] == 200) {
          final newAccess = response.data['data']['accessToken']?.toString();
          final newRefresh = response.data['data']['refreshToken']?.toString();

          if (newAccess != null && newRefresh != null) {
            await TokenManager.setAllToken(newAccess, newRefresh);
            for (var callback in _requestQueue) {
              callback(newAccess);
            }
            _requestQueue.clear();
            options.headers['Authorization'] = 'Bearer $newAccess';
            final retryResponse = await dio.fetch(options);
            return handler.resolve(retryResponse);
          } else {
            throw Exception("新 Token 格式解析失败");
          }
        } else {
          final errorMsg = response.data['msg']?.toString() ?? "登录凭证已失效，请重新登录！";
          throw Exception(errorMsg);
        }
      } catch (e) {
        String promptMsg = "登录凭证已失效，请重新登录！";
        if (e is DioException) {
          if (e.response?.data != null && e.response?.data is Map) {
            promptMsg = e.response?.data['msg']?.toString() ?? promptMsg;
          }
        } else if (e is Exception) {
          promptMsg = e.toString().replaceAll("Exception: ", "");
        }
        await _handleLogout(message: promptMsg);
        return super.onError(err, handler);
      } finally {
        _isRefreshing = false;
        _requestQueue.clear();
      }
    } else {
      final completer = Completer<Response>();
      _requestQueue.add((newToken) {
        if (newToken.isEmpty) {
          completer.completeError(DioException(requestOptions: options, error: 'Token refresh failed'));
          return;
        }
        options.headers['Authorization'] = 'Bearer $newToken';
        dio
            .fetch(options)
            .then((res) {
              completer.complete(res);
            })
            .catchError((e) {
              completer.completeError(e);
            });
      });

      try {
        final response = await completer.future;
        handler.resolve(response);
      } catch (e) {
        handler.reject(e is DioException ? e : DioException(requestOptions: options, error: e));
      }
    }
  }

  Future<void> _handleLogout({String? message}) async {
    await TokenManager.clearToken();
    final context = NavService.rootNavigatorKey.currentContext;
    if (context != null) {
      context.showAppToast(
        message: message ?? "登录状态已失效，请重新登录",
        type: AppToastType.warning,
        position: AppToastPosition.top,
      );
    }

    NavService.go('/login');
  }
}

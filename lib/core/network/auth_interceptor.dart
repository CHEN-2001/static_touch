import 'dart:async';
import 'package:dio/dio.dart';
import 'package:static_touch/core/utils/token_manager.dart';
import 'package:static_touch/core/navigation/nav_service.dart';
import 'package:static_touch/core/network/api_endpoints.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  // 状态锁：是否正在刷新 Token
  bool _isRefreshing = false;

  // 请求队列：存放正在等待新 Token 的请求回调
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
    // 1. 如果不是 401，或者根本没有响应，直接抛出，不拦截
    if (err.response?.statusCode != 401) {
      return super.onError(err, handler);
    }

    final options = err.requestOptions;

    // 2. 防死循环：如果刷新 Token 的接口本身报了 401，说明 RefreshToken 也过期了，直接踢出登录
    if (options.path.contains(ApiEndpoints.refreshToken)) {
      await _handleLogout();
      return super.onError(err, handler);
    }

    // 3. 如果当前【没有】在刷新 Token，则由当前请求触发刷新逻辑
    if (!_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await TokenManager.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          throw Exception("没有 RefreshToken，无法刷新");
        }

        // ⚠️ 关键点：必须使用一个新的 Dio 实例去请求，不能用传进来的 dio，否则会触发拦截器死循环！
        final refreshDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

        final response = await refreshDio.post(ApiEndpoints.refreshToken, data: {'refreshToken': refreshToken});

        if (response.statusCode == 200 && response.data['code'] == 200) {
          // 解析拿到新 Token
          final newAccess = response.data['data']['accessToken']?.toString();
          final newRefresh = response.data['data']['refreshToken']?.toString();

          if (newAccess != null && newRefresh != null) {
            // 保存新 Token
            await TokenManager.setAllToken(newAccess, newRefresh);

            // 将刚才失败的当前请求换上新 Token 并重试
            options.headers['Authorization'] = 'Bearer $newAccess';
            final retryResponse = await dio.fetch(options);
            handler.resolve(retryResponse);

            // 释放队列中被阻塞的其他请求，让它们也带着新 Token 继续飞
            for (var callback in _requestQueue) {
              callback(newAccess);
            }
          } else {
            throw Exception("新 Token 格式解析失败");
          }
        } else {
          throw Exception("刷新 Token 接口返回失败状态");
        }
      } catch (e) {
        // 刷新失败（大概率 RefreshToken 已过期失效），强制登出
        await _handleLogout();
        return super.onError(err, handler);
      } finally {
        // 无论成功失败，最后必须释放锁和清空队列
        _isRefreshing = false;
        _requestQueue.clear();
      }
    }
    // 4. 如果当前【正在】刷新 Token，则将后续因为 401 进来的请求放入队列等待
    else {
      final completer = Completer<Response>();

      // 将回调放入队列
      _requestQueue.add((newToken) {
        options.headers['Authorization'] = 'Bearer $newToken';
        // 拿到新 Token 后，重新发起请求，并将结果交给 completer
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
        // 挂起当前请求，直到 completer 完成
        final response = await completer.future;
        handler.resolve(response);
      } catch (e) {
        handler.reject(e as DioException);
      }
    }
  }

  // 统一登出处理逻辑
  Future<void> _handleLogout() async {
    await TokenManager.clearToken();
    NavService.go('/login');
  }
}

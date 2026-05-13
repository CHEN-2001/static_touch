import 'package:flutter/material.dart';

/// 🚀 直播媒体引擎接口（防腐层）
/// 业务代码只管调这些方法，至于底层用什么 SDK，业务不需要知道。
abstract class StreamEngine {
  // ============ 主播端 (推流) ============
  /// 初始化相机预览
  Future<void> initPreview(Widget container);

  /// 切换前后摄像头
  Future<void> switchCamera();

  /// 开启美颜/滤镜
  void enableBeauty(bool enable);

  /// 开始向指定 URL 推流
  Future<void> startPushStream(String pushUrl);

  /// 停止推流
  Future<void> stopPushStream();

  // ============ 观众端 (拉流) ============
  /// 播放指定 URL 的直播流
  Future<void> startPlayStream(String pullUrl, Widget container);

  /// 停止播放
  Future<void> stopPlayStream();

  void dispose();
}

// 💡 未来你可以在这里实现具体的引擎，例如：
// class TencentStreamEngine implements StreamEngine { ... }
// class AgoraStreamEngine implements StreamEngine { ... }

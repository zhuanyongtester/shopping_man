import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui show PointerDataPacket;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'auto_size_config.dart';

/// runAutoSizeApp.
///
/// width 设计稿尺寸 宽 dp or pt。
/// height 设计稿尺寸 高 dp or pt。
///
void runAutoSizeApp(Widget app, {required double width, required double height}) {
  AutoSizeConfig.setDesignWH(width: width, height: height);

  AutoSizeWidgetsFlutterBinding.ensureInitialized().attachRootWidget(
    MediaQuery(
      data: MediaQueryData(size: Size(width, height)),
      child: app,
    ),
  );
  AutoSizeWidgetsFlutterBinding.ensureInitialized().scheduleWarmUpFrame();
}

/// AutoSize.
class AutoSize {
  /// getSize.
  static Size getSize() {
    final Size size = window.physicalSize;
    if (size == Size.zero) return size;
    final Size autoSize = size.width > size.height
        ? new Size(size.width / getPixelRatio(), AutoSizeConfig.designWidth)
        : new Size(AutoSizeConfig.designWidth, size.height / getPixelRatio());
    return autoSize;
  }

  /// 获取适配后的像素密度。
  /// get the adapted pixel density.
  static double getPixelRatio() {
    final Size size = window.physicalSize;
    return (size.width > size.height ? size.height : size.width) /
        AutoSizeConfig.designWidth;
  }
}

/// A concrete binding for applications based on the Widgets framework.
///
/// This is the glue that binds the framework to the Flutter engine.
/// This is the glue that binds the framework to the Flutter engine.
class AutoSizeWidgetsFlutterBinding extends WidgetsFlutterBinding {
  /// 确保绑定已初始化
  static WidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) AutoSizeWidgetsFlutterBinding();
    return WidgetsBinding.instance!;
  }

  @override
  void initInstances() {
    super.initInstances();
    PlatformDispatcher.instance.onPointerDataPacket = _handlePointerDataPacket;
  }

  @override
  ViewConfiguration createViewConfiguration() {
    final FlutterView view = PlatformDispatcher.instance.views.first;

    // 获取屏幕的逻辑尺寸
    final Size logicalSize = view.physicalSize / view.devicePixelRatio;

    print("Logical size: $logicalSize, DevicePixelRatio: ${view.devicePixelRatio}");

    // 使用逻辑尺寸和设备像素比配置视图
    return ViewConfiguration(
      devicePixelRatio: view.devicePixelRatio,
    );
  }

  /// 处理指针数据包
  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  void _handlePointerDataPacket(ui.PointerDataPacket packet) {
    _pendingPointerEvents.addAll(
      PointerEventConverter.expand(
        packet.data,
        PlatformDispatcher.instance.views.first.devicePixelRatio as DevicePixelRatioGetter,
      ),
    );
    if (!locked) _flushPointerEventQueue();
  }

  void _flushPointerEventQueue() {
    assert(!locked);
    while (_pendingPointerEvents.isNotEmpty) {
      _handlePointerEvent(_pendingPointerEvents.removeFirst());
    }
  }

  final Map<int, HitTestResult> _hitTests = <int, HitTestResult>{};

  void _handlePointerEvent(PointerEvent event) {
    assert(!locked);
    HitTestResult? result;
    if (event is PointerDownEvent) {
      result = HitTestResult();
      hitTest(result, event.position);
      _hitTests[event.pointer] = result;
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      result = _hitTests.remove(event.pointer);
    } else if (event.down) {
      result = _hitTests[event.pointer];
    } else {
      return;
    }
    if (result != null) dispatchEvent(event, result);
  }

  @override
  void unlocked() {
    super.unlocked();
    _flushPointerEventQueue();
  }
}
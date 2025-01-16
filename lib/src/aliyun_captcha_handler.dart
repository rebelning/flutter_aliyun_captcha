import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aliyun_captcha/src/constants.dart';

typedef SuccessCallback = Future<String?>? Function(String data);
typedef FailureCallback = void Function(String? failCode);
typedef ErrorCallback = void Function(String? errorCode);

class AliyunCaptchaHandler {
  static MethodChannel? _channel;

  // 动态注册的回调
  static SuccessCallback? onSuccessHandler;
  static SuccessCallback? onBizCallbackHandler;
  static FailureCallback? onFailureHandler;
  static ErrorCallback? onErrorHandler;

  // 初始化时注册方法调用处理器
  static void init(int viewId) {
    debugPrint('channel name=${kAliyunCaptchaButtonChannelName}_$viewId');
    _channel = MethodChannel('${kAliyunCaptchaButtonChannelName}_$viewId');
    _channel?.setMethodCallHandler((call) async {
      try {
        debugPrint("----------method: ${call.method}");
        debugPrint("----------arguments: ${call.arguments}");
        switch (call.method) {
          case 'onSuccess':
            if (onSuccessHandler != null) {
              return await onSuccessHandler
                  ?.call(call.arguments["data"]); // 将结果返回给原生
            }
            break;
          case 'onBizCallback':
            if (onBizCallbackHandler != null) {
              return await onBizCallbackHandler
                  ?.call(call.arguments["data"]); // 返回给原生
            }
            break;
          case 'onFailure':
            if (onFailureHandler != null) {
              onFailureHandler!(call.arguments["data"]);
            }
            return null;
          case 'onError':
            if (onErrorHandler != null) {
              onErrorHandler!(call.arguments["data"]);
            }
            return null;
          default:
            throw PlatformException(
              code: 'NOT_IMPLEMENTED',
              message: 'Method ${call.method} not implemented',
            );
        }
      } catch (e) {
        print('Error in handleNativeMethodCall: $e');
        return null;
      }
    });
  }

  // 注册动态回调
  static void registerHandlers({
    SuccessCallback? onSuccess,
    SuccessCallback? onBizCallback,
    FailureCallback? onFailure,
    ErrorCallback? onError,
  }) {
    onSuccessHandler = onSuccess;
    onBizCallbackHandler = onBizCallback;
    onFailureHandler = onFailure;
    onErrorHandler = onError;
  }
}

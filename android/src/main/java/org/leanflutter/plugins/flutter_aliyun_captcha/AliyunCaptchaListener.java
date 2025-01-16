package org.leanflutter.plugins.flutter_aliyun_captcha;

import io.flutter.plugin.common.MethodChannel;

public interface AliyunCaptchaListener {
    void onSuccess(String data);

//    void onSuccess( MethodChannel.Result result);
    void onBizCallback(String data);
    void onFailure(String data);

    void onError(String data);
}

package org.leanflutter.plugins.flutter_aliyun_captcha;

import io.flutter.plugin.common.MethodChannel;

public class AliyunCaptchaSender {
    private static AliyunCaptchaSender instance = new AliyunCaptchaSender();

    public static AliyunCaptchaSender getInstance() {
        return instance;
    }

    AliyunCaptchaListener listener;

    void listene(AliyunCaptchaListener listener) {
        this.listener = listener;
    }

    void onSuccess(String data) {
        this.listener.onSuccess(data);
    }

    void onBizCallback(String data) {
        this.listener.onBizCallback(data);
    }
    void onFailure(String data) {
        this.listener.onFailure(data);
    }

    void onError(String data) {
        this.listener.onError(data);
    }
}

package org.leanflutter.plugins.flutter_aliyun_captcha;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import static org.leanflutter.plugins.flutter_aliyun_captcha.Constants.ALIYUN_CAPTCHA_BUTTON_CHANNEL_NAME;
import static org.leanflutter.plugins.flutter_aliyun_captcha.Constants.ALIYUN_CAPTCHA_BUTTON_EVENT_CHANNEL_NAME;

class FlutterAliyunCaptchaButtonJsInterface {
    private Handler handler = new Handler(Looper.getMainLooper());
    private MethodChannel methodChannel;

    // 构造函数，传入 MethodChannel
    public FlutterAliyunCaptchaButtonJsInterface(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
    }
    @JavascriptInterface
    public void onSuccess(final String data) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                AliyunCaptchaSender.getInstance().onSuccess(data);
            }
        };
        handler.post(runnable);
//        handler.post(() -> notifyFlutterAndAwaitResult("onSuccess", data));
    }

    @JavascriptInterface
    public void onBizCallback(final String data) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                AliyunCaptchaSender.getInstance().onBizCallback(data);
            }
        };
        handler.post(runnable);
    }

    @JavascriptInterface
    public void onFailure(final String data) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                AliyunCaptchaSender.getInstance().onFailure(data);
            }
        };
        handler.post(runnable);
    }

    @JavascriptInterface
    public void onError(final String data) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                AliyunCaptchaSender.getInstance().onError(data);
            }
        };
        handler.post(runnable);
    }

}

public class FlutterAliyunCaptchaButton
        implements PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private final MethodChannel methodChannel;
    private final EventChannel eventChannel;

    private EventChannel.EventSink eventSink;

    private String captchaHtmlPath;
    private String captchaType;
    private String captchaOptionJsonString;
    private String captchaCustomStyle;

    private FrameLayout containerView;
    private WebView webView;

    private WebSettings webSettings;
    private WebViewClient webViewClient = new WebViewClient() {
        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);

            final float scale = webView.getContext().getResources().getDisplayMetrics().density;

            int widgetHeight = (int) (containerView.getMeasuredHeight() / scale);

            String jsCode = String.format("window._init('%s', {\"height\":%d}, '%s');",
                    captchaType,
                    widgetHeight,
                    captchaOptionJsonString);
            webView.evaluateJavascript(jsCode, new ValueCallback<String>() {
                @Override
                public void onReceiveValue(String value) {
                }
            });
        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            if (url != null && (url.startsWith("http://") || url.startsWith("https://"))) {
                view.getContext().startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
                return true;
            }
            return false;
        }
    };

    @SuppressLint({"ResourceAsColor", "SetJavaScriptEnabled"})
    FlutterAliyunCaptchaButton(
            final Context context,
            BinaryMessenger messenger,
            int viewId,
            Map<String, Object> params,
            String captchaHtmlPath) {
        Log.d("channel","channel name="+ALIYUN_CAPTCHA_BUTTON_CHANNEL_NAME + "_" + viewId);
        methodChannel = new MethodChannel(messenger, ALIYUN_CAPTCHA_BUTTON_CHANNEL_NAME + "_" + viewId);
        methodChannel.setMethodCallHandler(this);

        eventChannel = new EventChannel(messenger, ALIYUN_CAPTCHA_BUTTON_EVENT_CHANNEL_NAME + "_" + viewId);
        eventChannel.setStreamHandler(this);

        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT,
                Gravity.CENTER_HORIZONTAL | Gravity.CENTER_VERTICAL);
        this.containerView = new FrameLayout(context);
        if (!containerView.isHardwareAccelerated()) {
            this.containerView.setLayerType(View.LAYER_TYPE_SOFTWARE, null);
        }
        this.containerView.setLayoutParams(layoutParams);

        this.webView = new WebView(context);

        this.webView.setBackgroundColor(Color.parseColor("#F2F5FC"));
        this.webView.setWebViewClient(this.webViewClient);
        this.webView.addJavascriptInterface(new FlutterAliyunCaptchaButtonJsInterface(methodChannel), "messageHandlers");

        this.webSettings = this.webView.getSettings();
        this.webSettings.setJavaScriptEnabled(true);
        this.webSettings.setAllowFileAccessFromFileURLs(true);
        this.webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        this.webView.requestFocus();
        this.containerView.addView(webView);

        this.captchaHtmlPath = captchaHtmlPath;

        if (params.containsKey("type"))
            this.captchaType = (String) params.get("type");
        if (params.containsKey("optionJsonString"))
            this.captchaOptionJsonString = (String) params.get("optionJsonString");
//        if (params.containsKey("customStyle"))
//            this.captchaCustomStyle = (String) params.get("customStyle");

        AliyunCaptchaSender.getInstance().listene(new AliyunCaptchaListener() {
            @Override
            public void onSuccess(String data) {
                Log.d("data=","onSuccess="+data);
                final Map<String, Object> result = new HashMap<>();
                result.put("method", "onSuccess");
//                result.put("data", convertMsgToMap(data));
                result.put("data",data);
//                eventSink.success(result);
                notifyFlutterAndAwaitResult("onSuccess",result,true);
            }

            @Override
            public void onBizCallback(String data) {
                final Map<String, Object> result = new HashMap<>();
                result.put("method", "onBizCallback");
//                result.put("data", convertMsgToMap(data));
                result.put("data",data);
//                eventSink.success(result);
                notifyFlutterAndAwaitResult("onBizCallback",result,false);
            }

            @Override
            public void onFailure(String data) {
                final Map<String, Object> result = new HashMap<>();
                result.put("method", "onFailure");
//                result.put("data", convertMsgToMap(data));
                result.put("data",data);
//                eventSink.success(result);
                notifyFlutterAndAwaitResult("onFailure",result,false);
            }

            @Override
            public void onError(String data) {
                final Map<String, Object> result = new HashMap<>();
                result.put("method", "onError");
//                result.put("data", convertMsgToMap(data));
                result.put("data",data);
                Log.d("onError",data);
//                eventSink.success(result);
                notifyFlutterAndAwaitResult("onError",result,false);
            }
        });
    }
    private void notifyFlutterAndAwaitResult(String method,Map<String, Object> result,boolean isCallback) {
        // 通知 Flutter，并等待返回值
        methodChannel.invokeMethod(method, result, new MethodChannel.Result() {
            @Override
            public void success(Object result) {
                // Flutter 返回成功，通知 AliyunCaptchaSender
                Log.d("invokeMethod","result"+result);
                if(isCallback){
                    callOnNativeSuccessCallback(result.toString());
                }
            }
            @Override
            public void error(String errorCode, String errorMessage, Object errorDetails) {
                // Flutter 返回错误，通知 AliyunCaptchaSender
            }

            @Override
            public void notImplemented() {
                // 方法未实现，通知 AliyunCaptchaSender
            }
        });


    }
    private void callOnNativeSuccessCallback(String response) {
        // 将 response 转换为 JSON 格式的字符串
//        String jsCode = String.format("window.onNativeSuccessCallback(%s);", response);
        String jsCode = String.format("window.onNativeSuccessCallback('%s');",
                response);
        // 调用 JavaScript
         webView.evaluateJavascript(jsCode, value -> {
            // 处理 JavaScript 执行后的返回值
            Log.d("JS Execution", "Result: " + value);
        });
    }
    @Override
    public View getView() {
        return containerView;
    }

    @Override
    public void dispose() {

    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object args) {
        this.eventSink = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("refresh")) {
            refresh(call, result);
        } else if (call.method.equals("reset")) {
            reset(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void refresh(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.arguments != null) {
            Map<String, Object> params = (Map<String, Object>) call.arguments;
            if (params.containsKey("type"))
                this.captchaType = (String) params.get("type");
            if (params.containsKey("optionJsonString"))
                this.captchaOptionJsonString = (String) params.get("optionJsonString");
//            if (params.containsKey("customStyle"))
//                this.captchaCustomStyle = (String) params.get("customStyle");
        }
        this.webView.loadUrl("file:///android_asset/" + this.captchaHtmlPath);
        result.success(true);
    }

    private void reset(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
//        String jsCode = "window.captcha_button.reset();";
        final float scale = webView.getContext().getResources().getDisplayMetrics().density;

        int widgetHeight = (int) (containerView.getMeasuredHeight() / scale);

        String jsCode = String.format("window._init('%s', {\"height\":%d}, '%s');",
                captchaType,
                widgetHeight,
                captchaOptionJsonString);

        webView.post(()->webView.evaluateJavascript(jsCode, new ValueCallback<String>() {
            @Override
            public void onReceiveValue(String value) {
            }
        }));
        result.success(true);
    }

    private static Map<String, Object> convertMsgToMap(String jsonString) {
        Map<String, Object> map = new HashMap<String, Object>();
        JSONObject jsonObject = null;
        try {
            jsonObject = new JSONObject(jsonString);
            map = toMap(jsonObject);
        } catch (JSONException ex) {
            // skip;
            ex.printStackTrace();
        }
        return map;
    }

    private static Map<String, Object> toMap(JSONObject jsonObject) throws JSONException {
        Map<String, Object> map = new HashMap<String, Object>();
        Iterator<String> keys = jsonObject.keys();
        while (keys.hasNext()) {
            String key = keys.next();
            Object value = jsonObject.get(key);
            if (value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            map.put(key, value);
        }
        return map;
    }
}

//
//  FlutterAliyunCaptchaButton.m
//
//  Created by Lijy91 on 2020/12/24.
//

#import "FlutterAliyunCaptchaButton.h"

// FlutterAliyunCaptchaButtonController
@implementation FlutterAliyunCaptchaButtonController {
    UIView* _containerView;
    FlutterAliyunCaptchaButton* _aliyunCaptchaButton;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
//    FlutterEventChannel* _eventChannel;
//    FlutterEventSink _eventSink;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if (self = [super init]) {
        _viewId = viewId;
        
        NSString* channelName = [NSString stringWithFormat:@"leanflutter.org/aliyun_captcha_button/channel_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        
//        NSString* eventChannelName = [NSString stringWithFormat:@"leanflutter.org/aliyun_captcha_button/event_channel_%lld", viewId];
//        _eventChannel = [FlutterEventChannel eventChannelWithName:eventChannelName
//                                                  binaryMessenger:messenger];
//        [_eventChannel setStreamHandler:self];
        
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
        _aliyunCaptchaButton = [[FlutterAliyunCaptchaButton alloc] initWithArguments:args];
        _aliyunCaptchaButton.onSuccess = ^(NSString * _Nonnull data) {
//            NSString *dataString = [data description];
//            NSLog(@"_aliyunCaptchaButton.onSuccess  dataString %@", dataString);
//            NSString *quotedDataString = [NSString stringWithFormat:@"%@", data ?: @""];
//            NSLog(@"_aliyunCaptchaButton.onSuccess quotedDataString %@", quotedDataString);
            NSDictionary<NSString *, id> *result = @{
                @"method": @"onSuccess",
                @"data": data ?: @"",
            };
//            self->_eventSink(eventData);
            [weakSelf notifyFlutterAndAwaitResult:@"onSuccess" data:result isCallback:YES];

        };
        _aliyunCaptchaButton.onBizCallback = ^(NSString * _Nonnull data) {
            NSString *dataString = [data description];
            BOOL biz = [dataString isEqualToString:@"1"]; // 检查是否等于 "1"
            NSDictionary<NSString *, id> *result = @{
                @"method": @"onBizCallback",
                @"data": biz ? @"true" : @"false" // 根据 BOOL 值返回对应的字符串
            };
//            self->_eventSink(eventData);
            [weakSelf notifyFlutterAndAwaitResult:@"onBizCallback" data:result isCallback:NO];

        };
        _aliyunCaptchaButton.onFailure = ^(NSString * _Nonnull data) {
            NSString *dataString = [data description];
            NSDictionary<NSString *, id> *result = @{
                @"method": @"onFailure",
                @"data": dataString ?: @"",
            };
//            self->_eventSink(eventData);
            [weakSelf notifyFlutterAndAwaitResult:@"onFailure" data:result isCallback:NO];

        };
        _aliyunCaptchaButton.onError = ^(NSString * _Nonnull data) {
            NSString *dataString = [data description];
            NSDictionary<NSString *, id> *result = @{
                @"method": @"onError",
                @"data": dataString ?: @"",
            };
//            self->_eventSink(eventData);
            [weakSelf notifyFlutterAndAwaitResult:@"onError" data:result isCallback:NO];

        };
    }
    return self;
}

- (void)notifyFlutterAndAwaitResult:(NSString *)method
                               data:(NSDictionary *)data
                        isCallback:(BOOL)isCallback {
    [_channel invokeMethod:method arguments:data result:^(id  _Nullable flutterResult) {
        if (flutterResult) {
            NSLog(@"Flutter returned result for method %@: %@", method, flutterResult);
            if (isCallback && [method isEqualToString:@"onSuccess"]) {
                [self callOnNativeSuccessCallback:flutterResult];
            }
        } else {
            NSLog(@"Flutter did not return a result for method %@", method);
        }
    }];
}
- (void)callOnNativeSuccessCallback:(NSString *)response {
    [_aliyunCaptchaButton callOnNativeSuccessCallback:response];
}

- (UIView*)view {
    return _aliyunCaptchaButton;
}

//- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
//    _eventSink = eventSink;
//    
//    return nil;
//}
//
//- (FlutterError*)onCancelWithArguments:(id)arguments {
//    _eventSink = nil;
//    
//    return nil;
//}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"refresh"]) {
        [self refresh:call result: result];
    } else if ([[call method] isEqualToString:@"reset"]) {
        [self reset:call result: result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)refresh:(FlutterMethodCall*)call
         result:(FlutterResult)result {
    [_aliyunCaptchaButton refresh: call.arguments];
    result([NSNumber numberWithBool:YES]);
}

- (void)reset:(FlutterMethodCall*)call
       result:(FlutterResult)result {
    [_aliyunCaptchaButton reset];
    result([NSNumber numberWithBool:YES]);
}

@end

// FlutterAliyunCaptchaButtonFactory
@implementation FlutterAliyunCaptchaButtonFactory{
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger{
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    FlutterAliyunCaptchaButtonController* aliyunCaptchaButtonController = [[FlutterAliyunCaptchaButtonController alloc] initWithFrame:frame
        viewIdentifier:viewId
        arguments:args
        binaryMessenger:_messenger];
    return aliyunCaptchaButtonController;
}
@end

@implementation FlutterAliyunCaptchaButton

- (instancetype)initWithArguments:(id _Nullable)args
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.webView = [[WKWebView alloc] initWithFrame:self.frame configuration:self.webViewConfiguration];
        self.webView.navigationDelegate = self;
        self.webView.UIDelegate = self;
        
        self.webView.backgroundColor = [UIColor clearColor];
        self.webView.scrollView.backgroundColor = [UIColor clearColor];
        self.webView.opaque = false;
        self.webView.scrollView.alwaysBounceVertical = false;
        self.webView.scrollView.bounces = false;
        
        [self addSubview:self.webView];
        
        NSString* captchaHtmlKey = [FlutterDartProject lookupKeyForAsset:@"assets/captcha.html" fromPackage:@"flutter_aliyun_captcha"];
        NSString* captchaHtmlPath = [[NSBundle mainBundle] pathForResource:captchaHtmlKey ofType:nil];
        self.captchaHtmlPath = captchaHtmlPath;
//        self.captchaType = args[@"type"];
        self.captchaOptionJsonString = args[@"optionJsonString"];
//        self.captchaCustomStyle = args[@"customStyle"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.webView != nil) {
        self.webView.frame = self.frame;
    }
}

- (void)refresh:(id _Nullable)args {
    if (args != nil) {
//        self.captchaType = args[@"type"];
        self.captchaOptionJsonString = args[@"optionJsonString"];
//        self.captchaCustomStyle = args[@"customStyle"];
    }
    
    NSURL* url = [NSURL fileURLWithPath:self.captchaHtmlPath];
    if (@available(iOS 9.0, *)) {
        [self.webView loadFileURL:url allowingReadAccessToURL:url];
    }
}

- (void)reset {
//    NSString *jsCode = @"window.captcha_button.reset();";
//    NSString *jsCode = [NSString stringWithFormat:@"window._init('%@', {\"height\":%f}, '%@');",
    NSString *jsCode = [NSString stringWithFormat:@"window._init('%@');",
//                        self.frame.size.height,
                        self.captchaOptionJsonString];
    [self.webView evaluateJavaScript:jsCode completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"JavaScript execution error in reset: %@", error.localizedDescription);
        } else {
            NSLog(@"JavaScript reset executed successfully.");
        }
    }];
}

- (void)callOnNativeSuccessCallback:(NSString *)response {
    NSLog(@"Native received success callback from Flutter: %@", response);

    // 生成 JavaScript 代码
    NSString *jsCode = [NSString stringWithFormat:@"window.onNativeSuccessCallback('%@');", response];

    // 调用 JavaScript
    [self.webView evaluateJavaScript:jsCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"JavaScript execution error: %@", error.localizedDescription);
        } else {
            NSLog(@"JavaScript execution result: %@", result);
        }
    }];
}



- (WKWebViewConfiguration *)webViewConfiguration {
    if (!_webViewConfiguration) {
        // 创建 WKWebViewConfiguration 实例
        _webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        
        // 创建 WKUserContentController 实例
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        
        // 添加页面自适应缩放的 JavaScript
        NSString *javascript = @"var meta = document.createElement('meta');"
                                "meta.setAttribute('name', 'viewport');"
                                "meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');"
                                "document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javascript
                                                         injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                      forMainFrameOnly:YES];
        [userContentController addUserScript:userScript];
        
        // 添加 JavaScript 调用原生的接口
        [userContentController addScriptMessageHandler:self name:@"onSuccess"];
        [userContentController addScriptMessageHandler:self name:@"onBizCallback"];
        [userContentController addScriptMessageHandler:self name:@"onFailure"];
        [userContentController addScriptMessageHandler:self name:@"onError"];
        
        // 设置 UserContentController
        _webViewConfiguration.userContentController = userContentController;
        
        // 配置 JavaScript 设置
        _webViewConfiguration.preferences.javaScriptEnabled = YES;
        _webViewConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    }
    return _webViewConfiguration;
}

#pragma mark -WKScriptMessageHandler
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
//    NSDictionary *messageBody = message.body;
    // 将 message.body 处理为字符串
    NSString *messageString = [message.body description];

    if ([message.name isEqualToString:@"onSuccess"]) {
        self.onSuccess(messageString);
    }else if ([message.name isEqualToString:@"onBizCallback"]) {
        self.onBizCallback(messageString);
    } else if ([message.name isEqualToString:@"onFailure"]) {
        self.onFailure(messageString);
    } else if ([message.name isEqualToString:@"onError"]) {
        self.onError(messageString);
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *jsCode = [NSString stringWithFormat:@"window._init('%@');",
//                        self.frame.size.height,
                        self.captchaOptionJsonString];
    [self.webView evaluateJavaScript:jsCode completionHandler:^(id response, NSError * _Nullable error) {
        // skip
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    if (navigationAction.request.URL) {
        
        NSURL *url = navigationAction.request.URL;
        NSString *urlPath = url.absoluteString;
        if ([urlPath rangeOfString:@"https://"].location != NSNotFound || [urlPath rangeOfString:@"http://"].location != NSNotFound) {
            
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    return nil;
}

@end

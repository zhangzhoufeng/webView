//
//  AKMWebView.m
//  AKMWebView
//
//  Created by 一公里 on 2016/12/22.
//  Copyright © 2016年 WebView自定义. All rights reserved.
//
#define SYSTEM_VERSON [[[UIDevice currentDevice] systemVersion] floatValue]

#import "ZFWebView.h"
#import <WebKit/WebKit.h>

@interface ZFWebView()<WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate>
/** webView */
@property (nonatomic, strong) id webView;
@end
@implementation ZFWebView
/** 直接传入url */
- (void)setUrl:(NSString *)url{
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
/** 是否可滑动 */
- (void)setScrollEnabled:(BOOL)scrollEnabled{
    if (SYSTEM_VERSON < 8) {
        ((UIWebView *)self.webView).scrollView.scrollEnabled = scrollEnabled;
        ((UIWebView *)self.webView).scrollView.bounces = scrollEnabled;
    }else{
        ((WKWebView *)self.webView).scrollView.scrollEnabled = scrollEnabled;
        ((WKWebView *)self.webView).scrollView.bounces = scrollEnabled;
    }
}
/** 坐标与大小 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (SYSTEM_VERSON < 8) {
            UIWebView *webView = [[UIWebView alloc]initWithFrame:frame];
            webView.scalesPageToFit = YES;
            webView.delegate = self;
            webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.webView = webView;
        }else{
            WKWebView *webView = [[WKWebView alloc]initWithFrame:frame];
            webView.UIDelegate = self;
            webView.navigationDelegate = self;
            webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.webView = webView;
        }
        [self addSubview:self.webView];
    }
    return self;
}
/** 加载请求地址 */
- (void)loadRequest:(NSURLRequest *)request{
    if (SYSTEM_VERSON < 8) {
        [(UIWebView *)self.webView loadRequest:request];
    }else{
        [(WKWebView *)self.webView loadRequest:request];
    }
}
/** 加载HTML代码 */
- (void)loadHTMLString:(NSString *)htmlString baseURL:(NSURL *)baseURL{
    if (SYSTEM_VERSON < 8) {
        [(UIWebView *)self.webView loadHTMLString:htmlString baseURL:baseURL];
    }else{
        [(WKWebView *)self.webView loadHTMLString:htmlString baseURL:baseURL];
    }
}
/** 执行js代码 */
- (void)evaluateJavaScript:(NSString *)js completionHandler:(void (^)(id))completionHandler{
    if (SYSTEM_VERSON < 8) {
        completionHandler([(UIWebView *)self.webView stringByEvaluatingJavaScriptFromString:js]);
    }else{
        [(WKWebView *)self.webView evaluateJavaScript:js completionHandler:^(id _Nullable str, NSError * _Nullable error) {
            if (!error) {
                completionHandler(str);
            }
        }];
    }
}
#define webViewDelegate
/** UIWebViewDelegate */
//当网页视图被指示载入内容而得到通知。应当返回YES，这样会进行加载。
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self.delegate webView:webView shouldStartLoadWithUrl:[request.URL absoluteString]];
    return [self webView:webView shouldStartLoadWithUrl:[request.URL absoluteString]];
}
// 页面开始加载时调用
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.delegate webViewDidStartLoad:webView];
}
// 页面加载完成之后调用
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    __weak typeof(self) weakSelf = self;
    [self evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id htmlHeight) {
        [weakSelf.delegate webViewDidFinishLoad:webView webViewHeight:[htmlHeight floatValue]];
        [weakSelf webView:webView didFinishLoadWithWebViewHeight:[htmlHeight floatValue]];
    }];
}
// 页面加载失败时调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.delegate webView:webView didFailLoadWithError:error];
}
/** WKWebViewDelegate */
//当网页视图被指示载入内容而得到通知。应当返回YES，这样会进行加载。
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    BOOL ispush =  [self webView:webView shouldStartLoadWithUrl:[navigationAction.request.URL absoluteString]];
    if (ispush) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self.delegate webViewDidStartLoad:webView];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    __weak typeof(self) weakSelf = self;
    [self evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id htmlHeight) {
        [weakSelf.delegate webViewDidFinishLoad:webView webViewHeight:[htmlHeight floatValue]];
        [weakSelf webView:webView didFinishLoadWithWebViewHeight:[htmlHeight floatValue]];
    }];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [self.delegate webView:webView didFailLoadWithError:nil];
}
#pragma mark -- 子类调用的
//加载成功后触发
- (void)webView:(id)webView didFinishLoadWithWebViewHeight:(CGFloat)webViewHeight{}
//webView内部跳转触发
- (BOOL)webView:(id)webView shouldStartLoadWithUrl:(NSString *)url{ return YES;}

@end

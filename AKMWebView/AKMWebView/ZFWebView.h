//
//  AKMWebView.h
//  AKMWebView
//
//  Created by 一公里 on 2016/12/22.
//  Copyright © 2016年 WebView自定义. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ZFWebView;
@protocol AKMWebViewDelegate <NSObject>
@optional
/** webView开始加载 */
- (void)webViewDidStartLoad:(id)webView;
/** webView加载完成 */
- (void)webViewDidFinishLoad:(id)webView webViewHeight:(CGFloat)height;
/** webView加载失败 */
- (void)webView:(id)webView didFailLoadWithError:(NSError *)error;
/** webView内部跳转 */
- (void)webView:(id)webView shouldStartLoadWithUrl:(NSString *)url;
@end

@interface ZFWebView : UIView
/** 直接传入url */
@property (nonatomic, copy) NSString *url;
/** 代理 */
@property (nonatomic, weak) __weak id<AKMWebViewDelegate>delegate;
/** 是否可滑动 */
@property (nonatomic, assign) BOOL scrollEnabled;
/** 加载请求地址 */
- (void)loadRequest:(NSURLRequest *)request;
/** 加载HTML代码 */
- (void)loadHTMLString:(NSString *)htmlString baseURL:(NSURL *)baseURL;
/** 执行js代码 */
- (void)evaluateJavaScript:(NSString *)js completionHandler:(void (^)(id))completionHandler;
#pragma mark 以下为子类去实现
/** 加载完成 */
- (void)webView:(id)webView didFinishLoadWithWebViewHeight:(CGFloat)webViewHeight;
/** webView内部链接跳转触发,返回YES，这样会进行加载。返回NO,子类自定义进行相应操作(与原生交互) */
- (BOOL)webView:(id)webView shouldStartLoadWithUrl:(NSString *)url;
@end

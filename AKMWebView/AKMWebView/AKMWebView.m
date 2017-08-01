//
//  AKMWebView.m
//  AKMWebView
//
//  Created by 一公里 on 2016/12/22.
//  Copyright © 2016年 WebView自定义. All rights reserved.
//

#import "AKMWebView.h"

@interface AKMWebView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end
@implementation AKMWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(webViewClick:)];
        self.tap.delegate = self;
        [self addGestureRecognizer:self.tap];
    }
    return self;
}
#pragma mark -- webView被点击
- (void)webViewClick:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self];
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", point.x, point.y];
    [self evaluateJavaScript:js completionHandler:^(id tagName) {
        NSLog(@"%@",tagName);
        if ([tap isEqual:@"IMG"]) {
           NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", point.x, point.y];
            [self evaluateJavaScript:js completionHandler:^(id src) {
                NSLog(@"%@",src);
            }];
        }
    }];

}
/** 界面加载完成 */
- (void)webView:(id)webView didFinishLoadWithWebViewHeight:(CGFloat)webViewHeight{
    CGRect rect = self.frame;
    rect.size.height = webViewHeight;
    self.frame = rect;
}
//webView内部链接跳转触发,返回YES，这样会进行加载。返回NO,子类自定义进行相应操作(与原生交互)
- (BOOL)webView:(id)webView shouldStartLoadWithUrl:(NSString *)url{
    if ([url hasPrefix:@"about:blank"]) {
        return YES;
    }
    return NO;
}

#pragma mark -- 手势delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (gestureRecognizer == self.tap) {
        return YES;
    }
    return NO;
}
@end

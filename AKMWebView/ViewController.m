//
//  ViewController.m
//  AKMWebView
//
//  Created by 一公里 on 2016/12/22.
//  Copyright © 2016年 WebView自定义. All rights reserved.
//

#import "ViewController.h"
#import "AKMWebView.h"
#import "ZFWebView.h"
#import <WebKit/WebKit.h>
@interface ViewController ()
@property (nonatomic, strong)float (^block)(float);

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AKMWebView *akm = [[AKMWebView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
//    akm.url = @"https://www.baidu.com";
    [akm loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    akm.backgroundColor = [UIColor redColor];
    [self.view addSubview:akm];

    
    [self setBlock:^float(float value) {
        return value + 10;
    }];
    NSLog(@"%f",self.block(5));
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

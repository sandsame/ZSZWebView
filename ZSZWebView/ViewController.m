//
//  ViewController.m
//  ZSZWebView
//
//  Created by 朱松泽 on 17/2/23.
//  Copyright © 2017年 gdtech. All rights reserved.
//

#import "ViewController.h"
#import "ZSZWebVIew.h"
@interface ViewController ()<ZSZWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"webCamara" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    ZSZWebVIew *zszWebView = [[ZSZWebVIew alloc] initWithFrame:self.view.frame HtmlString:html baseURL:baseURL];
    zszWebView.delegate = self;
    [self.view addSubview:zszWebView];
    
}

- (BOOL)zszWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    return YES;
}

- (void)zszWebViewDidFinishLoad:(UIWebView *)webView {

}

-(void)zszWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}
-(void)zszWebViewDidStartLoad:(UIWebView *)webView {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

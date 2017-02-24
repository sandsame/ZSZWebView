//
//  ZSZWebVIew.h
//  ZSZWebView
//
//  Created by 朱松泽 on 17/2/23.
//  Copyright © 2017年 gdtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSZWebViewDelegate <NSObject>
@optional
- (BOOL)zszWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)zszWebViewDidFinishLoad:(UIWebView *)webView;
- (void)zszWebViewDidStartLoad:(UIWebView *)webView;
- (void)zszWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end

@interface ZSZWebVIew : UIView

@property (nonatomic, weak) id<ZSZWebViewDelegate>delegate;
-(instancetype)initWithFrame:(CGRect)frame HtmlString:(NSString *)htmlString baseURL:(NSURL *)baseURL;
- (instancetype)initWithFrame:(CGRect)frame UrlString:(NSString *)urlString;
@end

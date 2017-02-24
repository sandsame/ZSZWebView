//
//  ZSZWebVIew.m
//  ZSZWebView
//
//  Created by 朱松泽 on 17/2/23.
//  Copyright © 2017年 gdtech. All rights reserved.
//

#import "ZSZWebVIew.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ZSZWebVIew()<UIWebViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIWebView *myWebView;
@property (nonatomic, strong) UIProgressView *progressView;

@end


@implementation ZSZWebVIew
// 避免用户使用这个初始化方法
- (instancetype)init {
 @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"必须使用ZSZWebVIew.h文件中声明的两个方法" userInfo:nil];
}
// 避免用户使用这个初始化方法
- (instancetype)initWithFrame:(CGRect)frame {

    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"必须使用ZSZWebVIew.h文件中声明的两个方法" userInfo:nil];
}

-(instancetype)initWithFrame:(CGRect)frame HtmlString:(NSString *)htmlString baseURL:(NSURL *)baseURL{
    if (self = [super initWithFrame:frame]) {
        
        self.myWebView = [[UIWebView alloc] initWithFrame:frame];
        [self.myWebView loadHTMLString:htmlString baseURL:baseURL];
        self.myWebView.delegate = self;
        [self addSubview:self.myWebView];
        
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2)];
        [self.myWebView addSubview:self.progressView];
        [self increateProgress];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame UrlString:(NSString *)urlString{

    if (self = [super initWithFrame:frame]) {
     
        self.myWebView = [[UIWebView alloc] initWithFrame:frame];
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        self.myWebView.delegate = self;
        [self addSubview:self.myWebView];
        
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2)];
        [self.myWebView addSubview:self.progressView];
        [self increateProgress];
    }
    
    return self;
}

#pragma mark --- webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    self.progressView.hidden = NO;
    progressValue = 0;
    [self increateProgress];

    if ([self.delegate respondsToSelector:@selector(zszWebView:shouldStartLoadWithRequest:navigationType:)]) {
        [self.delegate zszWebView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.progressView.hidden = YES;
    
    // 创建JSContext
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    // 调用系统相机
    context[@"iOSCamera"] = ^(){
        
        // 调用系统相机的类
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        
        // 设置选取的照片是否可编辑
        pickerController.allowsEditing = YES;
        // 设置相册呈现的样式
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
        pickerController.delegate = self;
        
        // 使用模态呈现相册
        [[self getCurrentViewController] presentViewController:pickerController animated:YES completion:nil];
        
        return @"调用相机";
    };
    
    
    context[@"iOSPhotosAlbum"] = ^(){
        
        // 调用系统相册的类
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        
        // 设置选取的照片是否可编辑
        pickerController.allowsEditing = YES;
        // 设置相册呈现的样式
        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        // 选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
        pickerController.delegate = self;
        
        // 使用模态呈现相册
        [[self getCurrentViewController] presentViewController:pickerController animated:YES completion:nil];
        
        return @"调用相册";
        
    };
    
    if ([self.delegate respondsToSelector:@selector(zszWebViewDidFinishLoad:)]) {
        [self.delegate zszWebViewDidFinishLoad:webView];
    }
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([self.delegate respondsToSelector:@selector(zszWebViewDidStartLoad:)]) {
        [self.delegate zszWebViewDidStartLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(zszWebView:didFailLoadWithError:)]) {
        [self.delegate zszWebView:webView didFailLoadWithError:error];
    }
    
}

#pragma mark - 进度条累加
static float progressValue = 0.0f;
- (void)increateProgress
{
    [self.progressView setProgress:progressValue animated:NO];
    progressValue += 0.0001;
    if (progressValue < 0.8) {
        [self performSelector:@selector(increateProgress) withObject:nil afterDelay:0.001];
    }else{
        [self.progressView setProgress:0.8 animated:NO];
    }
    
}

/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}


#pragma mark --- 拍完照或者相册选择照片后的方法

// 选择照片完成之后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // info是所选择照片的信息
    //  UIImagePickerControllerEditedImage//编辑过的图片
    //  UIImagePickerControllerOriginalImage//原图
    NSLog(@"info---%@",info);
    
    // 刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象压缩上传到服务器
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    // 压缩一下图片再上传

    NSData *imgData = UIImageJPEGRepresentation(resultImage, 0.001);
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[self.myWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [self removeSpaceAndNewline:encodedImageStr];
    //使用模态返回到软件界面
    [[self getCurrentViewController] dismissViewControllerAnimated:YES completion:nil];
    // 这里传值给h5界面
    NSString *imageString = [self removeSpaceAndNewline:encodedImageStr];
    NSString *jsFunctStr = [NSString stringWithFormat:@"rtnCamera('%@')",imageString];
    [context evaluateScript:jsFunctStr];
}

- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}
////单个文件的大小
//- (long long) fileSizeAtPath:(NSString*) filePath{
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:filePath]){
//        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize] / 1024.0;
//    }
//    return 0;
//}

//点击取消按钮所执行的方法

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
    //这是捕获点击右上角cancel按钮所触发的事件，如果我们需要在点击cancel按钮的时候做一些其他逻辑操作。就需要实现该代理方法，如果不做任何逻辑操作，就可以不实现
    [[self getCurrentViewController] dismissViewControllerAnimated:YES completion:nil];
    
}
// 压缩图片的方法
- (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

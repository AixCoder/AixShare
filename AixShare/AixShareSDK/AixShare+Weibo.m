//
//  AixShare+Weibo.m
//  AixShare
//
//  Created by liuhongnian on 16/8/4.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "AixShare+Weibo.h"

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface AixShare ()<WKNavigationDelegate>

@end

@implementation AixShare (Weibo)
static NSString *platform = @"weibo";

+ (void)registerWeiboWithAppID:(NSString *)appID appKey:(NSString *)appKey redirectURL:(NSString *)redirectUrl
{
    NSDictionary *key = @{@"appID":appID,
                          @"appKey":appKey,
                          @"redirectURL":redirectUrl};
    
    [[AixShare sharedInstance] setKey:key forPlatform:platform];
}

+ (BOOL)isInstallWeiboApp
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibosdk://request"]];
}

/**
 *  调用APP 分享内容
 *
 *  @param shareContent 分享的数据
 *  @param success      成功回调
 *  @param fail         分享失败回调
 */
+ (void)shareToWeibo:(AixShareContent *)shareContent
             Success:(shareSuccessHandler)success
                Fail:(shareFailHandler)fail
{
    //分享的链接
    NSString *title = shareContent.title;
    NSString *link = shareContent.link;
    UIImage *image = shareContent.image;
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    NSDictionary *message = @{@"__class":@"WBMessageObject",
                              @"mediaObject":@{
                                      @"__class":@"WBWebpageObject",
                                      @"objectID":@"identifier1",
                                      @"title":title,
                                      @"description":title,
                                      @"thumbnailData":imgData,
                                      @"webpageUrl":link}};
    
    NSString *uuid =[NSUUID UUID].UUIDString;
    NSData *transferObject = [NSKeyedArchiver archivedDataWithRootObject:@{@"__class":@"WBSendMessageToWeiboRequest",
                                                                           @"message":message,
                                                                           @"requestID":uuid}];
    
    
    NSData *userInfo = [NSKeyedArchiver archivedDataWithRootObject:@{}];
    NSString *appKey = [AixShare sharedInstance].appsKeys[platform][@"appID"];
    
    NSString *bundleId = [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
    NSData *app = [NSKeyedArchiver archivedDataWithRootObject:@{@"appKey":appKey,@"bundleID":bundleId}];
    
    NSArray *shareDatas = @[@{@"transferObject":transferObject},
                            @{@"app":app},
                            @{@"userInfo":userInfo}];
    [UIPasteboard generalPasteboard].items = shareDatas;
    
    //open url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"weibosdk://request?id=%@&sdkversion=003013000",uuid]];
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)shareToWeibo:(AixShareContent *)shareContent
     withAccessToken:(NSString *)token
             Success:(shareSuccessHandler)success
                Fail:(shareFailHandler)fail
{
    NSAssert(token, @"accesstoken must need");
    
    //微博分享就三种方式 纯文本+链接+图片
    //文本
    
    //链接
    NSString *title = shareContent.title;
    NSString *link = shareContent.link;
    NSString *shareText = [NSString stringWithFormat:@"%@%@",title,link];
    
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/update.json"];
    
    NSData *bodyData = [[NSString stringWithFormat:@"status=%@&access_token=%@",shareText,token] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = bodyData;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            NSDictionary *ret = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL];
            NSLog(@"ret:%@",ret);
            
        }
    }];
    [task resume];
    
    //图片
}

+ (void)weiboAuth:(NSString *)scope
      redirectUri:(NSString *)redirecturi
          Success:(AuthSuccess)success
             Fail:(AuthFail)fail
{
    [AixShare sharedInstance].oauthSuccessCallBack = success;
    [AixShare sharedInstance].oauthFailCallBack = fail;
    
    if ([self isInstallWeiboApp]) {
        //调用APP 完成auth
        
    }else{
        
        //web auth
        NSString *appKey = [AixShare sharedInstance].appsKeys[platform][@"appID"];
        scope = scope ? scope : @"all";
        NSString *webOauthUrl = [NSString stringWithFormat:@"https://open.weibo.cn/oauth2/authorize?client_id=%@&response_type=code&redirect_uri=%@&scope=%@",appKey,redirecturi,scope];
        
        [self openWebViewByURLString:webOauthUrl];
        
    }
}

+ (void)openWebViewByURLString:(NSString *)weburl
{
    if(![weburl hasPrefix:@"https://open.weibo.cn"])
    {
        return;
    }
    
    CGFloat x = 0.;
    CGFloat y = [UIScreen mainScreen].bounds.size.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    webView.navigationDelegate = [AixShare sharedInstance];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weburl]]];
    

    //add activity view
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    activityView.center = webView.center;
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [webView.scrollView addSubview:activityView];
    [activityView startAnimating];
    
    //animate show web view
    [[UIApplication sharedApplication].keyWindow addSubview:webView];
    [UIView animateWithDuration:0.32 delay:0. options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        webView.frame = CGRectMake(0, 0, w, h);
        
    } completion:NULL];
}

#pragma mark WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSString *scriptStr = @"var button = document.createElement('a'); button.setAttribute('href', 'about:blank'); button.innerHTML = '关闭'; button.setAttribute('style', 'width: calc(100% - 40px); background-color: gray;display: inline-block;height: 40px;line-height: 40px;text-align: center;color: #777777;text-decoration: none;border-radius: 3px;background: linear-gradient(180deg, white, #f1f1f1);border: 1px solid #CACACA;box-shadow: 0 2px 3px #DEDEDE, inset 0 0 0 1px white;text-shadow: 0 2px 0 white;position: fixed;left: 0;bottom: 0;margin: 20px;font-size: 18px;'); document.body.appendChild(button);";
    
    scriptStr = [scriptStr stringByAppendingString:@"document.querySelector('aside.logins').style.display = 'none';"];
    
    [webView evaluateJavaScript:scriptStr completionHandler:NULL];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    __weak __typeof(self) weakSelf = self;
    //关闭
    if ([webView.URL.absoluteString containsString:@"about:blank"]) {
        
        [UIView animateWithDuration:0.32 delay:0. options:UIViewAnimationOptionCurveEaseOut animations:^{

            CGFloat x = 0;
            CGFloat y = [UIScreen mainScreen].bounds.size.height;
            CGFloat w = [UIScreen mainScreen].bounds.size.width;
            CGFloat h =[UIScreen mainScreen].bounds.size.height;
            webView.frame = CGRectMake(x, y, w, h);
            
        } completion:^(BOOL finished) {
            
            [webView removeFromSuperview];
            //用户放弃微博授权
            weakSelf.oauthFailCallBack(nil,[NSError errorWithDomain:@"用户放弃授权" code:-10 userInfo:nil]);
        }];
    }
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSString *redirectURL = [AixShare sharedInstance].appsKeys[platform][@"redirectURL"];
    
    if ([webView.URL.absoluteString.lowercaseString hasPrefix:redirectURL]) {
        
        //code
        NSString *code;
        NSURLComponents *components = [NSURLComponents componentsWithURL:webView.URL resolvingAgainstBaseURL:NO];
        
        NSArray *items = components.queryItems;
        for (NSURLQueryItem *item in items) {
            
            if ([item.name isEqualToString:@"code"]) {
                code = item.value;
            }
        }
        
        //请求token
        NSURLSession *seession = [NSURLSession sharedSession];
        
        NSURL *reqUrl = [NSURL URLWithString:@"https://api.weibo.com/oauth2/access_token"];
        
        NSDictionary *keys = [AixShare sharedInstance].appsKeys[platform];
        NSString *app_id = keys[@"appID"];
        NSString *app_key = keys[@"appKey"];
        NSString *redirectURL = keys[@"redirectURL"];
        
        NSString *arg = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",app_id,app_key,redirectURL,code];
        NSData *postData = [arg dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *requestToken = [NSMutableURLRequest requestWithURL:reqUrl];
        requestToken.HTTPMethod = @"POST";
        requestToken.HTTPBody = postData;
        
        __weak __typeof(self) weakSelf = self;
        NSURLSessionDataTask *dataTask = [seession dataTaskWithRequest:requestToken completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL];
            NSLog(@"result = %@",result);
            
            if (!error) {
                weakSelf.oauthSuccessCallBack(result);
            }
        }];
        [dataTask resume];
        
    }
}

@end

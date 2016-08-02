//
//  AixShare+Wechat.m
//  AixShare
//
//  Created by liuhongnian on 16/8/1.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "AixShare+Wechat.h"
#import <UIKit/UIKit.h>

@implementation AixShare (Wechat)

static NSString *platformName = @"weixin";

+ (void)registerWechatWithAppID:(NSString *)app_id
{
    [[AixShare sharedInstance] setKey:@{@"AppID":app_id} forPlatform:platformName];
}

+ (void)shareToWechatSession:(AixShareContent *)shareContent
                     Success:(shareSuccessHandler)shareSuccess
                        Fail:(shareFailHandler)failHandler
{
    //判断是否能分享(微信必须要安装客户端才能分享)
    if (![self isInstalledWeChatApp]) {
        
        return;
    }
    //验证分享的数据格式是否正确
    
    //调用微信爱屁屁进行分享操作
    [self shareToWechatWithContent:shareContent
                             scene:0
                           Success:shareSuccess
                              Fail:failHandler];
    
}

+ (BOOL)isInstalledWeChatApp
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
}

+ (void)shareToWechatWithContent:(AixShareContent *)content
                           scene:(NSInteger)scene
                         Success:(shareSuccessHandler)shareCompletionHandler
                            Fail:(shareFailHandler)shareFailHandler
{
    
    //检查是否设置了appid
    NSDictionary *wechatAppKey = [AixShare sharedInstance].appsKeys[platformName];
    if (!wechatAppKey) {
        //没有设置appid,请先在delegate设置appid
        return;
    }
    
    //检查有没有网络
    [AixShare sharedInstance].shareContent = content;
    [AixShare sharedInstance].shareSuccessCallBack = shareCompletionHandler;
    [AixShare sharedInstance].shareFailCallBack = shareFailHandler;

    NSMutableDictionary *wechatContent = @{@"result":@"1",
                                    @"returnFromApp":@"0",
                                    @"scene":@(scene),
                                    @"sdkver":@"1.5",
                                    @"command":@"1010"}.mutableCopy;
    //分享标题
    if (content.title) {
        wechatContent[@"title"] = content.title;
        wechatContent[@"command"] = @"1020";
    }
    
    AixMediaType media = content.mediaType;
    switch (media) {
        case AixMediaTypeURL:
        {
            break;
        }
        default:
            break;
    }
    
    NSString *appID = [AixShare sharedInstance].appsKeys[platformName][@"AppID"];
    NSDictionary *info = @{appID:wechatContent};
    
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:info format:NSPropertyListBinaryFormat_v1_0 options:0 error:NULL];
    [[UIPasteboard generalPasteboard] setData:data forPasteboardType:@"content"];
    
    NSString *wechatSchemeUrl = [NSString stringWithFormat:@"weixin://app/%@/sendreq/?",appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:wechatSchemeUrl]];
    
    
}

+ (BOOL)weixin__hanldeOpenURL:(NSURL*)url
{
    if ([url.scheme hasPrefix:@"wx"])
    {
        NSData *data = [[UIPasteboard generalPasteboard] dataForPasteboardType:@"content"];
        NSDictionary *weixinRes = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:0 error:NULL];
        
        NSString *appid =[AixShare sharedInstance].appsKeys[platformName][@"AppID"];
        NSDictionary *result = weixinRes[appid];
        if (result) {
            
            if (0 == [result[@"result"] integerValue]) {
                //success
                shareSuccessHandler successCallBack = [AixShare sharedInstance].shareSuccessCallBack;
                AixShareContent *content = [AixShare sharedInstance].shareContent;
                successCallBack(content);
                
            }else{
                //分享失败
                shareFailHandler failCallBack = [AixShare sharedInstance].shareFailCallBack;
                AixShareContent *content = [AixShare sharedInstance].shareContent;
                NSError *error = [NSError errorWithDomain:@"分享到微信失败" code:[result[@"result"] intValue] userInfo:result];
                failCallBack(content,error);
                
            }
           
            return YES;
        }else{
            return NO;
        }
        
    }
    return NO;
}

@end
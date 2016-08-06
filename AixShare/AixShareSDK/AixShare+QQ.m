//
//  AixShare+QQ.m
//  AixShare
//
//  Created by liuhongnian on 16/8/2.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "AixShare+QQ.h"
#import <UIKit/UIKit.h>

@implementation AixShare (QQ)

static NSString *platform = @"QQ";

+ (void)registerQQWithAppID:(NSString *)appid
{
    NSDictionary *key = @{@"appid":appid,
                          @"callback_name":[NSString stringWithFormat:@"QQ%02llx",[appid longLongValue]]};
    
    [[AixShare sharedInstance]setKey:key forPlatform:platform];
}

+ (void)shareToFriend:(AixShareContent *)shareContent
              Success:(shareSuccessHandler)shareSuccess
                 Fail:(shareFailHandler)shareFail
{
    BOOL QQInstalled = [self isInstallQQApp];
    if (!QQInstalled) {
        
        NSError *error = [NSError errorWithDomain:@"未安装QQ" code:ASQQShareErrorNotInstallApp userInfo:nil];
        shareFail(shareContent,error);
        return;
    }
    
    NSString *appKey = [AixShare sharedInstance].appsKeys[platform][@"appid"];
    if (!appKey) {
        
        NSError *error = [NSError errorWithDomain:@"未注册QQ appKey" code:ASQQShareErrorNotRegisterApp userInfo:nil];
        shareFail(shareContent,error);
        return;
    }
    [self shareContent:shareContent
                    To:0
               Success:shareSuccess
                  Fail:shareFail];
}

+ (void)shareToQQZone:(AixShareContent *)shareContent
              Success:(shareSuccessHandler)shareSuccess
                 Fail:(shareFailHandler)shareFail
{
    
    BOOL QQInstalled = [self isInstallQQApp];
    if (!QQInstalled) {
        
        NSError *error = [NSError errorWithDomain:@"未安装QQ" code:ASQQShareErrorNotInstallApp userInfo:nil];
        shareFail(shareContent,error);
        return;
    }
    
    //有没有注册QQ app信息
    NSString *appKey = [AixShare sharedInstance].appsKeys[platform][@"appid"];
    if (!appKey) {
        
        NSError *error = [NSError errorWithDomain:@"未注册QQ appKey" code:ASQQShareErrorNotRegisterApp userInfo:nil];
        shareFail(shareContent,error);
        return;
    }

    //调用APP进行分享
    [self shareContent:shareContent
                    To:1
               Success:shareSuccess
                  Fail:shareFail];

}

/**
 *  分享消息到QQ
 *
 *  @param shareContent 分享的内容
 *  @param shareTo      0分享到朋友 1分享到Qzone
 *  @param shareSuccess 成功后的回调
 *  @param shareFail    失败后的回调
 */
+ (void)shareContent:(AixShareContent *)shareContent
                  To:(int)shareTo
             Success:(shareSuccessHandler)shareSuccess
                Fail:(shareFailHandler)shareFail
{
    [AixShare sharedInstance].shareSuccessCallBack = shareSuccess;
    [AixShare sharedInstance].shareFailCallBack = shareFail;
    
    NSMutableString *openUrl = [[NSMutableString alloc] initWithString:@"mqqapi://share/to_fri?thirdAppDisplayName="];
    [openUrl appendString:[self base64Encode:[self CFBundleDisplayName]]];
    [openUrl appendString:@"&version=1&cflag="];
    [openUrl appendFormat:@"%d",shareTo];
    [openUrl appendString:@"&callback_type=scheme&generalpastboard=1"];
    [openUrl appendString:@"&callback_name="];
    [openUrl appendString:[AixShare sharedInstance].appsKeys[platform][@"callback_name"]];
    [openUrl appendString:@"&src_type=app&shareType=0&file_type="];
    
    switch (shareContent.mediaType) {
        case AixMediaTypeNews:
        {
            //分享新闻
            if ([shareContent isEmpty:nil AndNotEmpty:@[@"title",@"link",@"subTitle",@"image"]]) {
                
                NSData *imgData = UIImageJPEGRepresentation(shareContent.image, 1);
                NSDictionary *value = @{@"previewimagedata":imgData};
                
                [self setGeneralPasteboard:@"com.tencent.mqq.api.apiLargeData" Value:value encoding:AixPboardEncodingTypeKeyedArchiver];
                
                NSString *msgType = @"news";
                NSString *title = [self urlEncode:[self base64Encode:shareContent.title]];
                NSString *url = [self urlEncode:[self base64Encode:shareContent.link]];
                NSString *description = [self urlEncode:[self base64Encode:shareContent.subTitle]];
                [AixShare sharedInstance].shareContent = shareContent;

                [openUrl appendFormat:@"%@&title=%@&url=%@&description=%@&objectlocation=pasteboard",msgType,title,url,description];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
                
            }else{
                
                NSError *error = [NSError errorWithDomain:@"分享到QQ的数据有误" code:ASQQShareErrorShareDataFormatError userInfo:nil];
                shareFail(shareContent,error);
                return;
            }
            break;
        }
            
        default:
        {
            NSLog(@"未指定分享内容的类型");
            break;
        }
    }
}

+ (BOOL)isInstallQQApp
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqqapi://"]];
}



#pragma prive methods

+ (NSString *)CFBundleDisplayName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];

}

+ (NSString *)base64Encode:(NSString*)input
{
    return [[input dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}

+ (NSString *)urlEncode:(NSString *)input
{
    return [input stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
}

+ (void)setGeneralPasteboard:(NSString *)key
                       Value:(NSDictionary *)value
                    encoding:(AixPboardEncodingType)encoding
{
    if (value && key)
    {
        NSData *data;
        NSError *error;
        
        switch (encoding) {
            case AixPboardEncodingTypeKeyedArchiver:
            {
                data = [NSKeyedArchiver archivedDataWithRootObject:value];
                break;
            }
            case AixPboardEncodingTypePlistSerialization:
            {
                data = [NSPropertyListSerialization dataWithPropertyList:value format:NSPropertyListBinaryFormat_v1_0 options:0 error:&error];
            }
            default:
                break;
        }
        
        if (error) {
            NSLog(@"NSPropertyListSerialization error:%@",error);
        }else if (data){
            
            [[UIPasteboard generalPasteboard] setData:data forPasteboardType:key];
        }
        
    }
}

+ (BOOL)QQ__hanldeOpenURL:(NSURL *)openUrl
{
    //分享
    if ([openUrl.scheme hasPrefix:@"QQ"]) {
        
        NSDictionary *result = [self parseUrl:openUrl.query];
        if ([result[@"error"] intValue] != 0) {
            
            NSString *errString = [self base64Decode:result[@"error_description"]];
            NSError *error = [NSError errorWithDomain:errString
                                                 code:[result[@"error"] intValue]
                                             userInfo:nil];
            
            if ([AixShare sharedInstance].shareFailCallBack) {
                [AixShare sharedInstance].shareFailCallBack(nil,error);
            }
        }else{
            
            if ([AixShare sharedInstance].shareSuccessCallBack) {
                [AixShare sharedInstance].shareSuccessCallBack([AixShare sharedInstance].shareContent);
            }
        }
        
    }else if ([openUrl.scheme hasPrefix:@"tencent"]){
        //oauth 登录
        
    }
    return NO;
}

+ (NSDictionary *)parseUrl:(NSString *)urlStr
{
    NSArray *components = [urlStr componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (NSString *keyAndValue in components) {
        
        NSRange range = [keyAndValue rangeOfString:@"="];
        if (range.location)
        {
            NSString *key = [keyAndValue substringToIndex:range.location];
            NSString *value = [keyAndValue substringFromIndex:(range.location + 1)];
            
            dic[key] = value;
        }
    }
    return dic;
}

+ (NSString *)base64Decode:(NSString *)base64
{
    NSString *string = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding];
    
    return string;
}
@end

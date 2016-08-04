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
        
        return;
    }
    
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
            NSData *imgData = UIImageJPEGRepresentation(shareContent.image, 1);
            NSDictionary *value = @{@"previewimagedata":imgData};
            
            [self setGeneralPasteboard:@"com.tencent.mqq.api.apiLargeData" Value:value encoding:AixPboardEncodingTypeKeyedArchiver];
            
            NSString *msgType = @"news";
            NSString *title = [self urlEncode:[self base64Encode:shareContent.title]];
            NSString *url = [self urlEncode:[self base64Encode:shareContent.link]];
            NSString *description = [self urlEncode:[self base64Encode:shareContent.subTitle]];
            
            [openUrl appendFormat:@"%@&title=%@&url=%@&description=%@&objectlocation=pasteboard",msgType,title,url,description];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
            
            break;
        }
            
        default:
            break;
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


@end

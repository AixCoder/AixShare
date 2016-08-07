//
//  AixShare+Weibo.h
//  AixShare
//
//  Created by liuhongnian on 16/8/4.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "AixShare.h"

typedef NS_ENUM(NSInteger,ASWeiboShareError)
{
    ASWeiboShareErrorNotInstallApp = -20,//未安装微博APP
    ASWeiboShareErrorDataFormatError,//分享的数据格式错误
    ASWeiboShareErrorUnregisteredApp,//未注册微博APP key
    ASWeiboShareErrorGiveUpOperation,//用户放弃分享
    ASWeiboShareErrorGiveUpOAuth,//用户放弃网页授权
    ASWeiboShareErrorredirectURLError,//授权回调页面地址填写的和微博开放平台上设置的不一致
};

@interface AixShare (Weibo)

+ (void)registerWeiboWithAppID:(NSString *)appID appKey:(NSString *)appKey redirectURL:(NSString *)redirectUrl;

+ (void)weiboAuthWithRedirectUri:(NSString *)redirecturi
                         Success:(AuthSuccess)success
                            Fail:(AuthFail)fail;

//调用APP直接分享
+ (void)shareToWeibo:(AixShareContent *)shareContent Success:(shareSuccessHandler)success Fail:(shareFailHandler)fail;

//请求API做分享
+ (void)shareToWeibo:(AixShareContent *)shareContent
     withAccessToken:(NSString *)token
             Success:(shareSuccessHandler)success
                Fail:(shareFailHandler)fail;

@end

//
//  AixShare+Weibo.h
//  AixShare
//
//  Created by liuhongnian on 16/8/4.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "AixShare.h"

@interface AixShare (Weibo)

+ (void)registerWeiboWithAppID:(NSString *)appID appKey:(NSString *)appKey redirectURL:(NSString *)redirectUrl;

+ (void)weiboAuth:(NSString*)scope
      redirectUri:(NSString *)redirecturi
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

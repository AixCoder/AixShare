//
//  AixShare+Wechat.h
//  AixShare
//
//  Created by liuhongnian on 16/8/1.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "AixShare.h"

@interface AixShare (Wechat)

+ (void)registerWechatWithAppID:(NSString*)app_id;

+ (void)shareToWechatSession:(AixShareContent *)shareContent
                     Success:(shareSuccessHandler)shareSuccess
                        Fail:(shareFailHandler)failHandler;

+ (void)shareToWechatTimeLine:(AixShareContent *)shareContent
                      Success:(shareSuccessHandler)shareSuccess
                         Fail:(shareFailHandler)failHandler;

@end

//
//  AixShare+Wechat.h
//  AixShare
//
//  Created by liuhongnian on 16/8/1.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "AixShare.h"

typedef NS_ENUM(NSInteger,ASWechatError)
{
    ASWechatErrorNotInstallApp = 10,//没有安装微信APP
    ASWechatErrorDataFormatError,//分享的内容数据格式不对
    ASWechatErrorNotRegisterWechat,//未注册微信appkey
    ASWechatErrorGiveUpOperation,//放弃操作
};

@interface AixShare (Wechat)

+ (void)registerWechatWithAppID:(NSString*)app_id;

+ (void)shareToWechatSession:(AixShareContent *)shareContent
                     Success:(shareSuccessHandler)shareSuccess
                        Fail:(shareFailHandler)failHandler;

+ (void)shareToWechatTimeLine:(AixShareContent *)shareContent
                      Success:(shareSuccessHandler)shareSuccess
                         Fail:(shareFailHandler)failHandler;

@end

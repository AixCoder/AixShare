//
//  AixShare+QQ.h
//  AixShare
//
//  Created by liuhongnian on 16/8/2.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "AixShare.h"

typedef NS_ENUM(NSUInteger,AixPboardEncodingType)
{
    AixPboardEncodingTypeKeyedArchiver,
    AixPboardEncodingTypePlistSerialization,
};

@interface AixShare (QQ)

+ (void)registerQQWithAppID:(NSString *)appid;

+ (void)shareToFriend:(AixShareContent *)shareContent
              Success:(shareSuccessHandler)shareSuccess
                 Fail:(shareFailHandler)shareFail;

+ (void)shareToQQZone:(AixShareContent *)shareContent Success:(shareSuccessHandler)shareSuccess Fail:(shareFailHandler)shareFail;

@end

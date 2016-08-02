//
//  AixShare.h
//  AixShare
//
//  Created by liuhongnian on 16/8/1.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,AixMediaType)
{
    AixMediaTypeURL = 1,
    AixMediaTypeImage = 2,
    AixMediaTypeVideo = 3,
    AixMediaTypeAudio = 4,
    AixMediaTypeFile = 5,
    
};

@interface AixShareContent : NSObject

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *subTitle;
@property (nonatomic,assign)AixMediaType mediaType;

@end

typedef void(^shareSuccessHandler)(AixShareContent *shareContent);
typedef void(^shareFailHandler)(AixShareContent *shareContent ,NSError *shareError);

@interface AixShare : NSObject

@property (nonatomic,readonly)NSMutableDictionary *appsKeys;//存放各大分享平台的APP key

@property (nonatomic,copy  ) shareSuccessHandler shareSuccessCallBack;
@property (nonatomic,copy  ) shareFailHandler    shareFailCallBack;
@property (nonatomic,strong) AixShareContent     *shareContent;

+(AixShare*)sharedInstance;

- (void)setKey:(NSDictionary *)key forPlatform:(NSString *)platform;

+ (BOOL)handleOpenURL:(NSURL *)openUrl;

@end

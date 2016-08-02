//
//  AixShare.m
//  AixShare
//
//  Created by liuhongnian on 16/8/1.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "AixShare.h"

#import <UIKit/UIKit.h>

@interface AixShare ()

@property (nonatomic,strong)NSMutableDictionary *appsKeys;

@end

@implementation AixShare

+ (AixShare *)sharedInstance
{
    static dispatch_once_t once;
    static AixShare * singleton = nil;
    
    dispatch_once(&once, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _appsKeys = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setKey:(NSDictionary *)key forPlatform:(NSString *)platform
{
    _appsKeys[platform] = key;
}

+ (BOOL)handleOpenURL:(NSURL *)openUrl
{
    for (NSString *platform in [AixShare sharedInstance].appsKeys.allKeys)
    {
        SEL sel = NSSelectorFromString([platform stringByAppendingString:@"__hanldeOpenURL:"]);
        if ([self respondsToSelector:sel]) {
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:sel]];
            [invocation setSelector:sel];
            [invocation setTarget:self];
            [invocation setArgument:&openUrl atIndex:2];
            [invocation invoke];
            
            BOOL returnValue;
            [invocation getReturnValue:&returnValue];
            if (returnValue) {
                return YES;
            }
        }
        
    }
    return NO;
}

@end

@implementation AixShareContent



@end

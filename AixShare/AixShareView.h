//
//  AixShareView.h
//  AixShare
//
//  Created by liuhongnian on 16/8/9.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AixShareViewDelegate <NSObject>

- (void)preWechatSession;
- (void)preWechatTimeLine;
- (void)preQQ;
- (void)preQQZone;
- (void)preWeibo;

@end


@interface AixShareView : UIView

@property (nonatomic,weak)id<AixShareViewDelegate> delegate;

@end

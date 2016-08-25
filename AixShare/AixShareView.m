//
//  AixShareView.m
//  AixShare
//
//  Created by liuhongnian on 16/8/9.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "AixShareView.h"

@implementation AixShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)wechatSessionIconTaped:(id)sender {
    
    [self.delegate preWechatSession];
}

- (IBAction)wechatTimeLineTaped:(id)sender {
    [self.delegate preWechatTimeLine];
}

- (IBAction)QZoneTaped:(id)sender {
    [self.delegate preQQZone];
}

- (IBAction)QQTaped:(id)sender {
    
    [self.delegate preQQ];
}

- (IBAction)WeiboTaped:(id)sender {
    [self.delegate preWeibo];
}

@end

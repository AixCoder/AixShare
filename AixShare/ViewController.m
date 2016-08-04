//
//  ViewController.m
//  AixShare
//
//  Created by liuhongnian on 16/8/1.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "ViewController.h"
#import "AixShare+Wechat.h"
#import "AixShare+QQ.h"
#import "AixShare+Weibo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareTextToWechat:(id)sender {
    
    AixShareContent *shareContent = [[AixShareContent alloc] init];
    shareContent.link = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    shareContent.image = [UIImage imageNamed:@"shareImage"];
    shareContent.mediaType = AixMediaTypeNews;
    shareContent.subTitle = @"到我的";
    shareContent.title = @"分享到好友";
    
    //分享到微信好友
    [AixShare shareToWechatSession:shareContent Success:^(AixShareContent *shareContent) {
        
    } Fail:^(AixShareContent *shareContent, NSError *shareError) {
        
        NSLog(@"fenxiang fail");
    }];
    
}
- (IBAction)shareLinkToTimeLine:(id)sender {
    
    AixShareContent *shareContent = [[AixShareContent alloc] init];
    shareContent.link = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    shareContent.image = [UIImage imageNamed:@"shareImage"];
    shareContent.mediaType = AixMediaTypeNews;
    shareContent.subTitle = @"产品";
    shareContent.title = @"分享到朋友圈";

    [AixShare shareToWechatTimeLine:shareContent Success:^(AixShareContent *shareContent) {
        
    } Fail:^(AixShareContent *shareContent, NSError *shareError) {
        
    }];
}

- (IBAction)toQQFriend:(id)sender {
    
    AixShareContent *content = [[AixShareContent alloc] init];
    content.image = [UIImage imageNamed:@"shareImage"];
    content.title = @"title1";
    content.subTitle = @"des";
    content.link = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    content.mediaType = AixMediaTypeNews;
    
//    [AixShare shareToFriend:content Success:^(AixShareContent *shareContent) {
//        
//    } Fail:^(AixShareContent *shareContent, NSError *shareError) {
//        
//    }];
    
    [AixShare shareToQQZone:content Success:^(AixShareContent *shareContent) {
        
    } Fail:^(AixShareContent *shareContent, NSError *shareError) {
        
    }];
}

- (IBAction)oauthWeibo:(id)sender {
    
    [AixShare weiboAuth:nil
            redirectUri:@"http://www.limon.top"
                Success:^(NSDictionary *authInfo) {
        
    } Fail:^(NSDictionary *message, NSError *error) {
        
        
    }];
}

- (IBAction)shareToWB:(id)sender
{
    AixShareContent *content = [[AixShareContent alloc] init];
    content.link = @"http://www.cz001.com.cn";
    content.title = @"常州网";
    content.image = [UIImage imageNamed:@"shareImage"];
    
//    [AixShare shareToWeibo:content withAccessToken:@"2.00xuzZwCkXwvvBb6c28d4edf3fypgC" Success:^(AixShareContent *shareContent) {
//        
//    } Fail:^(AixShareContent *shareContent, NSError *shareError) {
//        
//    }];
    
    [AixShare shareToWeibo:content Success:^(AixShareContent *shareContent) {
        
    } Fail:^(AixShareContent *shareContent, NSError *shareError) {
        
    }];
}

@end

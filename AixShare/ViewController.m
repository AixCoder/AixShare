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

#import "AixShareService.h"

@interface ViewController ()

@property (nonatomic,strong)AixShareService *shareService;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *image = [UIImage imageNamed:@"shareImage"];
    
    _shareService = [[AixShareService alloc] init];
    [_shareService presentShareSheetView:self.view
                              shareText:@"阿里巴巴是个快乐的青年"
                              urlString:@"https://www.taobao.com" image:image];
    
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
        
        NSLog(@"分享到微信好友成功");
        
    } Fail:^(AixShareContent *shareContent, NSError *shareError) {

        NSLog(@"分享到微信失败,%@",[shareError domain]);
    }];
    
}

- (IBAction)shareToQQZone:(id)sender {
    
    AixShareContent *content = [AixShareContent new];
    content.link = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    content.title = @"分享一次到扣扣空间 ";
    content.subTitle = @"测试自己打造的分享小框架";
    content.image = [UIImage imageNamed:@"shareImage"];

    content.mediaType = AixMediaTypeNews;
    
    [AixShare shareToQQZone:content Success:^(AixShareContent *shareContent) {
        
        NSLog(@"分享到扣扣空间成功");
    } Fail:^(AixShareContent *shareContent, NSError *shareError) {
        
        NSLog(@"分享到扣扣空间失败 %@",shareError);
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
        
        NSLog(@"朋友圈分享成功");
    } Fail:^(AixShareContent *shareContent, NSError *shareError) {
        
        NSLog(@"朋友圈分享失败");
        
    }];
}

- (IBAction)toQQFriend:(id)sender {
    
    AixShareContent *content = [[AixShareContent alloc] init];
    content.image = [UIImage imageNamed:@"shareImage"];
    content.title = @"title1";
    content.subTitle = @"des";
    content.link = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    content.mediaType = AixMediaTypeNews;
    
    [AixShare shareToFriend:content Success:^(AixShareContent *shareContent) {
        
        NSLog(@"分享到QQ好友成功");
    } Fail:^(AixShareContent *shareContent, NSError *shareError) {
        
        NSLog(@"分享到QQ好友失败,%@",shareError.domain);
    }];
    
}

- (IBAction)oauthWeibo:(id)sender {
    
    [AixShare weiboAuthWithRedirectUri:@"http://sns.whalecloud.com/sina2/callback" Success:^(NSDictionary *authInfo) {
        
        
    } Fail:^(NSDictionary *message, NSError *error) {
        
        NSLog(@"授权失败%@",error);

    }];
}

- (IBAction)shareToWB:(id)sender
{
    AixShareContent *content = [[AixShareContent alloc] init];
    content.link = @"http://www.cz001.com.cn";
    content.title = @"常州网官网";
//    content.image = [UIImage imageNamed:@"shareImage"];
        
//    [AixShare shareToWeibo:content Success:^(AixShareContent *shareContent) {
//        
//    } Fail:^(AixShareContent *shareContent, NSError *shareError) {
//        
//    }];
}

- (IBAction)shareTextToWeibo:(id)sender {
    
    AixShareContent *shareContent = [[AixShareContent alloc] init];
    shareContent.title = @"纯文字分享";
    
    [AixShare shareToWeibo:shareContent Success:^(AixShareContent *shareContent) {
        
        NSLog(@"分享到微博成功");
    } Fail:^(AixShareContent *shareContent, NSError *shareError) {
        
        NSLog(@"分享到微博失败%@",shareError);
    }];
}

- (IBAction)shareTextAndImgToWeibo:(id)sender {
    
    AixShareContent *shareContent = [[AixShareContent alloc] init];
    shareContent.title = @"分享一个看一看";
    shareContent.image = [UIImage imageNamed:@"shareImage"];
    
    [AixShare shareToWeibo:shareContent Success:^(AixShareContent *shareContent) {
        
        NSLog(@"分享到微博成功");
    } Fail:^(AixShareContent *shareContent, NSError *shareError) {
        
        NSLog(@"分享到微博失败%@",shareError);
    }];

}


@end

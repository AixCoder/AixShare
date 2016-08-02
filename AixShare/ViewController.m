//
//  ViewController.m
//  AixShare
//
//  Created by liuhongnian on 16/8/1.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "ViewController.h"
#import "AixShare+Wechat.h"
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
    shareContent.title = @"分享一次";
    
    [AixShare shareToWechatSession:shareContent Success:^(AixShareContent *shareContent) {
        
    } Fail:^(AixShareContent *shareContent, NSError *shareError) {
        
        NSLog(@"fenxiang fail");
    }];
}
@end

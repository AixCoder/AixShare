//
//  AixShareSheet.m
//  AixShare
//
//  Created by liuhongnian on 16/8/9.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "AixShareService.h"

#import "AixShareView.h"
#import "AixShareSdkHeaders.h"
@interface AixShareService ()<AixShareViewDelegate>

@property (nonatomic,strong) AixShareView *shareView;
@property (nonatomic,strong) UIView       *maskView;
@property (nonatomic,strong) UITapGestureRecognizer *tapGes;

@property (nonatomic,copy  ) NSString     *shareText;
@property (nonatomic,copy  ) NSString     *shareUrl;
@property (nonatomic,strong) UIImage      *shareImage;

@end

@implementation AixShareService

+ (void)presentShareSheetOnView:(UIView *)view
                      shareText:(NSString *)text
                      urlString:(NSString *)urlStr
                          image:(UIImage *)image
{
    [[[self alloc] init] presentShareSheetView:view shareText:text urlString:urlStr image:image];
}

- (void)presentShareSheetView:(UIView *)baseView
                    shareText:(NSString *)text
                    urlString:(NSString *)urlString
                        image:(UIImage *)image
{
    _shareText  = text;
    _shareUrl   = urlString;
    _shareImage = image;
    
    
    //背景 mask view
    _maskView = [[UIView alloc]init];
    _maskView.frame = [UIScreen mainScreen].bounds;
    _maskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
    [baseView addSubview:_maskView];
    
    
    //分享sheet view
    _shareView = [[UINib nibWithNibName:@"AixShareView" bundle:nil]instantiateWithOwner:self options:nil][0];
    _shareView.delegate = self;
    CGFloat x      = 0;
    CGFloat y      = _maskView.frame.size.height;
    CGFloat width  = _maskView.frame.size.width;
    CGFloat height = 160;
    _shareView.frame = CGRectMake(x, y, width, height);
    [_maskView addSubview:_shareView];
    
    
    
    //animate
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGFloat y = _maskView.frame.size.height - 160;
        CGFloat x = 0;
        _shareView.frame = CGRectMake(x, y,
                                      _shareView.frame.size.width,
                                      _shareView.frame.size.height);
        _maskView.alpha = 1;
        
    } completion:NULL];
    
    
}

- (void)clickOnMaskView
{
    [self closeShareView];
}

- (void)closeShareView
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _shareView.frame = CGRectMake(0,
                                      _maskView.frame.size.height,
                                      _shareView.frame.size.width,
                                      _shareView.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            [_shareView removeFromSuperview];
            [_maskView removeFromSuperview];
            
            _shareView = nil;
            _maskView = nil;

        }
        
    }];
    
}

#pragma mark AixShareViewDelegate

- (void)preWeibo
{
    if ([AixShare isInstallWeiboApp]) {
        //APP分享
    }else if ([AixShare isOauthedWeiBo]){
        
        //API直接分享
        AixShareContent *content = [[AixShareContent alloc] init];
        content.image = _shareImage;
        content.title = _shareText;
        content.link = _shareUrl;
        
        [AixShare requestApiShareToWeibo:content Success:^(AixShareContent *shareContent) {
            
        } Fail:^(AixShareContent *shareContent, NSError *shareError) {
            
        }];
        
    }else{
        
        //网页授权一次
        [AixShare weiboAuthWithRedirectUri:@"http://sns.whalecloud.com/sina2/callback" Success:^(NSDictionary *authInfo) {
            
            
        } Fail:^(NSDictionary *message, NSError *error) {
            
        }];
    }
}

- (void)preWechatTimeLine
{
    
}

- (void)preWechatSession
{
    
}

- (void)preQQ
{
    
}

- (void)preQQZone
{
    
}

@end

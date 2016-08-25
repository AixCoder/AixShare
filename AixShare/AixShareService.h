//
//  AixShareSheet.h
//  AixShare
//
//  Created by liuhongnian on 16/8/9.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@class UIView;
@interface AixShareService : NSObject

+ (void)presentShareSheetOnView:(UIView*)view
                      shareText:(NSString*)text
                      urlString:(NSString*)urlStr
                          image:(UIImage*)image;

- (void)presentShareSheetView:(UIView *)baseView
                    shareText:(NSString *)text
                    urlString:(NSString *)urlString
                        image:(UIImage *)image;

@end

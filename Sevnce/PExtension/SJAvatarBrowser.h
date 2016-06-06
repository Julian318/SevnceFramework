//
//  NSObject+SJAvatarBrowser.h
//  FeiLe
//  图片放大类
//  Created by crly on 15/4/15.
//  Copyright (c) 2015年 sevnce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SJAvatarBrowser : NSObject
/**
 *  @brief  浏览头像
 *
 *  @param  oldImageView    头像所在的imageView
 */
+(void)showImage:(UIImageView *)avatarImageView;

@end
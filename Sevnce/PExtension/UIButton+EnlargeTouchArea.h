//
//  UIButton+EnlargeTouchArea.h
//  SingaporeBusiness
//
//  Created by 郭炜 on 16/5/6.
//  Copyright © 2016年 Julian. All rights reserved.
//
/**
 *  扩大button的点击范围 而不会放大button的frame
 */
#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end

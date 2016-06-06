//
//  UIView+Extension.h
//  轻松调频
//
//  Created by imac on 13-6-20.
//  Copyright (c) 2013年 criOnline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property NSInteger Top;
@property NSInteger Right;
@property NSInteger Bottom;
@property NSInteger Left;
@property NSInteger Width;
@property NSInteger Height;
@property NSString* Format;
@property Boolean isDisplayedInScreen;
-(void)removeAll;
-(void)centerH;
-(void)centerV;
-(void)fillParentH;
-(void)alignRight;
-(void)setRound;
-(void)setBorderWidth:(CGFloat)width color:(UIColor*)color;
@end

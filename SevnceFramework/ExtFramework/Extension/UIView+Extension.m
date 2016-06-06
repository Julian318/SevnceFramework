//
//  UIView+Extension.m
//  轻松调频
//
//  Created by imac on 13-6-20.
//  Copyright (c) 2013年 criOnline. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
-(NSInteger)Bottom{
    return self.frame.origin.y+self.frame.size.height;
}
-(void)setBottom:(NSInteger)value{
    NSInteger offset=value-self.Bottom;
    self.Height+=offset;
}
-(NSInteger)Right{
    return self.frame.origin.x+self.frame.size.width;
}
-(void)setRight:(NSInteger)value{
    NSInteger offset=value-self.Right;
    self.Width+=offset;
}
-(NSInteger)Top{
    return self.frame.origin.y;
}
-(void)setTop:(NSInteger)value{
    self.frame=CGRectMake(self.frame.origin.x, value, self.frame.size.width, self.frame.size.height);
}
-(NSInteger)Left{
    return self.frame.origin.x;
}
-(void)setLeft:(NSInteger)value{
    self.frame=CGRectMake(value, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
-(NSInteger)Width{
    return self.bounds.size.width;
}
-(void)setWidth:(NSInteger)Width{
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y,Width,  self.bounds.size.height);
}
-(NSInteger)Height{
    return self.bounds.size.height;
}
-(void)setHeight:(NSInteger)Height{
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, Height);
}
-(NSString*)Format{
    return self.restorationIdentifier;
}
-(void)setFormat:(NSString *)Format{
    self.restorationIdentifier=Format;
}
-(void)removeAll{
    for(UIView* v in self.subviews){
        [v removeFromSuperview];
    }
}
-(void)centerH{
    self.center=CGPointMake(self.superview.frame.size.width*0.5, self.center.y);
}
-(void)centerV{
    self.center=CGPointMake(self.center.y,self.superview.frame.size.height*0.5);
}
-(void)fillParentH{
    self.frame=CGRectMake(0,0,self.superview.frame.size.width, self.frame.size.height);
}
-(void)alignRight{
    self.frame=CGRectMake(self.superview.frame.size.width-self.frame.size.width,self.frame.origin.y,self.frame.size.width, self.frame.size.height);
}
- (Boolean)isDisplayedInScreen
{
    if (self == nil) {
        return NO;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
//    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
//        return NO;
//    }
    
    // 若view 隐藏
    if (self.hidden) {
        return NO;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return NO;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  NO;
    }
    
    // 获取 该view与window 交叉的 Rect
//    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
//    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
//        return NO;
//    }
    
    return YES;
}
-(void)setIsDisplayedInScreen:(Boolean)isDisplayedInScreen{
    
}
-(void)setRound{
    CGFloat max=MAX(self.Width, self.Height);
    if(self.Width!=self.Height){
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, max, max);
    }
    self.layer.cornerRadius=max*0.5;
    self.layer.masksToBounds = YES;
}
-(void)setBorderWidth:(CGFloat)width color:(UIColor*)color{
    if(width)self.layer.borderWidth = width;
    if(color)self.layer.borderColor=color.CGColor;
}
@end

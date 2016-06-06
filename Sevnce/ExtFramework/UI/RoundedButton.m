//
//  RoundedButton.m
//  七彩重师
//
//  Created by imac on 14-10-21.
//  Copyright (c) 2014年 xuner. All rights reserved.
//

#import "RoundedButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIRectCorner corners=UIRectCornerAllCorners;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                       byRoundingCorners:corners
                                                             cornerRadii:CGSizeMake(5.0, 5.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame         = self.bounds;
        maskLayer.path          = maskPath.CGPath;
        self.layer.mask         = maskLayer;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

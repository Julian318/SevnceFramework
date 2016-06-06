//
//  RoundedLabel.m
//  易聚
//
//  Created by imac on 15/4/16.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import "RoundedLabel.h"

@implementation RoundedLabel
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
-(void)setBorderColor:(UIColor*)color{
    self.layer.borderColor=[color CGColor];
}
@end

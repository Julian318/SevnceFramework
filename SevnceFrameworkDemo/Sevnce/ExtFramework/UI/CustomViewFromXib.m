//
//  CustomViewFromXib.m
//  oa
//
//  Created by hongyang on 15/10/31.
//  Copyright (c) 2015年 sevnce. All rights reserved.
//

#import "CustomViewFromXib.h"

@implementation CustomViewFromXib
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        UIView *containerView = [[[UINib nibWithNibName:[NSString stringWithFormat:@"%@",self.class] bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *containerView = [[[UINib nibWithNibName:[NSString stringWithFormat:@"%@",self.class] bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    return self;
}


@end

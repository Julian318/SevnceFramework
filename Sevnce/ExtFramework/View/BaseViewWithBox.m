//
//  BaseViewWithBox.m
//  七彩重师
//
//  Created by imac on 14-11-19.
//  Copyright (c) 2014年 xuner. All rights reserved.
//

#import "BaseViewWithBox.h"

@implementation BaseViewWithBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _padding=UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
-(void)setPadding:(UIEdgeInsets)padding{
    _padding=padding;
}
-(void)layoutSubviews{
    for (UIView* view in self.subviews) {
        if(view.frame.origin.x<_padding.left||view.frame.origin.y<_padding.top){
            view.frame=CGRectMake(MAX(view.frame.origin.x+_padding.left, view.frame.origin.x), MAX(view.frame.origin.y+_padding.top, view.frame.origin.y), view.frame.size.width, view.frame.size.height);
        }
        if(view.frame.origin.x+view.frame.size.width>self.frame.size.width-_padding.right){
            view.frame=CGRectMake(view.frame.origin.x-_padding.right,view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        }
    }
}
@end

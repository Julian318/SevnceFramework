//
//  VerticalLayout.m
//  七彩重师
//
//  Created by imac on 14-11-16.
//  Copyright (c) 2014年 xuner. All rights reserved.
//

#import "VerticalLayout.h"

@implementation VerticalLayout

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _padding=UIEdgeInsetsMake(0, 0, 0, 0);
        self.userInteractionEnabled=YES;
    }
    return self;
}
-(UIView*)lastChildBefrorCount:(int)count{
    if(self.subviews.count==count)return nil;
    return self.subviews[self.subviews.count-count-1];
}
-(void)didAddSubview:(UIView *)subview{
    UIView* lastChild=[self lastChildBefrorCount:1];
    if(lastChild){
        subview.frame=CGRectMake(subview.frame.origin.x+_padding.left, lastChild.Bottom, subview.frame.size.width, subview.frame.size.height);
    }else{
        subview.frame=CGRectMake(subview.frame.origin.x+_padding.left, subview.frame.origin.y+_padding.top, subview.frame.size.width, subview.frame.size.height);
    }
    [subview setTag:self.subviews.count-1];
    [subview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionInitial context:nil];
}
-(void)willRemoveSubview:(UIView *)subview{
//    UIView* head=[subview valueForKey:@"linkhheadview"];
//    UIView* tail=[subview valueForKey:@"linkhtailview"];
//    [head setValue:tail forKey:@"linkhtailview"];
//    [tail setValue:head forKey:@"linkheadview"];
    [subview removeObserver:self forKeyPath:@"frame"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    UIView* view=object;
    if(view==[self lastChildBefrorCount:0]){
       self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, view.Bottom+_padding.bottom);
    }else{
        UIView* tail=self.subviews[view.tag+1];
        tail.frame=CGRectMake(tail.frame.origin.x, view.Bottom, tail.frame.size.width, tail.frame.size.height);
    }
}
-(void)dealloc{
//    for (UIView* subview in self.subviews) {
//        [subview removeObserver:self forKeyPath:@"frame"];
//    }
}
@end

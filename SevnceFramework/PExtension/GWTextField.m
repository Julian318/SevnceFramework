//
//  GWTextField.m
//  oncenote
//
//  Created by guowei on 16/1/6.
//  Copyright © 2016年 sevnce. All rights reserved.
//

/**
 *   重写UITextField，让光标和提示文本和输入文本靠右
 *
 */
#import "GWTextField.h"

@implementation GWTextField

//文本靠右十个点
- (CGRect)textRectForBounds:(CGRect)bounds {
    
    CGRect rect = [super textRectForBounds:bounds];
    
    return CGRectMake(rect.origin.x + 10, rect.origin.y, rect.size.width, rect.size.height);
}

//文本内容靠右十个点
- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    CGRect rect = [super editingRectForBounds:bounds];
    
    return CGRectMake(rect.origin.x + 15, rect.origin.y, rect.size.width, rect.size.height);
}

//清楚按钮靠左五个点
- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    
    CGRect rect = [super clearButtonRectForBounds:bounds];
    
    return CGRectOffset(rect, 0, -5);
}

//提示文本靠右十个点
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    
    CGRect rect = [super placeholderRectForBounds:bounds];
    
    return CGRectMake(rect.origin.x + 10, rect.origin.y, rect.size.width, rect.size.height);
}

@end

//
//  RoundedTextField.m
//  七彩重师
//
//  Created by imac on 14-11-14.
//  Copyright (c) 2014年 xuner. All rights reserved.
//

#import "RoundedTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedTextField
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderStyle=UITextBorderStyleNone;
        self.layer.cornerRadius=5.0f;
        self.layer.masksToBounds=YES;
        self.layer.borderWidth= 1.0f;
    }
    return self;
}
-(void)setBorderColor:(UIColor*)color{
    self.layer.borderColor=[color CGColor];
}

@end

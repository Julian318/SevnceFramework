//
//  RoundedTextView.m
//  七彩重师
//
//  Created by imac on 14-11-14.
//  Copyright (c) 2014年 xuner. All rights reserved.
//

#import "RoundedTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedTextView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius=5.0f;
        self.layer.masksToBounds=YES;
        self.layer.borderWidth= 1.0f;
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];    }
    return self;
}
- (void)textChanged:(NSNotification *)notification

{
    if([[self placeholder] length] == 0)return;
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
       [[self viewWithTag:999] setAlpha:0];
    }
    
}
- (void)setText:(NSString *)text {
    
    [super setText:text];
    
    [self textChanged:nil];
    
}
- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if (self.placeHolderLabel == nil )
        {
            self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            self.placeHolderLabel.lineBreakMode = UILineBreakModeWordWrap;
            self.placeHolderLabel.numberOfLines = 0;
            self.placeHolderLabel.font = self.font;
            self.placeHolderLabel.backgroundColor = [UIColor clearColor];
            self.placeHolderLabel.textColor = self.placeholderColor;
            self.placeHolderLabel.alpha = 0;
            self.placeHolderLabel.tag = 999;
            [self addSubview:self.placeHolderLabel];
        }
        self.placeHolderLabel.text = self.placeholder;
        [self.placeHolderLabel sizeToFit];
        [self sendSubviewToBack:self.placeHolderLabel];
    }
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
}
-(void)setBorderColor:(UIColor*)color{
    self.layer.borderColor=[color CGColor];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

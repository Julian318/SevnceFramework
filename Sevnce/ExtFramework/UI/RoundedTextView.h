//
//  RoundedTextView.h
//  七彩重师
//
//  Created by imac on 14-11-14.
//  Copyright (c) 2014年 xuner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedTextView : UITextView
@property(nonatomic, retain) UILabel *placeHolderLabel;
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;
-(void)setBorderColor:(UIColor*)color;

@end

//
//  BaseViewWithBox.h
//  七彩重师
//
//  Created by imac on 14-11-19.
//  Copyright (c) 2014年 xuner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewWithBox : UIImageView{
    UIEdgeInsets _padding;
}
-(void)setPadding:(UIEdgeInsets)padding;
@end

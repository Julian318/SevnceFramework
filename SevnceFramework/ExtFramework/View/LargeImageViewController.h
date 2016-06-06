//
//  LargeImageViewController.h
//  易聚
//
//  Created by imac on 15/4/25.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargeImageViewController : UIViewController
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) UIImage* image;
-(id)initWithUrl:(NSString*)url;
-(id)initWithFrame:(CGRect)frame;

@end

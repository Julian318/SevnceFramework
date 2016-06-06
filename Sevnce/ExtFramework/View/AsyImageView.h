//
//  AsyImageView.h
//  聚会掌中宝
//
//  Created by imac on 15/4/10.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AsyImageProgressView;
@interface AsyImageView : UIViewController
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) UIImage* defaultImage;
@property (nonatomic, retain) id loadComplete;
@property (nonatomic, retain) AsyImageProgressView* progressView;
///点击放大
@property (nonatomic) BOOL forbitEnlarge;
///显示加载进度
@property (nonatomic) BOOL forbitShowProgress;
-(id)initWithUrl:(NSString*)url;
-(id)initWithFrame:(CGRect)frame;
@end
@interface SSImageView :UIView<UIScrollViewDelegate>
- (void) viewWithImage:(UIImageView *) imageView;
@end

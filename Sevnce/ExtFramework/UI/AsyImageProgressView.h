//
//  AsyImageProgressView.h
//  易聚
//
//  Created by imac on 15/5/14.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SDColorMaker(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define SDProgressViewItemMargin 4

#define SDProgressViewFontScale (MIN(self.frame.size.width, self.frame.size.height) / 100.0)

// 背景颜色
#define SDProgressViewBackgroundColor SDColorMaker(240, 240, 240, 0.9)
typedef enum
{
    AsyImageProgressTypeBall     = 0,
    AsyImageProgressTypeLoop,
    AsyImageProgressTypePieLoop,
    AsyImageProgressTypePieProgress,
    AsyImageProgressTypeTransparentPie,
    AsyImageProgressTypeLoading
} AsyImageProgressType;

@interface AsyImageProgressView : UIView
- (void)refreshProgress:(NSProgress *)progress;
- (void)setCenterProgressText:(NSString *)text;
-(instancetype)initWithType:(AsyImageProgressType)type;
@end


//
//  BaseViewWithData.h
//  易聚
//
//  Created by imac on 15/4/29.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDataModel.h"

@interface BaseViewWithData : UIView
@property(nonatomic, retain) BaseDataModel *Data;
-(void)handleData:(BaseDataModel*)data;
@end

//
//  AutoBindCollectionCell.h
//  dazushike
//
//  Created by yuzhengzhou on 15/12/7.
//  Copyright © 2015年 sevnce. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "BaseDataModel.h"
#import "StyledTableViewCell.h"
#import "UIView+Extension.h"

@interface AutoBindCollectionCell : UICollectionViewCell
@property (retain, nonatomic) BaseDataModel *Data;
-(void)handleData:(BaseDataModel*)data;
@end

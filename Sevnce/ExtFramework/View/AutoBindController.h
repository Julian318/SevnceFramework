//
//  AutoBindController.h
//  ZonJo
//
//  Created by crly on 16/3/8.
//  Copyright © 2016年 sevnce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseDataModel;
@interface AutoBindController : UIViewController
@property (retain, nonatomic) BaseDataModel *Data;
@property (strong, nonatomic) NSString *saveAction;
@property (strong, nonatomic) NSString *deleteAction;
@property (strong, nonatomic) UIViewController *selfcontol;
@property (strong, nonatomic) NSMutableDictionary *param;//传参数
@property BOOL hasFile;

-(void)doSave;
@end

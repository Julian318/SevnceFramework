//
//  MyTextField.h
//  chongqingzhiye
//
//  Created by crly on 15/10/23.
//  Copyright © 2015年 sevnce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYKeyboardUtil.h"

@interface MyTextField : UITextField<UITextFieldDelegate>

///为了把检测之后的结果显示到view上 需要传入self && 为了弹起视图，需要传入一个Controller
@property (strong, nonatomic) UIViewController *mview;

///输入小数点位数,默认为2位 传3为3位
@property NSInteger numlimit;

///检测输入格式,默认为不检测,传YES为开启检测
@property BOOL isTestFormat;

///传toast位置，默认center
@property (strong, nonatomic) NSString *postion;

///第三方键盘弹出弹起视图
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;

@end

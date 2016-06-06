//
//  HcCustomKeyboard.h
//  Custom
//
//  Created by 黄诚 on 14/12/18.
//  Copyright (c) 2014年 huangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HcCustomKeyboardDelegate <NSObject>

@required
-(void)talkBtnClick:(UITextView *)textViewGet;

@end

@interface HcCustomKeyboard : NSObject<UITextViewDelegate>

@property (nonatomic,assign) id<HcCustomKeyboardDelegate>mDelegate;
@property (nonatomic,strong)UIView *mBackView;
@property (nonatomic,strong)UIView *mTopHideView;
@property (nonatomic,strong)UITextView * mTextView;
@property (nonatomic,strong)UIView *mHiddeView;
@property (nonatomic,strong)UIViewController *mViewController;
@property (nonatomic,strong)UIView *mSecondaryBackView;
@property (nonatomic,strong)UIButton *mTalkBtn;
@property (nonatomic) BOOL isTop;//用来判断评论按钮的位置

+(HcCustomKeyboard *)customKeyboard;

-(void)textViewShowView:(UIViewController *)viewController customKeyboardDelegate:(id)delegate;



@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

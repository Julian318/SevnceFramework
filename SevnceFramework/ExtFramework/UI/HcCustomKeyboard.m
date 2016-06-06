//
//  HcCustomKeyboard.m
//  Custom
//
//  Created by 黄诚 on 14/12/18.
//  Copyright (c) 2014年 huangcheng. All rights reserved.
//

#import "HcCustomKeyboard.h"
#import <UIKit/UIKit.h>

//屏幕宽度
#define WIDTH_SCREEN [UIScreen mainScreen].applicationFrame.size.width
//屏幕高度
#define HEIGHT_SCREEN [UIScreen mainScreen].applicationFrame.size.height


@implementation HcCustomKeyboard
@synthesize mDelegate;

static HcCustomKeyboard *customKeyboard = nil;

+(HcCustomKeyboard *)customKeyboard
{
    @synchronized(self)
    {
        if (customKeyboard == nil)
        {
            customKeyboard = [[HcCustomKeyboard alloc] init];
        }
        return customKeyboard;
    }
}
+(id)allocWithZone:(struct _NSZone *)zone //确保使用者alloc时 返回的对象也是实例本身
{
    @synchronized(self)
    {
        if (customKeyboard == nil)
        {
            customKeyboard = [super allocWithZone:zone];
        }
        return customKeyboard;
    }
}
+(id)copyWithZone:(struct _NSZone *)zone //确保使用者copy时 返回的对象也是实例本身
{
    return customKeyboard;
}

-(void)textViewShowView:(UIViewController *)viewController customKeyboardDelegate:(id)delegate
{
    self.mViewController =viewController;
    self.mDelegate =delegate;
    self.isTop = NO;//初始化的时候设为NO
    
    self.mBackView =[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50-64, WIDTH_SCREEN, 50)];
    NSLog(@"%p",self.mBackView);
    self.mBackView.backgroundColor =[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    [self.mViewController.view addSubview:self.mBackView];
    
    self.mSecondaryBackView =[[UIView alloc]initWithFrame:CGRectMake(10, 10, 230, 30)];
    self.mSecondaryBackView.backgroundColor =[UIColor colorWithRed:153/255.0 green:154/255.0 blue:158/255.0 alpha:1];
    [self.mBackView addSubview:self.mSecondaryBackView];
    
    self.mTextView =[[UITextView alloc]initWithFrame:CGRectMake(1, 1, 228, 28)];
    self.mTextView.backgroundColor =[UIColor whiteColor];
    self.mTextView.delegate = self;
    self.mTextView.text = @"我来说几句....";
    self.mTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;;
    [self.mSecondaryBackView addSubview:self.mTextView];
    
    UIImageView *talkImg =[[UIImageView alloc]initWithFrame:CGRectMake(250, 16, 18, 18)];
    talkImg.image =[UIImage imageNamed:@"icon_0040_Shape-36.png"];
    [self.mBackView addSubview:talkImg];
    
    self.mTalkBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.mTalkBtn setTitle:@"评论" forState:UIControlStateNormal];
    [self.mTalkBtn addTarget:self action:@selector(forTalk) forControlEvents:UIControlEventTouchUpInside];
    self.mTalkBtn.frame =CGRectMake(275, 16, 30, 18);
    [self.mTalkBtn setTintColor:[UIColor blackColor]];
    [self.mBackView addSubview:self.mTalkBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.mTextView resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.mTextView.text = nil;
    return YES;
}

-(void)forTalk //评论按钮
{
    
    if (self.isTop ==NO)
    {
        [self.mTextView becomeFirstResponder];
    }
    else
    {
        [mDelegate talkBtnClick:self.mTextView];
        
        if (self.mTextView.text.length==0)
        {
            NSLog(@"内容为空");
        }
        else
        {
            [self.mTextView resignFirstResponder];
        }
    }
    
}
-(void)hideView //点击屏幕其他地方 键盘消失
{
    NSLog(@"屏幕消失");
    [self.mTextView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification*)notification //键盘出现
{
    self.isTop =YES;
    CGRect _keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%f-%f",_keyboardRect.origin.y,_keyboardRect.size.height);
    
    if (!self.mHiddeView)
    {
        self.mHiddeView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,WIDTH_SCREEN,HEIGHT_SCREEN)];
        self.mHiddeView.backgroundColor =[UIColor blackColor];
        self.mHiddeView.alpha =0.0f;
        [self.mViewController.view addSubview:self.mHiddeView];
        
        UIButton *hideBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        hideBtn.backgroundColor =[UIColor clearColor];
        hideBtn.frame = self.mHiddeView.frame;
        [hideBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [self.mHiddeView addSubview:hideBtn];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mHiddeView.alpha =0.4f;
        self.mBackView.frame =CGRectMake(0, HEIGHT_SCREEN-_keyboardRect.size.height-30-64, WIDTH_SCREEN, 50);
        [self.mViewController.view bringSubviewToFront:self.mBackView];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)keyboardWillHide:(NSNotification*)notification //键盘下落
{    
    self.isTop =NO;
        [UIView animateWithDuration:0.3 animations:^{
        self.mBackView.frame=CGRectMake(0, HEIGHT_SCREEN-30-64, WIDTH_SCREEN, 50);
        self.mHiddeView.alpha =0.0f;
        self.mSecondaryBackView.frame =CGRectMake(10, 10, 230,30);
    } completion:^(BOOL finished) {
        [self.mHiddeView removeFromSuperview];
        self.mHiddeView =nil;
        self.mTextView.text =@"我来说两句..."; //键盘消失时，恢复TextView内容
    }];
}
- (void)textDidChanged:(NSNotification *)notif //监听文字改变 换行时要更改输入框的位置
{
    CGSize contentSize = self.mTextView.contentSize;
    
    if (contentSize.height > 140){
        return;
    }
    CGFloat minus = 3;
    CGRect selfFrame = self.mBackView.frame;
    CGFloat selfHeight = self.mTextView.superview.frame.origin.y * 2 + contentSize.height - minus + 2 * 2;
    CGFloat selfOriginY = selfFrame.origin.y - (selfHeight - selfFrame.size.height);
    selfFrame.origin.y = selfOriginY;
    selfFrame.size.height = selfHeight;
    self.mBackView.frame = selfFrame;
    self.mSecondaryBackView.frame =CGRectMake(10, 10, 230, selfHeight-20);
    NSLog(@"文字改变");
}

-(void)dealloc //移除通知
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}


@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

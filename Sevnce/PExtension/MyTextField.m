//
//  MyTextField.m
//  chongqingzhiye
//
//  Created by crly on 15/10/23.
//  Copyright © 2015年 sevnce. All rights reserved.
//

#import "MyTextField.h"
#import "UIView+Toast.h"

@implementation MyTextField
{
    BOOL isHaveDian;//判断输入格式
//    UIViewController *control;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        self.delegate=self;
        self.returnKeyType=UIReturnKeyDone;
        self.clearButtonMode=UITextFieldViewModeWhileEditing;
    }
    return self;
}

-(id)init{
    self=[super init];
    if(self){
        self.delegate=self;
        self.returnKeyType=UIReturnKeyDone;
        self.clearButtonMode=UITextFieldViewModeWhileEditing;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.delegate=self;
        self.returnKeyType=UIReturnKeyDone;
        self.clearButtonMode=UITextFieldViewModeWhileEditing;
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self configKeyBoardRespond:self.mview andTextField:textField];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideKeyBoard" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:textField,@"view", nil]];
    return YES;
}

//- (void)setMview:(UIViewController *)mview
//{
//    control = mview;
//}

- (void)configKeyBoardRespond:(UIViewController *)controller andTextField:(UITextField *)textField{
    self.keyboardUtil = [[ZYKeyboardUtil alloc] init];
    
    __weak UIViewController *weakSelf = controller;
    
    //自定义键盘弹出处理
#pragma explain - use animateWhenKeyboardAppearAutomaticAnimBlock, animateWhenKeyboardAppearBlock must be nil.
    /*
     [_keyboardUtil setAnimateWhenKeyboardAppearBlock:^(int appearPostIndex, CGRect keyboardRect, CGFloat keyboardHeight, CGFloat keyboardHeightIncrement) {
     
     NSLog(@"\n\n键盘弹出来第 %d 次了~  高度比上一次增加了%0.f  当前高度是:%0.f"  , appearPostIndex, keyboardHeightIncrement, keyboardHeight);
     
     //处理
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
     CGRect convertRect = [weakSelf.mainTextField.superview convertRect:weakSelf.mainTextField.frame toView:window];
     
     if (CGRectGetMinY(keyboardRect) - MARGIN_KEYBOARD < CGRectGetMaxY(convertRect)) {
     CGFloat signedDiff = CGRectGetMinY(keyboardRect) - CGRectGetMaxY(convertRect) - MARGIN_KEYBOARD;
     //updateOriginY
     CGFloat newOriginY = CGRectGetMinY(weakSelf.view.frame) + signedDiff;
     weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x, newOriginY, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
     }
     }];
     */
    
    
    //全自动键盘弹出处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:textField, nil];
    }];
    
    
    //自定义键盘收起处理(如不配置，则默认启动自动收起处理)
#pragma explain - if not configure this Block, automatically itself.
    /*
     [_keyboardUtil setAnimateWhenKeyboardDisappearBlock:^(CGFloat keyboardHeight) {
     NSLog(@"\n\n键盘在收起来~  上次高度为:+%f", keyboardHeight);
     
     //uodateOriginY
     CGFloat newOriginY = 0;
     weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x, newOriginY, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
     }];
     */
    
    
    //获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}

//#pragma mark - UITextField 检测输入格式
//textField.text 输入之前的值 string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!self.isTestFormat) {
        return YES;
    }
    if (!self.postion) {
        self.postion = @"center";
    }
    if (!self.numlimit) {
        self.numlimit = 2;
    }
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }else{
        isHaveDian = YES;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [self.mview.view makeToast:@"第一个数字不能为小数点！" duration:2 position:self.postion];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    [self.mview.view makeToast:@"您已经输入过小数点了！" duration:2 position:self.postion];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    
                    if (range.location - ran.location <= self.numlimit) {
                        return YES;
                    }else{
                        if (self.numlimit == 2) {
                            [self.mview.view makeToast:@"您最多输入两位小数！" duration:2 position:self.postion];
                            return NO;
                        }else{
                            [self.mview.view makeToast:@"您最多输入三位小数！" duration:2 position:self.postion];
                            return NO;
                        }
                    }
                    
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [self.mview.view makeToast:@"您输入的格式不正确！" duration:2 position:self.postion];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}


//按下Done按钮的调用方法，我们让键盘消失

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

//-(void)textFieldDidBeginEditing:(MyTextField *)textField{
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"one" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:textField,@"view", nil]];
//}
//
//-(void)textFieldDidEndEditing:(MyTextField *)textField{
//
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"two" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:textField,@"view", nil]];
//    
//}
//文本靠右十个点
- (CGRect)textRectForBounds:(CGRect)bounds {
    
    CGRect rect = [super textRectForBounds:bounds];
    
    return CGRectMake(rect.origin.x + 4, rect.origin.y, rect.size.width, rect.size.height);
}

//文本内容靠右十个点
- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    CGRect rect = [super editingRectForBounds:bounds];
    
    return CGRectMake(rect.origin.x + 4, rect.origin.y, rect.size.width, rect.size.height);
}

//清楚按钮靠左五个点
- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    
    CGRect rect = [super clearButtonRectForBounds:bounds];
    
    return CGRectOffset(rect, 0, -5);
}

//提示文本靠右十个点
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    
    CGRect rect = [super placeholderRectForBounds:bounds];
    
    return CGRectMake(rect.origin.x + 4, rect.origin.y, rect.size.width, rect.size.height);
}

@end

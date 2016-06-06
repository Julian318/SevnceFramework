//
//  AutoBindController.m
//  ZonJo
//
//  Created by crly on 16/3/8.
//  Copyright © 2016年 sevnce. All rights reserved.
//

#import "AutoBindController.h"
#import "BaseDataModel.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "BaseDataModel.h"
#import "AsyImageView.h"
#import "HttpConnection.h"
#import "UIView+Toast.h"
#import "SelectButton.h"
#import "DecimalLabel.h"
#import "Util.h"

@interface AutoBindController ()

@end

@implementation AutoBindController
static NSMutableDictionary* allProperties;

- (void)viewDidLoad
{
    self.param = [[NSMutableDictionary alloc] init];
    self.hasFile = YES;
}

-(void)hideview:(UITapGestureRecognizer*)tap{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(NSMutableArray*)properties{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideview:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    if(!allProperties){
        allProperties=[NSMutableDictionary new];
    }
    NSString* class=[NSString stringWithFormat:@"%@",self.class];
    NSMutableArray *_properties=allProperties[class];
    if(!_properties){
        u_int count;
        objc_property_t* properties = class_copyPropertyList([self class], &count);
        _properties=[[NSMutableArray alloc]initWithCapacity:count];
        for (int i = 0; i < count ; i++)
        {
            objc_property_t property = properties[i];
            NSString *key=[[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding]; ;
            NSLog(@"%@",key);
            id value=[self valueForKey:key];
            if (value&& [value isKindOfClass:[UIView class]]) {
                [_properties addObject:key];
            }
        }
        free(properties);
        allProperties[class]=_properties;
    }
    return _properties;
}
-(void)handleData:(BaseDataModel*)data{
    id value;
    NSMutableArray *_properties=[self properties];
    for(NSString *key in _properties){
        UIView *control=[self valueForKey:key];//[_properties objectForKey:key];
        @try {
            value=[data valueForKey:key];
        }
        @catch (NSException *exception) {
            value=[data getValueWithKey:key];
        }
        if(!value)continue;
        value=[NSString stringWithFormat:@"%@",value];
        if([control isKindOfClass:[SelectButton class]]){
            SelectButton *sbtn=(SelectButton*)control;
            NSArray *arr=[value componentsSeparatedByString:@","];
            if (arr.count==2) {
                sbtn.kvalue=arr[0];
                [sbtn setTitle:arr[1] forState:UIControlStateNormal];
            }
        }
        else if([control isKindOfClass:[UIButton class]]){
            [((UIButton*)control) setTitle:value forState:UIControlStateNormal];
        }
        else if([control isKindOfClass:[UILabel class]]){
            ((UILabel*)control).text=value;
        }
        else if([control isKindOfClass:[UITextField class]]){
            ((UITextField*)control).text=value;
        }
        else if([control isKindOfClass:[UITextView class]]){
            ((UITextView*)control).text=value;
        }
        //        else if([control isKindOfClass:[UserPhoto class]]){
        //            if(value)((UserPhoto*)control).User=value;
        //        }
        else if([control isKindOfClass:[AsyImageView class]]){
            ((AsyImageView*)control).url=value;
        }
        else if([control isKindOfClass:[DecimalLabel class]]){
            DecimalLabel *label=(DecimalLabel*)control;
            NSArray *arr=[value componentsSeparatedByString:@","];
            if (arr.count==2) {
                label.kvalue=arr[0];
                [label setText:arr[1]];
            }
        }

    }
    [self.view layoutSubviews];
}
-(void)setData:(BaseDataModel *)Data{
    if(_Data==Data)return;
    if(_Data)[_Data removeDataChangedListener:self];
    _Data=Data;
    if(_Data)[_Data addDataChangedListener:self];
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if(nil==newSuperview){
        if(_Data)[_Data removeDataChangedListener:self];
    }
}
-(void)dealloc{
    if(_Data)[_Data removeDataChangedListener:self];
}

-(void)setSaveAction:(NSString *)saveAction{
    _saveAction=saveAction;
}
-(void)setSelfcontol:(UIViewController *)selfcontol
{
    _selfcontol=selfcontol;
}

-(void)doSave{
    [_selfcontol.view makeToastActivity];
    NSMutableArray *_properties=[self properties];
    for(NSString *key in _properties){
        UIView *control=[self valueForKey:key];
        if([control isKindOfClass:[SelectButton class]]){
            SelectButton *sbtn=(SelectButton*)control;
            [_Data setValue:sbtn.kvalue withKey:key];
        }
        else if([control isKindOfClass:[UIButton class]]){
            UIButton *btn=(UIButton*)control;
            [_Data setValue:btn.titleLabel.text withKey:key];
        }
        else if([control isKindOfClass:[UILabel class]]){
            [_Data setValue:((UILabel*)control).text withKey:key];
        }
        else if([control isKindOfClass:[UITextField class]]){
            [_Data setValue:((UITextField*)control).text withKey:key];
        }
        else if([control isKindOfClass:[UITextView class]]){
            [_Data setValue:((UITextView*)control).text withKey:key];
        }
        //        else if([control isKindOfClass:[UserPhoto class]]){
        //            if(value)((UserPhoto*)control).User=value;
        //        }
        else if([control isKindOfClass:[AsyImageView class]]){
            [_Data setValue:((AsyImageView*)control).url withKey:key];
        }
        else if([control isKindOfClass:[DecimalLabel class]]){
            DecimalLabel *sbtn=(DecimalLabel*)control;
            [_Data setValue:sbtn.kvalue withKey:key];
        }
    }
    NSString *jsonstr=[self.Data getJsonStr];
    
    NSDictionary *userdic=[Util getUserInfo];
    NSString *uid=[NSString stringWithFormat:@"%@",[userdic objectForKey:@"uid"]];
    
//    NSDictionary *param=[[NSDictionary alloc] initWithObjectsAndKeys:jsonstr,@"data",uid,@"uid", nil];
    [self.param setValue:jsonstr forKey:@"data"];
    [self.param setValue:uid forKey:@"uid"];
    NSLog(@"%@",self.param);
    
    if (self.hasFile) {
        [[HttpConnection new] startWithUrl:_saveAction params:self.param block:^(id data){
            if([data isKindOfClass:[NSDictionary class]]){
                NSLog(@"成功！！！！！");
                [_selfcontol.view hideToastActivity];
                [_selfcontol.view makeToast:@"成功" duration:2 position:@"center"];
                [_selfcontol performSelector:@selector(backSuccess)];
                [self.Data backOldValue];
            }
            else if (!data){
                [_selfcontol.view hideToastActivity];
                [self.Data backOldValue];
                NSLog(@"失败！！！！！");
            }
        }];
    }else{
        [[HttpConnection new] startWithUrlForNoFile:_saveAction params:self.param block:^(id data){
            if([data isKindOfClass:[NSDictionary class]]){
                NSLog(@"成功！！！！！");
                [_selfcontol.view hideToastActivity];
                [_selfcontol.view makeToast:@"成功" duration:2 position:@"center"];
                [_selfcontol performSelector:@selector(backSuccess)];
                [self.Data backOldValue];
            }
            else if (!data){
                [_selfcontol.view hideToastActivity];
                [self.Data backOldValue];
                NSLog(@"失败！！！！！");
            }
        }];
    }
    
}

@end

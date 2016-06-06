//
//  BaseViewWithData.m
//  易聚
//
//  Created by imac on 15/4/29.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import "BaseViewWithData.h"
#import <objc/runtime.h>
#import "AsyImageView.h"
#import "Image.h"
#import "UIView+Extension.h"
#import "UserPhoto.h"

@implementation BaseViewWithData
static NSMutableDictionary* allProperties;
-(NSMutableArray*)properties{
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
            if (value) {
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
        if([control isKindOfClass:[UIButton class]]){
            [((UIButton*)control) setTitle:value forState:UIControlStateNormal];
        }else if([control isKindOfClass:[UILabel class]]){
            ((UILabel*)control).text=value;
        }
        else if([control isKindOfClass:[UserPhoto class]]){
            if(value)((UserPhoto*)control).User=value;
        }else if([control isKindOfClass:[AsyImageView class]]){
            if([value isKindOfClass:[Image class]]){
            }else{
                ((AsyImageView*)control).url=value;
            }
        }
    }
    [self layoutSubviews];
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
@end

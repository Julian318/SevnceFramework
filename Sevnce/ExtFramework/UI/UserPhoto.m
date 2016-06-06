//
//  UserPhoto.m
//  七彩重师
//
//  Created by imac on 14-10-21.
//  Copyright (c) 2014年 xuner. All rights reserved.
//

#import "UserPhoto.h"
#import "ImageUploader.h"
//#import "RegisterUserView.h"
@interface UserPhoto(){
    ImageUploader* uploader;
}
@end
@implementation UserPhoto

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.defaultImage=[UIImage imageNamed:@"123"];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.enabled =YES;
        [tapGesture delaysTouchesBegan];
        [tapGesture cancelsTouchesInView];
        [self.view addGestureRecognizer:tapGesture];
    }
    return self;
}
-(void)setUser:(RegisterUser*)User{
    if(_User&&_User!=User)[_User removeDataChangedListener:self];
    _User=User;
    if(_User)[_User addDataChangedListener:self];
    else self.image=nil;
}
-(void)handleData:(BaseDataModel*)data{
    NSString* url=[_User getValueWithKey:@"HeadPhoto"];
    if(url&&![url isEqualToString:@""])self.url=url;
    else self.image=nil;
}
-(void)click{
    if([_User isEqual:[RegisterUser loggedUser]]){
        if(!uploader){
            uploader=[[ImageUploader alloc]initWithFrame:self.view.bounds url:@"/User/uploadHeadPhoto.json" compressRate:1.0f];
            [self.view addSubview:uploader];
        }
        [uploader pickPhotoWithBlock:^(NSDictionary* json){
            NSString* url=[json objectForKey:@"HeadPhoto"];
            if(url){
                [_User setValue:url withKey:@"HeadPhoto"];
                [_User notifyDataChanged];
            }
            [uploader removeFromSuperview];
            uploader=nil;
        }];
    }else{
//        RegisterUserView* page=[RegisterUserView new];
//        [page setUser:_User];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"popTo" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:page,@"page",nil]];
    }
}
-(void)dealloc{
    if(_User)[_User removeDataChangedListener:self];
}
@end

//
//  RegisterUserData.h
//  七彩重师
//
//  Created by imac on 14-10-21.
//  Copyright (c) 2014年 xuner. All rights reserved.
//

#import "BaseDataModel.h"

@interface RegisterUser : BaseDataModel
+(void)setLoggedUser:(RegisterUser*)user;
+(BOOL)isLogin;
+(void)setLatitude:(double)latitude;
+(void)setLongtitude:(double)longtitude;
+(double)getLatitude;
+(double)getLongtitude;
@property (retain, nonatomic,readonly) NSString *NickName;
@property double lat;
@property double lng;
+(RegisterUser*)loggedUser;
@end

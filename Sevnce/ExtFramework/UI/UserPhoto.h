//
//  UserPhoto.h
//  七彩重师
//
//  Created by imac on 14-10-21.
//  Copyright (c) 2014年 xuner. All rights reserved.
//

#import "AsyImageView.h"
#import "RegisterUser.h"
#import "Database.h"

@class RegisterUser;
@interface UserPhoto : AsyImageView
@property (retain, nonatomic) RegisterUser* User;
@end
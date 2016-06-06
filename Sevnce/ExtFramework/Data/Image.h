//
//  Image.h
//  七彩重师
//
//  Created by imac on 14-11-17.
//  Copyright (c) 2014年 xuner. All rights reserved.
//

#import "BaseDataModel.h"

@interface Image : BaseDataModel
@property (nonatomic,readonly)int Width;
@property (nonatomic,readonly)int Height;
@property (nonatomic,retain) NSString* Url;
@end

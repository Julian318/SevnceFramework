//
//  Image.m
//  七彩重师
//
//  Created by imac on 14-11-17.
//  Copyright (c) 2014年 xuner. All rights reserved.
//

#import "Image.h"
@implementation Image
-(int)Width{
    return ((NSString*)[self getValueWithKey:@"Width"]).intValue;
}
-(int)Height{
    return ((NSString*)[self getValueWithKey:@"Height"]).intValue;
}
-(NSString*)Url{
    return [self getValueWithKey:@"Url"];
}
-(id)init{
    self=[super init];
    if(self){
        self.keyName=@"Id";
    }
    return self;
}

@end
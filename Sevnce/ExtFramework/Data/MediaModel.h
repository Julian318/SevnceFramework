//
//  MediaModel.h
//  易聚
//
//  Created by imac on 15/4/23.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MediaModel : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * size;

@end

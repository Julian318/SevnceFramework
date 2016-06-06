//
//  MediaCache.h
//  易聚
//
//  Created by imac on 15/4/22.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSManagedObject,NSManagedObjectModel,NSManagedObjectContext;
@interface MediaCache : NSObject
+(instancetype) shareInstance ;
-(NSManagedObject*)getEntity:(NSString*)entity key:(NSString*)key equal:(id)value;
-(NSManagedObject*)addData:(NSDictionary*)value toEntity:(NSString*)entityName;
-(void)deleteDataForEntity:(NSString*)entityName;
-(void)save;
@end

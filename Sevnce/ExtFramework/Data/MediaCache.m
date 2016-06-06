//
//  MediaCache.m
//  易聚
//
//  Created by imac on 15/4/22.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import "MediaCache.h"
#import <CoreData/NSManagedObjectModel.h>
#import <CoreData/NSPersistentStoreCoordinator.h>
#import <CoreData/NSManagedObjectContext.h>
#import <CoreData/NSFetchRequest.h>
#import <CoreData/NSEntityDescription.h>
#import <CoreData/NSManagedObject.h>

@interface MediaCache(){
    NSManagedObjectModel* managedObjectModel;
    NSPersistentStoreCoordinator* persistentStoreCoordinator;
    NSManagedObjectContext* managedObjectContext;
}
@end

@implementation MediaCache
static  MediaCache* _instance=nil;
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance ;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [MediaCache shareInstance] ;
}
+(id)new{
    return [MediaCache shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [MediaCache shareInstance] ;
}
-(NSManagedObject*)getEntity:(NSString*)entityName key:(NSString*)key equal:(id)value{
    NSFetchRequest * requestTemplate = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity =
    [[managedObjectModel entitiesByName] objectForKey: entityName];
    [requestTemplate setEntity: entity];
    NSString* condition=[NSString stringWithFormat:@"%@=='%@'",key,value];
    NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:condition];
    [requestTemplate setPredicate: predicateTemplate];
    
    [managedObjectModel setFetchRequestTemplate: requestTemplate
                           forName: entityName];
    NSError* error;
    NSArray *results =
    [managedObjectContext executeFetchRequest: requestTemplate error: &error];
    if(!error&&results.count>0){
        return results[0];
    }
    return nil;
}
-(NSManagedObject*)addData:(NSDictionary*)value toEntity:(NSString*)entityName{
    NSManagedObject *obj=[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
    for (NSString* key in value.allKeys) {
        [obj setValue:value[key] forKey:key];
    }
    [managedObjectContext save:nil];
    return obj;
}
-(void)deleteDataForEntity:(NSString*)entityName{
    NSFetchRequest *FectchRequest=[NSFetchRequest fetchRequestWithEntityName:entityName];
    NSArray *arr=[managedObjectContext executeFetchRequest:FectchRequest error:nil];
    for (NSManagedObject *obj in arr) {
        [managedObjectContext deleteObject:obj];
    }
    [managedObjectContext save:nil];
}
-(void)save{
    [managedObjectContext save:nil];
}
-(id)init{
    if(_instance)return _instance;
    self=[super init];
    if(self){
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MediaCache" withExtension:@"momd"];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: managedObjectModel];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                 nil];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *storeURL = [urls[0] URLByAppendingPathComponent:@"MediaCache.sqlite"];
        NSError* error;
        if ([persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
        {
            managedObjectContext = [[NSManagedObjectContext alloc] init];
            [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        }
    }
    return self;
}

@end

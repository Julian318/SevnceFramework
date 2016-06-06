//
//  Database.m
//  七彩重师
//
//  Created by imac on 14-10-21.
//  Copyright (c) 2014年 xuner. All rights reserved.
//
#import <CoreData/NSManagedObjectModel.h>
#import <CoreData/NSPersistentStoreCoordinator.h>
#import <CoreData/NSManagedObjectContext.h>
#import "Database.h"
#import "RegisterUser.h"

static  Database* instance_;
static RegisterUser *_user;
@interface Database(){
    NSManagedObjectModel* managedObjectModel;
    NSPersistentStoreCoordinator* persistentStoreCoordinator;
    NSManagedObjectContext* managedObjectContext;
}
@end

@implementation Database
+(BOOL)isLogin{
    return _user!=nil;
}
+(void)setUser:(RegisterUser*)user{
    _user=user;
}
+(RegisterUser*)getUser{
    return _user;
}
-(id)new{
    return [self init];
}
-(id)init{
    if(instance_)return instance_;
    self=[super init];
    if(self){
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: managedObjectModel];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                 nil];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *storeURL = [urls[0] URLByAppendingPathComponent:@"DataModel.sqlite"];
        NSError* error;
        if ([persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
        {
            managedObjectContext = [[NSManagedObjectContext alloc] init];
            [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        }
    }
    instance_=self;
    return instance_;
}
@end

//
//  BaseDataModel.h
//  EasyFM
//
//  Created by imac on 13-6-7.
//  Copyright (c) 2013年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpConnection.h"
@class RegisterUser;
@interface BaseDataModel : NSObject<NSCoding>{
    NSMutableDictionary *_values;
    NSMutableDictionary *_newValues;
    Boolean (^callBack) (void);
}
@property Boolean inited;
@property(nonatomic) Boolean needUpdate;
@property Boolean needNotify;
@property (nonatomic, retain) NSString *urlForView;
@property (nonatomic, retain) NSString *urlForEdit;
@property (nonatomic, retain) NSString *urlForDelete;
@property (nonatomic, retain) NSString *keyName;
@property (nonatomic,readonly) NSString *identifier;
@property (nonatomic, retain) NSMutableArray* listener;
@property (retain, nonatomic) RegisterUser *User;

-(void)setId:(NSString *)Id;
+(void)removeDataForModelName:(NSString*)modelName;
-(id)getValueWithKey:(NSString*)key;
-(void)setValue:(id)value withKey:(NSString*)key;
- (void)addDataChangedListener:(id<NSObject>)listener;
- (void)removeDataChangedListener:(id<NSObject>)listener;
- (void)removeAllListener;
-(void)notifyDataChanged;
-(id)initWithId:(NSString*)Id;
-(id)initWithData:(NSDictionary*)data;
-(void)updateWithData:(NSDictionary*)data;
-(void)reloadWithBlock:(id)block;
-(void)updateWithBlock:(id)block;
-(void)deleteWithBlock:(id)block;
-(void)restore;

-(NSString *)getJsonStr;
-(void)backOldValue;
-(NSInteger)getUpdateDataCount;

- (NSMutableDictionary *)bindValues;

///初始化&获取数据 传递id keyName
-(id)initAndGetWithPara:(NSDictionary *)para andKeyName:(NSString *)KeyName;
@end

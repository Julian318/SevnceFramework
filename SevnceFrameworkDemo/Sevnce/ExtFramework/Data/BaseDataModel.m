//
//  BaseDataModel.m
//  EasyFM
//
//  Created by imac on 13-6-7.
//  Copyright (c) 2013年 imac. All rights reserved.
//

#import "BaseDataModel.h"
@interface BaseDataModel()
{
    NSDictionary *getDic;
}
@property (nonatomic, retain) NSMutableDictionary* values;
@end
@implementation BaseDataModel
static NSMutableDictionary* records;
+(NSMutableDictionary*)getCacheWithModel:(Class)model{
    if(!records)records=[NSMutableDictionary new];
    NSString* modelName=[NSString stringWithFormat:@"%@",model];
    NSMutableDictionary* cache=records[modelName];
    if(!cache){
        cache=[NSMutableDictionary new];
        records[modelName]=cache;
    }
    return cache;
}
+(void)removeDataForModelName:(NSString*)modelName{
    [records removeObjectForKey:modelName];
}
-(NSMutableDictionary*)values{
    if(!_values){
        _values=[NSMutableDictionary new];
    }
    if(!_newValues){
        _newValues=[NSMutableDictionary new];
    }
    return _values;
}
-(id)initWithId:(NSString*)Id{
    self=[self init];
    if(self){
        if(self.keyName){
            if(Id&&![@"" isEqual:Id]){
                [self.values setObject:Id forKey:self.keyName];
                NSMutableDictionary* cache=[BaseDataModel getCacheWithModel:self.class];
                BaseDataModel* data=cache[Id];
                if(!data){
                    cache[Id]=self;
                    [self reloadWithBlock:nil];
                }else{
                    self=data;
                }
            }
        }
    }else{
        self=[super init];
    }
    return self;
}

///初始化&获取数据 传递id keyName
-(id)initAndGetWithPara:(NSDictionary *)para andKeyName:(NSString *)KeyName{
    self=[self init];
    if(self){
        if(self.keyName){
            if(para[KeyName]&&![@"" isEqual:para[KeyName]]){
            NSArray *arr = [para allKeys];
            for (int i=0; i<arr.count; i++) {
                [self.values setObject:para[arr[i]] forKey:arr[i]];
            }
                getDic = para;
                NSMutableDictionary* cache=[BaseDataModel getCacheWithModel:self.class];
                BaseDataModel* data=cache[para[KeyName]];
                if(!data){
                    cache[para[KeyName]]=self;
                    [self getDataWithBlock:nil];
                }else{
                    self=data;
                }
            }
        }
    }else{
        self=[super init];
    }
    return self;
}

-(void)getDataWithBlock:(id)block{
    if(!self.urlForView)return;
    [[HttpConnection alloc]startWithUrl:self.urlForView params:getDic block:^(id json){
        if([json isKindOfClass:[NSDictionary class]]){
            if(json[self.keyName]){
                self.inited=YES;
                _values=[NSMutableDictionary dictionaryWithDictionary:json];
                _newValues=[NSMutableDictionary new];
                self.needNotify=YES;
                [self notifyDataChanged];
                callBack=block;
                if(callBack)callBack();
            }
        }
    }];
}


-(id)initWithData:(NSDictionary*)json{
    self=[self init];
    if(self){
        if(self.keyName){
            if(json[self.keyName]){
                NSMutableDictionary* cache=[BaseDataModel getCacheWithModel:self.class];
                BaseDataModel* data=cache[json[self.keyName]];
                if(!data){
                    _values=[NSMutableDictionary dictionaryWithDictionary:json];
                    _newValues=[NSMutableDictionary new];
                    cache[json[self.keyName]]=self;
                    self.inited=YES;
                    self.needNotify=YES;
                    [self notifyDataChanged];
                }else{
                    self=data;
                    if(!self.needUpdate)[self updateWithData:json];
                }
            }
        }
    }else{
        self=[super init];
    }
    return self;
}
-(void)reloadWithBlock:(id)block{
    if(!self.urlForView)return;
    [[HttpConnection alloc]startWithUrl:self.urlForView params:[NSDictionary dictionaryWithObjectsAndKeys:self.identifier,self.keyName, nil] block:^(id json){
        if([json isKindOfClass:[NSDictionary class]]){
            if(json[self.keyName]){
                self.inited=YES;
                _values=[NSMutableDictionary dictionaryWithDictionary:json];
                _newValues=[NSMutableDictionary new];
                self.needNotify=YES;
                [self notifyDataChanged];
                callBack=block;
                if(callBack)callBack();
            }
        }
    }];
}
-(void)updateWithBlock:(id)block{
    callBack=block;
    if(self.inited&&!self.needUpdate){
        if(callBack)callBack();
        return;
    }
    if(!self.urlForEdit){
        if(callBack)callBack();
        return;
    }
    NSMutableDictionary*para=[_values copy];
    for (NSString* key in _newValues.allKeys) {
        para[key]=_newValues[key];
    }
    [[HttpConnection alloc]startWithUrl:self.urlForEdit params:para block:^(id json){
        if(!json)return;
        if([json isKindOfClass:[NSDictionary class]]){
            if(!self.inited&&json[self.keyName]){
                _values[self.keyName]=json[self.keyName];
                self.inited=YES;
                NSString* modelName=[NSString stringWithFormat:@"%@",self.class];
                [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"addOrDelete%@",modelName] object:nil userInfo:nil];
            }
            self.needNotify=YES;
            [self updateWithData:json];
            [_newValues removeAllObjects];
            if(callBack)callBack();
        }
    }];
}
-(void)deleteWithBlock:(id)block{
    [_listener removeAllObjects];
    callBack=block;
    if(!self.inited||!self.urlForDelete){
        if(callBack)callBack();
        return;
    }
    [[HttpConnection alloc]startWithUrl:self.urlForDelete params:[NSDictionary dictionaryWithObjectsAndKeys:self.identifier,self.keyName, nil] block:^(id json){
        if([json isKindOfClass:[NSDictionary class]]){
            NSMutableDictionary* cache=[BaseDataModel getCacheWithModel:self.class];
            if(self.inited){
                self.inited=NO;
                [cache removeObjectForKey:self.identifier];
                NSString* modelName=[NSString stringWithFormat:@"%@",self.class];
                [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"addOrDelete%@",modelName] object:nil userInfo:nil];
                if(callBack)callBack();
            }
        }
    }];
}

-(void)updateWithData:(NSDictionary*)data{
    NSMutableDictionary* cache=[BaseDataModel getCacheWithModel:self.class];
    if(data[self.keyName]){
        BaseDataModel* oldModel=cache[data[self.keyName]];
        if(oldModel){
            if(self!=oldModel){
                for (id item in oldModel.listener) {
                    [self.listener addObject:item];
                }
                [oldModel removeAllListener];
                cache[data[self.keyName]]=self;
                self.inited=YES;
                _values=[NSMutableDictionary dictionaryWithDictionary:data];
                //_newValues=[NSMutableDictionary new];
                self.needNotify=YES;
            }
        }else{
            cache[data[self.keyName]]=self;
            self.inited=YES;
            _values=[NSMutableDictionary dictionaryWithDictionary:data];
            _newValues=[NSMutableDictionary new];
            self.needNotify=YES;
        }
    }
    for (NSString* key in data.allKeys) {
        [self setValue:data[key] withKey:key];
    }
    [self notifyDataChanged];
}
-(NSMutableArray*)listener{
    if(!_listener)_listener=[NSMutableArray new];
    return _listener;
}
- (void)addDataChangedListener:(id<NSObject>)listener
{
    if (listener && [listener respondsToSelector:@selector(handleData:)]) {
        if(!_listener){
            _listener=[NSMutableArray arrayWithObjects:listener,nil];
        }else{
            [_listener addObject:listener];
        }
        [listener performSelector:@selector(handleData:) withObject:self];
    }
}
- (void)removeDataChangedListener:(id<NSObject>)listener
{
    if(_listener){
        [_listener removeObject:listener];
    }
}
- (void)removeAllListener
{
    if(_listener){
        [_listener removeAllObjects];
    }
}
-(void)dealloc{
    [_listener removeAllObjects];
}
-(void)notifyDataChanged{
    if(!self.needNotify)return;
    for (id<NSObject> delegate in _listener) {
        if (delegate && [delegate respondsToSelector:@selector(handleData:)]) {
            [delegate performSelector:@selector(handleData:) withObject:self];
        }
    }
    self.needNotify=NO;
}
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_values forKey:@"values"];

}
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        _values = [aDecoder decodeObjectForKey:@"values"];
    }
    return self;
}
- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    if (![object isKindOfClass:[BaseDataModel class]]) {
        return NO;
    }
    BaseDataModel *myItem = (BaseDataModel *)object;
    return [myItem.identifier isEqual:self.identifier];
}
- (NSUInteger)hash {
    return [self.identifier hash];
}
-(NSString*)identifier{
    if([_values objectForKey:self.keyName])return [_values objectForKey:self.keyName];
    else return @"";
}
-(void)setId:(NSString *)Id{
    if([@"" isEqualToString:self.identifier]){
        [self.values setObject:Id forKey:self.keyName];
        [self reloadWithBlock:nil];
    }
}

-(id)getValueWithKey:(NSString*)key{
    if(_newValues[key]){
        return _newValues[key];
    }
    return [self.values objectForKey:key];
}

-(void)setValue:(id)value withKey:(NSString*)key{
    if(!value)return;
    if([key isEqual:self.keyName])return;
    id oldValue=[self getValueWithKey:key];
    if(oldValue){
        Boolean compare=![self compareValue:value toValue:oldValue];
        if(compare){
            if (!_newValues) {
                _newValues=[NSMutableDictionary new];
            }
            _newValues[key]=value;
        }
        self.needNotify|=compare;
    }else{
        _newValues[key]=value;
        self.needNotify=YES;
    }
    //_values[key]=value;
}
-(void)restore{
    [_newValues removeAllObjects];
    self.needNotify=YES;
    [self notifyDataChanged];
}
-(Boolean)needUpdate{
    return _newValues.count>0;
}
-(Boolean)compareValue:(id)value toValue:(id)another{
    @try {
        Boolean temp=NO;
        if([another isKindOfClass:[NSNumber class]]){
            temp=(value==another);
        }else{
            temp=[value isEqualToString:another];
        }
        if(!temp){
            @try {
                return [value isEqual:another];
            }
            @catch (NSException *exception) {
                return YES;
            }
        }
        return temp;
    }
    @catch (NSException *exception) {
        return YES;
    }
}

-(NSString *)getJsonStr{
    
    for (NSString* key in _newValues.allKeys) {
        _values[key]=_newValues[key];
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_values options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}







-(void)backOldValue{
    [_newValues removeAllObjects];
    
}
-(NSInteger)getUpdateDataCount{
    return _newValues.count;
}




- (NSMutableDictionary *)bindValues
{
    for (NSString* key in _newValues.allKeys) {
        _values[key]=_newValues[key];
    }
    return _values;
}

@end

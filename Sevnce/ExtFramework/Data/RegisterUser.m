
#import "RegisterUser.h"
@implementation RegisterUser
static RegisterUser *_user;
static double _latitude;
static double _longtitude;
+(RegisterUser*)loggedUser{
    return _user;
}
+(void)setLoggedUser:(RegisterUser*)user{
    _user=user;
}

+(BOOL)isLogin{
    return _user.identifier!=nil;
}
+(void)setLatitude:(double)latitude{
    _latitude=latitude;
}
+(void)setLongtitude:(double)longtitude{
    _longtitude=longtitude;
}
+(double)getLatitude{
    return _latitude;
}
+(double)getLongtitude{
    return _longtitude;
}

-(RegisterUser*)init{
    self=[super init];
    if(self){
        self.keyName = @"uid";
        self.urlForView = @"/User/userInfo.json";
        self.urlForEdit = @"/User/editInfo.json";
        
    }
    return self;
}
-(NSString*)NickName{
    return [self getValueWithKey:@"userName"];
}
@end

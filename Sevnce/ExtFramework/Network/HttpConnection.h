
#import <UIKit/UIKit.h>

@interface HttpConnection : NSObject

@property BOOL hideIndicator;
@property (nonatomic, strong) NSString *hosts;
+(void)initNetworkStatusWithHost:(NSString*)serverUrl handler:(id)block;
+(BOOL)isNetworkConnected;
-(NSURLSessionTask*)startWithUrl:(NSString*)url params:(NSDictionary*)para block:(id)block;
-(NSURLSessionTask*)startWithUrlForNoFile:(NSString*)url params:(NSDictionary*)para block:(id)block;

@end

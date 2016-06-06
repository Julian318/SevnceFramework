#import <UIKit/UIKit.h>
@class HttpConnection;
@protocol PostButtonDelegate <NSObject>
@optional
- (void)postOK:(NSDictionary *)json;
- (Boolean)didBeforePost;
- (void)didAfterUploadImageWithKey:(NSString*)key data:(NSDictionary*)data;
@end
@interface PostButton : UIButton

@property (retain, nonatomic) id<PostButtonDelegate> delegate;
@property (retain, nonatomic) HttpConnection *dataCenter;
@property (retain, nonatomic) NSString *action;
@property (retain, nonatomic) NSMutableDictionary *para;
@property (retain, nonatomic) UIView *loading;
@property (retain, nonatomic) UIProgressView *progress;
- (void)post;
@end

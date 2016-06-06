
#import <UIKit/UIKit.h>
@class AsyImageProgressView;
@interface ImageUploader : UIImageView
@property bool hasPhoto;
@property float compressRate;
@property (retain, nonatomic) AsyImageProgressView *progressView;
@property (retain, nonatomic) NSString *uploadUrl;
- (id)initWithFrame:(CGRect)frame url:(NSString*)url compressRate:(float)rate;
-(void)deletePhoto;
- (void)uploadWithBlock:(id)block;
- (void)pickPhotoWithBlock:(id)block;
@end

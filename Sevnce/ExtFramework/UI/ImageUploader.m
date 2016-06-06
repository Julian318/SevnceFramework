
#import "ImageUploader.h"
#import "HttpConnection.h"
#import "SVProgressHUD.h"
#import "AsyImageProgressView.h"
#import "UIView+Extension.h"
@interface ImageUploader()
{
    void (^uploadSuccess) (NSDictionary* json);
    HttpConnection* dataCenter;
    UIButton* btnDelete;
}
@end
@implementation ImageUploader

- (id)initWithFrame:(CGRect)frame url:(NSString*)url compressRate:(float)rate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        self.image=[UIImage imageNamed:@"ExtUI.bundle/btnaddphoto"];
        _uploadUrl=url;
        _compressRate=rate;
        btnDelete=[UIButton buttonWithType:UIButtonTypeSystem];
        [btnDelete setTitle:@"删除" forState:UIControlStateNormal];
        [btnDelete setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btnDelete sizeToFit];
        btnDelete.center=CGPointMake(self.Width*0.5, self.Height*0.5);
        [btnDelete addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickPhoto)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.enabled =YES;
        [tapGesture delaysTouchesBegan];
        [tapGesture cancelsTouchesInView];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}
-(void)pickPhoto{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPhoto" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPhoto:) name:@"selectPhoto" object:nil];
}
- (void)pickPhotoWithBlock:(id)block{
    uploadSuccess=block;
    [self pickPhoto];
}
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPhoto" object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPhoto:) name:@"selectPhoto" object:nil];
//}
-(void)deletePhoto{
    self.image=[UIImage imageNamed:@"ExtUI.bundle/btnaddphoto"];
    self.hasPhoto=NO;
    [btnDelete removeFromSuperview];
}
- (void)selectPhoto:(NSNotification*)notification {
    if([notification userInfo]){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectPhoto" object:nil];
        self.image=(UIImage*)[(NSDictionary*)[notification userInfo] objectForKey:@"photo"];
        if(!self.image){
            [self deletePhoto];
        }else{
            [self addSubview:btnDelete];
            self.hasPhoto=YES;
            if(uploadSuccess)[self uploadWithBlock:uploadSuccess];
        }
    };
}
- (void)uploadWithBlock:(id)block
{
    uploadSuccess=block;
    UIImageView* _loading=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    _loading.animationDuration=1;
    _loading.animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"ExtUI.bundle/loading1.png"],[UIImage imageNamed:@"ExtUI.bundle/loading2.png"],[UIImage imageNamed:@"ExtUI.bundle/loading3.png"],[UIImage imageNamed:@"ExtUI.bundle/loading4.png"], nil];
    [SVProgressHUD sharedView].spinnerView=_loading;
    [SVProgressHUD showWithStatus:@"上传中..."];
    if(self.image){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imageFile = [documentsDirectory stringByAppendingPathComponent:@"temp.jpg"];
        if([fileManager fileExistsAtPath:imageFile]) {
            [fileManager removeItemAtPath:imageFile error:nil];
        }
        [UIImageJPEGRepresentation(self.image, self.compressRate) writeToFile:imageFile atomically:YES];
        dataCenter=[HttpConnection new];
        [dataCenter startWithUrl:self.uploadUrl params:[NSDictionary dictionaryWithObjectsAndKeys:[NSURL fileURLWithPath:imageFile],@"Content", nil] block:^(id data){
            if(data){
                if([data isKindOfClass:[NSDictionary class]]){
                    NSDictionary* json=data;
                    self.progressView=nil;
                    [SVProgressHUD dismiss];
                    [fileManager removeItemAtPath:imageFile error:nil];
                    if(uploadSuccess)uploadSuccess(json);
                }if([data isKindOfClass:[NSProgress class]]){
                    NSProgress* progress=data;
                    if(!self.progressView){
                        self.progressView=[AsyImageProgressView new];
                    }
                    [self.progressView refreshProgress:progress];
                }
            }
        }];
    }
}
-(void)setProgressView:(AsyImageProgressView *)progressView{
    if(!_progressView)[_progressView removeFromSuperview];
    _progressView=progressView;
    if(_progressView){
        [self addSubview:_progressView];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectPhoto" object:nil];
}
@end

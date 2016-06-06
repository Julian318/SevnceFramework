//
//  AsyImageView.m
//  聚会掌中宝
//
//  Created by imac on 15/4/10.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import "AsyImageView.h"
#import "HttpConnection.h"
#import "MediaCache.h"
#import "MediaModel.h"
#import <ImageIO/ImageIO.h>
#import "UIView+Extension.h"
#import "AsyImageProgressView.h"

@interface AsyImageView(){
    CGRect frame_;
    UIImageView* _imageView;
    NSURLRequest    *_request;
    NSURLConnection *_conn;
    CGImageSourceRef _incrementallyImgSource;
    NSMutableData   *_recieveData;
    long long       _expectedLeght;
    bool            _isLoadFinished;
    void (^loadSuccess) ();
    UITapGestureRecognizer * tapGesture;
}
@end
@implementation AsyImageView
static  NSMutableDictionary* waiting=nil;
static  NSMutableDictionary* imageCache=nil;
static NSLock* _lock;
-(id)init{
    self=[super init];
    if(self){
        static dispatch_once_t onceToken ;
        dispatch_once(&onceToken, ^{
            waiting=[NSMutableDictionary new];
            imageCache=[NSMutableDictionary new];
            _lock=[NSLock new];
//            [[MediaCache shareInstance] deleteDataForEntity:@"MediaModel"];
        }) ;
        frame_=CGRectZero;
    }
    return self;
}
-(id)initWithUrl:(NSString*)url{
    self=[self init];
    if(self){
        self.url=url;
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    self=[self init];
    if(self){
        frame_=frame;
        _imageView.frame=frame;
        self.view.frame=frame;
    }
    return self;
}
-(void)loadView{

    _imageView=[UIImageView new];
    _imageView.userInteractionEnabled=YES;
    //为图片添加手势
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showFullScreen)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.enabled =YES;
    [tapGesture delaysTouchesBegan];
    [tapGesture cancelsTouchesInView];
    [_imageView addGestureRecognizer:tapGesture];
    self.view=_imageView;
}
-(void)setForbitEnlarge:(BOOL)forbitEnlarge{
    _forbitEnlarge=forbitEnlarge;
    if(forbitEnlarge){
        [_imageView removeGestureRecognizer:tapGesture];
    }
}
-(void)showFullScreen{

    [[SSImageView new]viewWithImage:_imageView];
}
-(UIImage*)getCache{
    UIImage* image=imageCache[self.url];
    if(!image){
        MediaModel* cache=(MediaModel*)[[MediaCache shareInstance] getEntity:@"MediaModel" key:@"url" equal:self.url];
        if(cache){
            cache.timeStamp=[NSDate date];
            [[MediaCache shareInstance] save];
            image=[UIImage imageWithData:cache.data];
            [_lock lock];
            @try {
                [imageCache setObject:image forKey:self.url];
            } @catch (NSException *exception) {
                image = nil;
            }
            [_lock unlock];
        }
    }
    return image;
}
-(void)setCache:(NSData*)data{
    if(data){
        MediaCache* mediaCache=[MediaCache shareInstance];
        NSDictionary* values=[NSDictionary dictionaryWithObjectsAndKeys:self.url,@"url", data,@"data", @(data.length),@"size",[NSDate date],@"timeStamp",nil];
        [mediaCache addData:values toEntity:@"MediaModel"];
        [_lock lock];
//        if ([UIImage imageWithData:data] != nil) {
//            [imageCache setObject:[UIImage imageWithData:data] forKey:self.url];
//        }
        @try {
            [imageCache setObject:[UIImage imageWithData:data] forKey:self.url];
        } @catch (NSException *exception) {
            imageCache = nil;
        }
        [_lock unlock];
    }
}
-(void)getLargeImage{
    _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    _conn    = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
    _incrementallyImgSource = CGImageSourceCreateIncremental(NULL);
    _recieveData = [[NSMutableData alloc] init];
    _isLoadFinished = false;
}
-(void)getSmallImage{
    UIImage* image=[self getCache];
    if(image){
        self.image=image;
    }
    else{
        loadSuccess=self.loadComplete;
        NSMutableArray* wait=waiting[self.url];
        if(!wait){
            if(!self.url){
                return;
            }
            [_lock lock];
            [waiting setObject:[NSMutableArray arrayWithObject:self] forKey:self.url];
            [_lock unlock];
            [[HttpConnection new]startWithUrl:self.url params:nil block:^(id ret){
                if(ret){
                    if([ret isKindOfClass:[NSData class]]){
                        NSData* data=ret;
                        [self setCache:data];
                        NSMutableArray* wait=waiting[self.url];
                        UIImage* image=[self getCache];
                        for (AsyImageView* item in wait) {
                            item.image = image;
                        }
                        [_lock lock];
                        [waiting removeObjectForKey:self.url];
                        [_lock unlock];
//                        [imageCache removeAllObjects];
//                        [[MediaCache shareInstance] deleteDataForEntity:@"MediaModel"];
                    }else if([ret isKindOfClass:[NSProgress class]]){
                        NSProgress* progress=ret;
                        if(!self.progressView&&!self.forbitShowProgress){
                            self.progressView=[AsyImageProgressView new];
                        }
                        [self.progressView refreshProgress:progress];
                    }
                }
                return YES;
            }];
        }else{
            [wait addObject:self];
            if(!self.forbitShowProgress){
                self.progressView=[[AsyImageProgressView alloc]initWithType:AsyImageProgressTypeLoading];
            }
        }
    }

}
-(void)setProgressView:(AsyImageProgressView *)progressView{
    if(!_progressView)[_progressView removeFromSuperview];
    _progressView=progressView;
    if(_progressView){
        [self.view addSubview:_progressView];
    }
}
-(void)setUrl:(NSString *)url{
    _url=url;
    self.image=nil;
    if(self.url&&![@"" isEqualToString:url]){
        UIImage* image=imageCache[self.url];
        if(image)self.image=image;
        else{
            if(self.view.isDisplayedInScreen)[self getSmallImage];
            else{
                [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionInitial context:nil];
            }
        }
    }else _url=nil;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    if(self.view.isDisplayedInScreen)[self getSmallImage];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.url){
        [self getSmallImage];
    }
}
-(UIImage*)image{
    return _imageView.image;
}
-(void)setImage:(UIImage *)image{
    if(!image){
        image=self.defaultImage;
    }
    if(image){
        if(frame_.size.width==0&&frame_.size.height==0){
            [_imageView sizeToFit];
        }
        else if(frame_.size.height==0){
            _imageView.frame=CGRectMake(frame_.origin.x, frame_.origin.y, frame_.size.width, frame_.size.width*image.size.height/image.size.width);
        }
        else if(frame_.size.width==0){
            _imageView.frame=CGRectMake(frame_.origin.x, frame_.origin.y, frame_.size.height*image.size.width/image.size.height, frame_.size.height);
        }else{
            _imageView.frame=frame_;
        }
        _imageView.image=nil;
        _imageView.image=image;
        if(loadSuccess){
            loadSuccess();
            loadSuccess=nil;
        }else{
            [self.view layoutIfNeeded];
        }
    }
    if(self.progressView)[self.progressView removeFromSuperview];
}
-(void)didReceiveMemoryWarning{
    [imageCache removeAllObjects];
}
@end
//#import "AppDelegate.h"
@interface SSImageView ()<UIActionSheetDelegate>{
    UIImageView * imageView_;
    UIScrollView * _contentView;
    UIWindow * window;
    CGRect frame;
    CGRect oriFrame;
    UIActionSheet *sheet;
    UIAlertView *photoSave;
}
//全屏显示时图片的size
- (CGSize) preferredSize:(UIImage *)image;

@end
@implementation SSImageView
- (void)dealloc
{
    _contentView =nil;
    imageView_ = nil;
}

- (void)viewWithImage:(UIImageView*)imageView
{
//    AppDelegate* delegate=(AppDelegate*)([UIApplication sharedApplication].delegate);
    window = [UIApplication sharedApplication].delegate.window;
    frame=window.frame;
    oriFrame=[imageView convertRect:imageView.bounds toView:window];
    self.frame = frame;
    self.backgroundColor = [UIColor clearColor];
    _contentView=[[UIScrollView alloc]initWithFrame:frame];
    _contentView.backgroundColor=[UIColor blackColor];
    _contentView.delegate=self;
    _contentView.bouncesZoom=YES;
    
    _contentView.minimumZoomScale = 1.0;
    _contentView.maximumZoomScale = imageView.image.size.width/frame.size.width;
    
    _contentView.showsHorizontalScrollIndicator=NO;
    _contentView.showsVerticalScrollIndicator=NO;
    [self addSubview:_contentView];
    
    
    imageView_ = [[UIImageView alloc]initWithFrame:oriFrame];
    imageView_.userInteractionEnabled =YES;
    [self addSubview:imageView_];
    
    //为图片添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.enabled =YES;
    [tapGesture delaysTouchesBegan];
    [tapGesture cancelsTouchesInView];
    [imageView_ addGestureRecognizer:tapGesture];
    UILongPressGestureRecognizer* longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(savePhoto)];
    longPressGesture.enabled =YES;
    [imageView_ addGestureRecognizer:longPressGesture];
//    _imageView=imageView;
    //        imageView_.center =self.center;
    imageView_.image = imageView.image;
    [window addSubview:self];
    _contentView.alpha = 0;
    CGSize size = [self preferredSize:imageView.image];
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.alpha = 1.0;
        imageView_.frame =CGRectMake(0, 0, size.width, size.height);
        imageView_.center=self.center;
    }completion:^(BOOL finished) {
        if (finished) {
            _contentView.contentSize= size;
            [_contentView addSubview:imageView_];
        }
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error !=NULL) {
        photoSave = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",error]delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    }else {
        photoSave = [[UIAlertView alloc]initWithTitle:@"保存成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    }
    [photoSave show];
    [self performSelector:@selector(closePhotoSaveAlert) withObject:nil afterDelay:2];
}
-(void)closePhotoSaveAlert{
    [photoSave dismissWithClickedButtonIndex:0 animated:YES];
}
- (CGSize) preferredSize:(UIImage *) image {
    CGFloat width = 0.0, height = 0.0;
    CGFloat rat0 = image.size.width / image.size.height;
    CGFloat rat1 =self.frame.size.width /self.frame.size.height;
    if (rat0 > rat1) {
        width =self.frame.size.width;
        height = width / rat0;
    }else {
        height =self.frame.size.height;
        width = height * rat0;
    }
    return CGSizeMake(width, height);
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView_;
}
-(void) scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat x = scrollView.center.x,y = scrollView.center.y;
    x = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :x;
    y = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : y;
    imageView_.center =CGPointMake(x, y);
}
-  (void) hideImage {
    [self addSubview:imageView_];
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.alpha = 0;
        imageView_.frame=oriFrame;
    }completion:^(BOOL finished) {
        if (finished) {
            _contentView.alpha=1;
            [_contentView removeFromSuperview];
            [imageView_ removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}
- (void)savePhoto{
    if(sheet)return;
    sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
    [sheet showInView:window];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            UIImageWriteToSavedPhotosAlbum(imageView_.image,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
            break;
        default:
            break;
    }
    sheet=nil;
}

@end
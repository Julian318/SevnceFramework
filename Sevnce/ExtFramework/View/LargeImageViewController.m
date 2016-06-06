//
//  LargeImageViewController.m
//  易聚
//
//  Created by imac on 15/4/25.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import "LargeImageViewController.h"
#import "HttpConnection.h"
#import "MediaCache.h"
#import "MediaModel.h"
#import <ImageIO/ImageIO.h>
@interface LargeImageViewController(){
    CGRect frame_;
    UIImageView* _imageView;
    NSURLRequest    *_request;
    NSURLConnection *_conn;
    
    CGImageSourceRef _incrementallyImgSource;
    
    NSMutableData   *_recieveData;
    long long       _expectedLeght;
    bool            _isLoadFinished;
}
@end
@implementation LargeImageViewController
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
        _url=url;
        _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        _conn    = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
        _incrementallyImgSource = CGImageSourceCreateIncremental(NULL);
        
        _recieveData = [[NSMutableData alloc] init];
        _isLoadFinished = false;
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
    self.view=_imageView;
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
            [imageCache setObject:image forKey:self.url];
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
        [imageCache setObject:[UIImage imageWithData:data] forKey:self.url];
        [_lock unlock];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.url){
        UIImage* image=[self getCache];
        if(image){
            self.image=image;
        }
        else{
            NSMutableArray* wait=waiting[self.url];
            if(!wait){
                [_lock lock];
                [waiting setObject:[NSMutableArray arrayWithObject:self] forKey:self.url];
                [_lock unlock];
                [[HttpConnection new]startWithUrl:self.url params:nil block:^(NSData* data){
                    if([data isKindOfClass:[NSData class]]){
                        [self setCache:data];
                        NSMutableArray* wait=waiting[self.url];
                        UIImage* image=[self getCache];
                        for (LargeImageViewController* item in wait) {
                            item.image = image;
                        }
                        [_lock lock];
                        [waiting removeObjectForKey:self.url];
                        [_lock unlock];
                    }
                }];
            }else{
                [wait addObject:self];
            }
        }
    }
}
-(UIImage*)image{
    return _imageView.image;
}
-(void)setImage:(UIImage *)image{
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
        _imageView.image=image;
    }
}
-(void)didReceiveMemoryWarning{
    [imageCache removeAllObjects];
}
#pragma mark -
#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _expectedLeght = response.expectedContentLength;
    NSLog(@"expected Length: %lld", _expectedLeght);
    
    NSString *mimeType = response.MIMEType;
    NSLog(@"MIME TYPE %@", mimeType);
    
    NSArray *arr = [mimeType componentsSeparatedByString:@"/"];
    if (arr.count < 1 || ![[arr objectAtIndex:0] isEqual:@"image"]) {
        NSLog(@"not a image url");
        [connection cancel];
        _conn = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection %@ error, error info: %@", connection, error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection Loading Finished!!!");
    
    // if download image data not complete, create final image
    if (!_isLoadFinished) {
        CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)_recieveData, _isLoadFinished);
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
        self.image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_recieveData appendData:data];
    
    _isLoadFinished = false;
    if (_expectedLeght == _recieveData.length) {
        _isLoadFinished = true;
    }
    
    CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)_recieveData, _isLoadFinished);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
    self.image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
}

@end
//
//  AsyImageView.m
//  聚会掌中宝
//
//  Created by imac on 15/4/10.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//
//
//#import "AsyImageView.h"
//#import "HttpConnection.h"
//#import "MediaCache.h"
//#import "MediaModel.h"
//#import <ImageIO/ImageIO.h>
//
//@interface AsyImageView(){
//    CGRect frame_;
//    UIImageView* _imageView;
//    NSURLRequest    *_request;
//    NSURLConnection *_conn;
//    CGImageSourceRef _incrementallyImgSource;
//    NSMutableData   *_recieveData;
//    long long       _expectedLeght;
//    bool            _isLoadFinished;
//}
//@end
//@implementation AsyImageView
//static  NSMutableDictionary* waiting=nil;
//static  NSMutableDictionary* imageCache=nil;
//static NSLock* _lock;
//-(id)init{
//    self=[super init];
//    if(self){
//        static dispatch_once_t onceToken ;
//        dispatch_once(&onceToken, ^{
//            waiting=[NSMutableDictionary new];
//            imageCache=[NSMutableDictionary new];
//            _lock=[NSLock new];
//            //            [[MediaCache shareInstance] deleteDataForEntity:@"MediaModel"];
//        }) ;
//        frame_=CGRectZero;
//    }
//    return self;
//}
//-(id)initWithUrl:(NSString*)url{
//    self=[self init];
//    if(self){
//        _url=url;
//    }
//    return self;
//}
//-(id)initWithFrame:(CGRect)frame{
//    self=[self init];
//    if(self){
//        frame_=frame;
//        _imageView.frame=frame;
//        self.view.frame=frame;
//    }
//    return self;
//}
//-(void)loadView{
//    _imageView=[UIImageView new];
//    _imageView.userInteractionEnabled=YES;
//    self.view=_imageView;
//}
//-(UIImage*)getCache{
//    UIImage* image=imageCache[self.url];
//    if(!image){
//        MediaModel* cache=(MediaModel*)[[MediaCache shareInstance] getEntity:@"MediaModel" key:@"url" equal:self.url];
//        if(cache){
//            cache.timeStamp=[NSDate date];
//            [[MediaCache shareInstance] save];
//            image=[UIImage imageWithData:cache.data];
//            [_lock lock];
//            [imageCache setObject:image forKey:self.url];
//            [_lock unlock];
//        }
//    }
//    return nil;
//}
//-(void)setCache:(NSData*)data{
//    //    if(data){
//    //        MediaCache* mediaCache=[MediaCache shareInstance];
//    //        NSDictionary* values=[NSDictionary dictionaryWithObjectsAndKeys:self.url,@"url", data,@"data", @(data.length),@"size",[NSDate date],@"timeStamp",nil];
//    //        [mediaCache addData:values toEntity:@"MediaModel"];
//    //        [_lock lock];
//    //        [imageCache setObject:[UIImage imageWithData:data] forKey:self.url];
//    //        [_lock unlock];
//    //    }
//}
//-(void)getLargeImage{
//    NSMutableArray* wait=waiting[self.url];
//    if(!wait){
//        [_lock lock];
//        [waiting setObject:[NSMutableArray arrayWithObject:self] forKey:self.url];
//        [_lock unlock];
//        _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
//        _conn    = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
//        _incrementallyImgSource = CGImageSourceCreateIncremental(NULL);
//        _recieveData = [[NSMutableData alloc] init];
//        _isLoadFinished = false;
//    }else{
//        [wait addObject:self];
//    }
//}
//-(void)getSmallImage{
//    NSMutableArray* wait=waiting[self.url];
//    if(!wait){
//        [_lock lock];
//        [waiting setObject:[NSMutableArray arrayWithObject:self] forKey:self.url];
//        [_lock unlock];
//        [[HttpConnection new]startWithUrl:self.url params:nil block:^(NSData* data){
//            if([data isKindOfClass:[NSData class]]){
//                [self setCache:data];
//                NSMutableArray* wait=waiting[self.url];
//                UIImage* image=[self getCache];
//                for (AsyImageView* item in wait) {
//                    item.image = image;
//                }
//                [_lock lock];
//                [waiting removeObjectForKey:self.url];
//                [_lock unlock];
//            }
//        }];
//    }else{
//        [wait addObject:self];
//    }
//    
//}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    //    _url=@"http://img0.ddove.com/upload/20100713/130127546146.jpg";
//    //    [self getLargeImage];
//    if(self.url){
//        UIImage* image=[self getCache];
//        if(image){
//            self.image=image;
//        }
//        else{
//            [self getSmallImage];
//        }
//    }
//}
//-(UIImage*)image{
//    return _imageView.image;
//}
//-(void)setImage:(UIImage *)image{
//    if(image){
//        if(frame_.size.width==0&&frame_.size.height==0){
//            [_imageView sizeToFit];
//        }
//        else if(frame_.size.height==0){
//            _imageView.frame=CGRectMake(frame_.origin.x, frame_.origin.y, frame_.size.width, frame_.size.width*image.size.height/image.size.width);
//        }
//        else if(frame_.size.width==0){
//            _imageView.frame=CGRectMake(frame_.origin.x, frame_.origin.y, frame_.size.height*image.size.width/image.size.height, frame_.size.height);
//        }else{
//            _imageView.frame=frame_;
//        }
//        _imageView.image=image;
//    }
//}
//-(void)didReceiveMemoryWarning{
//    [imageCache removeAllObjects];
//    self.image=nil;
//}
//#pragma mark -
//#pragma mark NSURLConnectionDataDelegate
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    _expectedLeght = response.expectedContentLength;
//    NSLog(@"expected Length: %lld", _expectedLeght);
//    
//    NSString *mimeType = response.MIMEType;
//    NSLog(@"MIME TYPE %@", mimeType);
//    
//    NSArray *arr = [mimeType componentsSeparatedByString:@"/"];
//    if (arr.count < 1 || ![[arr objectAtIndex:0] isEqual:@"image"]) {
//        NSLog(@"not a image url");
//        [connection cancel];
//        _conn = nil;
//    }
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    NSLog(@"Connection %@ error, error info: %@", connection, error);
//    CFRelease(_incrementallyImgSource);
//    _recieveData=nil;
//    [_lock lock];
//    [waiting removeObjectForKey:self.url];
//    [_lock unlock];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSLog(@"Connection Loading Finished!!!");
//    
//    // if download image data not complete, create final image
//    if (!_isLoadFinished) {
//    }
//    CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)_recieveData, _isLoadFinished);
//    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
//    NSMutableArray* wait=waiting[self.url];
//    UIImage* image=[UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    for (AsyImageView* item in wait) {
//        item.image = image;
//    }
//    CFRelease(_incrementallyImgSource);
//    _recieveData=nil;
//    [_lock lock];
//    [waiting removeObjectForKey:self.url];
//    [_lock unlock];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [_recieveData appendData:data];
//    CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)_recieveData, _isLoadFinished);
//    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
//    self.image=[UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    _isLoadFinished = false;
//    if (_expectedLeght == _recieveData.length) {
//        _isLoadFinished = true;
//        NSMutableArray* wait=waiting[self.url];
//        [wait removeObject:self];
//    }
//}
//
//@end



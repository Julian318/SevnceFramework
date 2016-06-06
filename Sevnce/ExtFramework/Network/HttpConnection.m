#import <UIKit/UIKit.h>
#import "HttpConnection.h"
#import "Reachability.h"
//#import "AFNetworkReachabilityManager.h"
static Reachability* reach;
static NSString *host=@"";
static id preHandleData;
#define boundary @"AaB03x"
@interface HttpConnection()<NSURLSessionDelegate>{
    Boolean (^callback) (id data);
    Boolean (^handleData) (id data,NSDictionary* request);
    NSMutableDictionary* callbackBlocks;
    NSLock* lock;
}
@end
@implementation HttpConnection
static NSURLSession *defaultSession=nil;
static  HttpConnection* _instance=nil;
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance ;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [HttpConnection shareInstance] ;
}
+(id)new{
    return [HttpConnection shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [HttpConnection shareInstance] ;
}
-(id)init{
    if(_instance)return _instance;
    self=[super init];
    if(self){
        static dispatch_once_t onceToken ;
        dispatch_once(&onceToken, ^{
            defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: self delegateQueue: [NSOperationQueue mainQueue]];
            callbackBlocks=[NSMutableDictionary new];
            lock=[NSLock new];
        }) ;
    }
    return self;
}
+(void)initNetworkStatusWithHost:(NSString*)serverUrl handler:(id)block{
    host=serverUrl;
    preHandleData=block;
    reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"network connected");
        });
    };
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"disconnected");
        });
    };
    
    [reach startNotifier];
//    reachabilityManager=[AFNetworkReachabilityManager managerForAddress:(__bridge const void *)(serverUrl)];
}

- (void)setHosts:(NSString *)hosts
{
    host = hosts;
}

+(BOOL)isNetworkConnected{
    return reach.isReachable;
}

-(NSURLSessionTask*)startWithUrl:(NSString*)url params:(NSDictionary*)para block:(id)block{
    if(![url hasPrefix:host]&&![url hasPrefix:@"http"]){
        url=[NSString stringWithFormat:@"%@%@",host,url];
    }
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionTask* task;
    if(para){
        [urlRequest setHTTPMethod:@"POST"];
        urlRequest.timeoutInterval=30;
        Boolean hasFile=NO;
        for (NSString* key in [para allKeys]) {
            if([[para objectForKey:key] isKindOfClass:[NSURL class]]){
                hasFile=YES;
                break;
            }
        }
        if(hasFile){
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; keep-alive; charset=utf-8;boundary=%@", boundary];
            NSString *connection = [NSString stringWithFormat:@"keep-alive"];
            [urlRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
            [urlRequest setValue:connection forHTTPHeaderField:@"connection"];
            task = [defaultSession uploadTaskWithRequest:urlRequest fromData:[self setBodydata:para]];
        }else{
            NSMutableString * params =[[NSMutableString alloc]init];
            for (NSString* key in [para allKeys]) {
                [params appendString:[NSString stringWithFormat:@"%@=%@&",key,[para objectForKey:key]]];
            }
//            params=[NSMutableString stringWithString:[[EmojiConvertor new]convertEmojiSoftbankToUnicode:params]];
            [params appendString:[NSString stringWithFormat:@"%@=%@",@"timestamp",[NSDate new]]];
            [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
            task = [defaultSession dataTaskWithRequest:urlRequest];
        }
    }else{
        task = [defaultSession downloadTaskWithRequest:urlRequest];
    }
    NSMutableDictionary* request;
    if(block){
        request=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"data",url,@"url",block,@"block",para,@"para", nil];
    }else{
        request=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"data",url,@"url",para,@"para", nil];
    }
    [lock lock];
    [callbackBlocks setObject:request forKey:@(task.taskIdentifier)];
    [lock unlock];
    [task resume];
    return task;
}

-(NSURLSessionTask*)startWithUrlForNoFile:(NSString*)url params:(NSDictionary*)para block:(id)block
{
    if(![url hasPrefix:host]&&![url hasPrefix:@"http"]){
        url=[NSString stringWithFormat:@"%@%@",host,url];
    }
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionTask* task;
    if(para){
        [urlRequest setHTTPMethod:@"POST"];
        urlRequest.timeoutInterval=30;
        Boolean hasFile=NO;
        for (NSString* key in [para allKeys]) {
            if([[para objectForKey:key] isKindOfClass:[NSURL class]]){
                hasFile=YES;
                break;
            }
        }
        if(hasFile){
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; keep-alive; charset=utf-8;boundary=%@", boundary];
            NSString *connection = [NSString stringWithFormat:@"keep-alive"];
            [urlRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
            [urlRequest setValue:connection forHTTPHeaderField:@"connection"];
            task = [defaultSession uploadTaskWithRequest:urlRequest fromData:[self setBodydata:para]];
        }else{
//            NSMutableString * params =[[NSMutableString alloc]init];
//            for (NSString* key in [para allKeys]) {
//                [params appendString:[NSString stringWithFormat:@"%@=%@&",key,[para objectForKey:key]]];
//            }
//            //            params=[NSMutableString stringWithString:[[EmojiConvertor new]convertEmojiSoftbankToUnicode:params]];
//            [params appendString:[NSString stringWithFormat:@"%@=%@",@"timestamp",[NSDate new]]];
//            [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
//            task = [defaultSession dataTaskWithRequest:urlRequest];
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; keep-alive; charset=utf-8;boundary=%@", boundary];
            NSString *connection = [NSString stringWithFormat:@"keep-alive"];
            [urlRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
            [urlRequest setValue:connection forHTTPHeaderField:@"connection"];
            task = [defaultSession uploadTaskWithRequest:urlRequest fromData:[self setBodydata:para]];
        }
    }else{
        task = [defaultSession downloadTaskWithRequest:urlRequest];
    }
    NSMutableDictionary* request;
    if(block){
        request=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"data",url,@"url",block,@"block",para,@"para", nil];
    }else{
        request=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"data",url,@"url",para,@"para", nil];
    }
    [lock lock];
    [callbackBlocks setObject:request forKey:@(task.taskIdentifier)];
    [lock unlock];
    [task resume];
    return task;
}
- (NSData *)setBodydata:(NSDictionary *)para
{
    NSMutableString *bodyString;
    NSMutableData *bodyData = [NSMutableData data];
    NSData *fileData;
    for (NSString* key in [para allKeys]) {
        bodyString = [[NSMutableString alloc] init];
        [bodyString appendFormat:@"--%@\r\n", boundary];
        if([[para objectForKey:key] isKindOfClass:[NSURL class]]){
            NSURL* file=[para objectForKey:key];
//            sb1.append("Content-Disposition: form-data; name=\""
//                       + file.getKey() + "\"; filename=\"" + file.getValue().getName() + "\""
//                       + LINEND);
            [bodyString appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",key,key];
            [bodyString appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
            fileData = [NSData dataWithContentsOfFile:file.path];
            [bodyData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
            [bodyData appendData:fileData];
             [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            [bodyString appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//            [bodyString appendFormat:@"Content-Type: text/plain; charset=UTF-8\r\n"];
            [bodyString appendFormat:@"%@\r\n",[para objectForKey:key]];
            [bodyData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    bodyString = [[NSMutableString alloc] init];
    [bodyString appendFormat:@"--%@\r\n", boundary];
    [bodyString appendFormat:@"Content-Disposition: form-data; name=\"timestamp\"\r\n\r\n"];
    [bodyString appendFormat:@"%@\r\n",[NSDate new]];
    [bodyData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *endStr = [NSString stringWithFormat:@"\r\n--%@--\r\n",boundary];
    //拼接到bodyData最后面
    [bodyData appendData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
    return bodyData;
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSLog(@"### handler 1");
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers
                                                             error:nil];
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary* request=callbackBlocks[@(dataTask.taskIdentifier)];
    if(!result){
        if(!request[@"cache"]){
            request[@"cache"]=[NSMutableData dataWithData:data];
            return;
        }
        NSMutableData* cache=request[@"cache"];
        [cache appendData:data];
 //        request[@"data"]=[NSString stringWithFormat:@"%@",totalData];
        result = [NSJSONSerialization JSONObjectWithData:cache
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
        if(!result){
            NSLog(@"Received String %@",[[NSString alloc] initWithData:cache encoding:NSUTF8StringEncoding]);
            return;
        }
    }
    [request removeObjectForKey:@"cache"];
    [request setObject:result forKey:@"data"];
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    NSMutableDictionary* request=callbackBlocks[@(task.taskIdentifier)];
    if(error == nil)
    {
        NSDictionary* result=request[@"data"];
        if(![result isKindOfClass:[NSDictionary class]])result=nil;
        Boolean dataIsValid=YES;
        if(preHandleData){
            handleData=preHandleData;
            dataIsValid=handleData(result,request);
        }
        callback=request[@"block"];
        if(dataIsValid){
//            if(callback)callback(result[@"data"]);
            if(callback){
                if(result[@"data"])callback(result[@"data"]);
                else callback([NSDictionary new]);
            }
        }else{
            if(callback)callback(nil);
        }
        NSLog(@"Download is Succesfull");
    }
    else{
        callback=request[@"block"];
        if(callback){
            callback(nil);
        }
    }
    [lock lock];
    [callbackBlocks removeObjectForKey:@(task.taskIdentifier)];
    [lock unlock];
}
-(NSURL *)createDirectoryForDownloadItemFromURL:(NSURL *)location
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = urls[0];
    return [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
}
//把文件拷贝到指定路径
-(BOOL) copyTempFileAtURL:(NSURL *)location toDestination:(NSURL *)destination
{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:destination error:NULL];
    [fileManager copyItemAtURL:location toURL:destination error:&error];
    if (error == nil) {
        return true;
    }else{
        NSLog(@"%@",error);
        return false;
    }
}

#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    //下载成功后，文件是保存在一个临时目录的，需要开发者自己考到放置该文件的目录
    NSLog(@"Download success for URL: %@",location.description);
    NSDictionary* request=callbackBlocks[@(downloadTask.taskIdentifier)];
    callback=request[@"block"];
    if(callback){
        callback([NSData dataWithContentsOfFile:[location path]]);
        [[NSFileManager defaultManager] removeItemAtURL:location error:NULL];
    }
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSProgress *progress = [[NSProgress alloc] initWithParent:[NSProgress currentProgress] userInfo:nil];
    progress.totalUnitCount=totalBytesExpectedToWrite;
    progress.completedUnitCount=totalBytesWritten;
    NSLog(@"%@",progress);
    NSMutableDictionary* request=callbackBlocks[@(downloadTask.taskIdentifier)];
    callback=request[@"block"];
    if(callback){
        callback(progress);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    NSProgress *progress = [[NSProgress alloc] initWithParent:[NSProgress currentProgress] userInfo:nil];
    progress.totalUnitCount=totalBytesExpectedToSend;
    progress.completedUnitCount=totalBytesSent;
    NSLog(@"%@",progress);
    NSMutableDictionary* request=callbackBlocks[@(task.taskIdentifier)];
    callback=request[@"block"];
    if(callback){
        callback(progress);
    }
}
@end


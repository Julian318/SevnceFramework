
#import "PostButton.h"
#import "ImageUploader.h"
#import "HttpConnection.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"

@interface PostButton(){
    Boolean isPosting;
}
@end
@implementation PostButton
-(id)init{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
    
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        [self addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)post
{
    if(isPosting)return;
    if(self.delegate&& [self.delegate respondsToSelector:@selector(didBeforePost)]&&![self.delegate didBeforePost]){
        return;
    }
    isPosting=YES;
    if(self.para){
        for (NSString* key in [self.para allKeys]) {
            id value=[self.para objectForKey:key];
            if([value isKindOfClass:[UITextField class]]){
                [self.para setObject:((UITextField*)value).text forKey:key];
            }
            else if([value isKindOfClass:[UITextView class]]){
                [self.para setObject:((UITextView*)value).text forKey:key];
            }
            else if([value isKindOfClass:[ImageUploader class]]){
                UIImageView* _loading=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
                _loading.animationDuration=1;
                _loading.animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"ExtUI.bundle/loading1.png"],[UIImage imageNamed:@"ExtUI.bundle/loading2.png"],[UIImage imageNamed:@"ExtUI.bundle/loading3.png"],[UIImage imageNamed:@"ExtUI.bundle/loading4.png"], nil];
                [SVProgressHUD sharedView].spinnerView=_loading;
                [SVProgressHUD showWithStatus:@"上传图片..."];
                if(((ImageUploader*)value).hasPhoto){
                    [((ImageUploader*)value) uploadWithBlock:^(NSDictionary* json){
                        [SVProgressHUD dismiss];
                        if([self.delegate respondsToSelector:@selector(didAfterUploadImageWithKey:data:)]){
                            [self.delegate didAfterUploadImageWithKey:key data:json];
                        }else{
                            [self.para removeObjectForKey:key];
                        }
//                        [self.para setObject:[json objectForKey:@"url"] forKey:key];
                        isPosting=NO;
                        [self post];
                    }];
                    return;
                }
            }
        }
    }
    if(!self.progress){
        self.progress=[[UIProgressView alloc]initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height)];
        self.progress.progressViewStyle= UIProgressViewStyleDefault;
    }
    [self addSubview:self.progress];
    self.dataCenter=[HttpConnection new];
    if(self.loading){
        [self.loading makeToastActivity];
    }
    [self.dataCenter startWithUrl:self.action params:self.para block:^(id data){
        if(!data){
            [self.loading hideToastActivity];
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查网络连接！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self.progress removeFromSuperview];
            isPosting=NO;
            
        }
        else if([data isKindOfClass:[NSDictionary class]]){
            NSDictionary* json=data;
            [self.progress removeFromSuperview];
            if(self.delegate)[self.delegate postOK:json];
            isPosting=NO;
            [self.loading hideToastActivity];
        }
    }];
}

@end

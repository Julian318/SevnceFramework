//
//  BaseHtmlView.m
//  chongqingzhiye
//
//  Created by crly on 15/10/17.
//  Copyright © 2015年 sevnce. All rights reserved.
//

#import "BaseHtmlView.h"
#import "UIView+Toast.h"
#import "Util.h"

@interface BaseHtmlView ()

@end

@implementation BaseHtmlView
@synthesize htmlTitle;
@synthesize htmlUrl;
@synthesize htmlString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view makeToastActivity];
    
    [self loadWebViewWithUrl];
    [self loadWkWebView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

/**
 *初始化navigationbar
 *
 */
-(void)loadWebViewWithUrl{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = UIColorFromRGB(0xd8a85d,1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = htmlTitle;
    self.navigationItem.titleView = titleLabel;

}

- (void)loadWkWebView
{
    self.WebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, screenwidth, screenheight-64)];
    self.WebView.backgroundColor=[UIColor clearColor];
    self.WebView.allowsBackForwardNavigationGestures = YES;
    self.WebView.navigationDelegate = self;
    [self.WebView setOpaque:NO];
    [self.view addSubview:self.WebView];
    
    if([self.urlType isEqual:@"0"]){
        [self.WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlString]]];
    }else{
        
        [self.WebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:BASEURL]];
        
        
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
//    [self.view makeToastActivity];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
//    [self.view makeToastActivity];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
    [self.view hideToastActivity];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"didFailNavigation");
    [self.view hideToastActivity];
    webView.hidden=YES;
    [self.view makeToast:@"请检查网络连接" duration:2 position:@"center"];
}


//-(void)initTopbar
//{
//    //1设置leftNav
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
//    self.navigationItem.leftBarButtonItem = backItem;
//    
//    self.navigationItem.title=htmlTitle;
//    
//}
//
//-(void)goback{
//    //    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    //    ChoiceViewController *choice=[board instantiateViewControllerWithIdentifier:@"ChoiceViewController"];
//    //    UIWindow *window=[[UIApplication sharedApplication].windows firstObject];
//    //    window.rootViewController=choice;
//    //    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
//
///**
// *webview加载前
// *
// */
//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{//当网页视图被指示载入内容而得到通知。应当返回YES，这样会进行加载。通过导航类型参数可以得到请求发起的原因，可以是以下任意值：
//    //    UIWebViewNavigationTypeLinkClicked
//    //    UIWebViewNavigationTypeFormSubmitted
//    //    UIWebViewNavigationTypeBackForward
//    //    UIWebViewNavigationTypeReload
//    //    UIWebViewNavigationTypeFormResubmitted
//    //    UIWebViewNavigationTypeOther
//    return YES;
//}
//
///**
// *webview开始加载
// *
// */
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    NSLog(@"111111");
//    [self.view makeToastActivity];
//}
///**
// *webview加载完毕
// *
// */
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSLog(@"222222");
//    [self.view hideToastActivity];
//}
///**
// *webview加载失败
// *
// */
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    NSLog(@"333333");
//    [self.view hideToastActivity];
//    webView.hidden=YES;
//    [self.view makeToast:@"请检查网络连接" duration:2 position:@"center"];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

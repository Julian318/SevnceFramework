//
//  BaseHtmlView.h
//  chongqingzhiye
//
//  Created by crly on 15/10/17.
//  Copyright © 2015年 sevnce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface BaseHtmlView : UIViewController<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *WebView;
@property (nonatomic, retain) NSString *htmlUrl;
@property (nonatomic, retain) NSString *htmlTitle;
///0代表url，其它代表是传递的htmlstring
@property(strong ,nonatomic)  NSString *urlType;
@property(strong,nonatomic)  NSString* htmlString;

@end

//
//  FSSVG.h
//  FSInteractiveMap
//
//  Created by Arthur GUIBERT on 22/12/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FSSVGUtils.h"
#import "FSSVGPathElement.h"

@interface FSSVG : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray* paths;
@property (nonatomic) CGRect bounds;

+ (instancetype)svgWithFile:(NSString*)filePath;
+ (instancetype)svgWithData:(NSData*)data;
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

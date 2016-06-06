//
//  FSSVGUtils.h
//  FSInteractiveMap
//
//  Created by Arthur GUIBERT on 24/12/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSSVGUtils : NSObject

+ (NSArray*)parsePoints:(const char *)str;
+ (CGAffineTransform)parseTransform:(NSString*)str;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

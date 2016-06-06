//
//  MapLayer.m
//  IndoorMapDemo
//
//  Created by imac on 15/8/12.
//  Copyright (c) 2015年 silverk. All rights reserved.
//

#import "MapLayer.h"

@implementation MapLayer
-(void)setPath:(CGPathRef)path{
    super.path=path;
    CGRect b =  CGPathGetPathBoundingBox(path);
}

@end

//
//  AsyImageProgressView.m
//  易聚
//
//  Created by imac on 15/5/14.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import "AsyImageProgressView.h"
@interface AsyImageProgressView(){
    CGFloat progress_;
    NSString *progressStr;
    NSMutableDictionary *attributes;
    CGRect rect_;
    CGFloat _angleInterval;
    AsyImageProgressType drawType;
    NSTimer *timer;
}
@end

@implementation AsyImageProgressView
static NSArray* drawTypes;
- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = SDProgressViewBackgroundColor;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}
-(instancetype)initWithType:(AsyImageProgressType)type{
    self=[self init];
    if(self){
        drawType=type;
        if(type==AsyImageProgressTypeLoading){
            timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(changeAngle) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }
    return self;
}
- (void)setCenterProgressText:(NSString *)text
{
    CGFloat xCenter = self.frame.size.width * 0.5;
    CGFloat yCenter = self.frame.size.height * 0.5;
    
    // 判断系统版本
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        CGSize strSize = [text sizeWithAttributes:attributes];
        CGFloat strX = xCenter - strSize.width * 0.5;
        CGFloat strY = yCenter - strSize.height * 0.5;
        [text drawAtPoint:CGPointMake(strX, strY) withAttributes:attributes];
    } else {
        CGSize strSize;
        NSAttributedString *attrStr = nil;
        if (attributes[NSFontAttributeName]) {
            strSize = [text sizeWithFont:attributes[NSFontAttributeName]];
            attrStr = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        } else {
            strSize = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
            attrStr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]}];
        }
        CGFloat strX = xCenter - strSize.width * 0.5;
        CGFloat strY = yCenter - strSize.height * 0.5;
        [attrStr drawAtPoint:CGPointMake(strX, strY)];
    }
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    int w=MIN(newSuperview.bounds.size.width,newSuperview.bounds.size.height);
    self.frame=CGRectMake(0, 0, w, w);
    self.center=CGPointMake(newSuperview.bounds.size.width*0.5, newSuperview.bounds.size.height*0.5);
    
}
-(void)willRemoveSubview:(UIView *)subview{
    if(timer){
        [timer invalidate];
        timer=nil;
    }
}
-(void)refreshProgress:(NSProgress *)progress{
    progress_=(float)(progress.completedUnitCount)/(float)(progress.totalUnitCount);
    progressStr = [NSString stringWithFormat:@"%.0f%s", progress_ * 100, "\%"];
    attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:18 * SDProgressViewFontScale];
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    [self setNeedsDisplay];
}
- (void)changeAngle
{
    _angleInterval += M_PI * 0.08;
    if (_angleInterval >= M_PI * 2) _angleInterval = 0;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    rect_=rect;
    switch (drawType) {
        case AsyImageProgressTypeBall:
            [self drawBall];
            break;
        case AsyImageProgressTypePieLoop:
            [self drawPieLoop];
            break;
        case AsyImageProgressTypePieProgress:
            [self drawPieProgress];
            break;
        case AsyImageProgressTypeTransparentPie:
            [self drawTransparentPie];
            break;
        case AsyImageProgressTypeLoading:
            [self drawLoading];
            break;
        case AsyImageProgressTypeLoop:
        default:
            [self drawLoop];
            break;
    }
    // 进度数字
    [self setCenterProgressText:progressStr];
}
- (void)drawBall
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect_.size.width * 0.5;
    CGFloat yCenter = rect_.size.height * 0.5;
    [[UIColor whiteColor] set];
    
    CGFloat radius = MIN(rect_.size.width * 0.5, rect_.size.height * 0.5) - SDProgressViewItemMargin;
    
    
    CGFloat w = radius * 2 + SDProgressViewItemMargin;
    CGFloat h = w;
    CGFloat x = (rect_.size.width - w) * 0.5;
    CGFloat y = (rect_.size.height - h) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
    CGContextFillPath(ctx);
    
    [[UIColor grayColor] set];
    CGFloat startAngle = M_PI * 0.5 - progress_ * M_PI;
    CGFloat endAngle = M_PI * 0.5 + progress_ * M_PI;
    CGContextAddArc(ctx, xCenter, yCenter, radius, startAngle, endAngle, 0);
    CGContextFillPath(ctx);
}
- (void)drawLoop
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect_.size.width * 0.5;
    CGFloat yCenter = rect_.size.height * 0.5;
    [[UIColor whiteColor] set];
    
    CGContextSetLineWidth(ctx, 15 * SDProgressViewFontScale);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGFloat to = - M_PI * 0.5 + progress_ * M_PI * 2 + 0.05; // 初始值0.05
    CGFloat radius = MIN(rect_.size.width, rect_.size.height) * 0.5 - SDProgressViewItemMargin;
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextStrokePath(ctx);
}
- (void)drawPieLoop
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect_.size.width * 0.5;
    CGFloat yCenter = rect_.size.height * 0.5;
    CGFloat radius = MIN(rect_.size.width * 0.5, rect_.size.height * 0.5) - SDProgressViewItemMargin * 0.2;
    
    // 进度环边框
    [[UIColor grayColor] set];
    CGFloat w = radius * 2 + 1;
    CGFloat h = w;
    CGFloat x = (rect_.size.width - w) * 0.5;
    CGFloat y = (rect_.size.height - h) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
    CGContextStrokePath(ctx);
    
    // 进度环
    [SDProgressViewBackgroundColor set];
    CGContextMoveToPoint(ctx, xCenter, yCenter);
    CGContextAddLineToPoint(ctx, xCenter, 0);
    CGFloat to = - M_PI * 0.5 + progress_ * M_PI * 2 + 0.001; // 初始值
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    // 遮罩
    [SDColorMaker(240, 240, 240, 1) set];
    CGFloat maskW = (radius - 15) * 2;
    CGFloat maskH = maskW;
    CGFloat maskX = (rect_.size.width - maskW) * 0.5;
    CGFloat maskY = (rect_.size.height - maskH) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(maskX, maskY, maskW, maskH));
    CGContextFillPath(ctx);
    
    // 遮罩边框
    [[UIColor grayColor] set];
    CGFloat borderW = maskW + 1;
    CGFloat borderH = borderW;
    CGFloat borderX = (rect_.size.width - borderW) * 0.5;
    CGFloat borderY = (rect_.size.height - borderH) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(borderX, borderY, borderW, borderH));
    CGContextStrokePath(ctx);
}
- (void)drawPieProgress
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect_.size.width * 0.5;
    CGFloat yCenter = rect_.size.height * 0.5;
    
    
    CGFloat radius = MIN(rect_.size.width * 0.5, rect_.size.height * 0.5) - SDProgressViewItemMargin;
    
    // 背景圆
    [SDColorMaker(240, 240, 240, 1) set];
    CGFloat w = radius * 2 + 4;
    CGFloat h = w;
    CGFloat x = (rect_.size.width - w) * 0.5;
    CGFloat y = (rect_.size.height - h) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
    CGContextFillPath(ctx);
    
    // 进程圆
    [SDColorMaker(150, 150, 150, 0.8) set];
    CGContextMoveToPoint(ctx, xCenter, yCenter);
    CGContextAddLineToPoint(ctx, xCenter, 0);
    CGFloat to = - M_PI * 0.5 + progress_ * M_PI * 2 + 0.001; // 初始值
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 1);
    CGContextClosePath(ctx);
    
    CGContextFillPath(ctx);
}
- (void)drawTransparentPie
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect_.size.width * 0.5;
    CGFloat yCenter = rect_.size.height * 0.5;
    
    
    CGFloat radius = MIN(rect_.size.width * 0.5, rect_.size.height * 0.5) - SDProgressViewItemMargin;
    
    // 背景遮罩
    [SDProgressViewBackgroundColor set];
    CGFloat lineW = MAX(rect_.size.width, rect_.size.height) * 0.5;
    CGContextSetLineWidth(ctx, lineW);
    CGContextAddArc(ctx, xCenter, yCenter, radius + lineW * 0.5 + 5, 0, M_PI * 2, 1);
    CGContextStrokePath(ctx);
    
    // 进程圆
    //[SDColorMaker(0, 0, 0, 0.3) set];
    CGContextSetLineWidth(ctx, 1);
    CGContextMoveToPoint(ctx, xCenter, yCenter);
    CGContextAddLineToPoint(ctx, xCenter, 0);
    CGFloat to = - M_PI * 0.5 + progress_ * M_PI * 2 + 0.001; // 初始值
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 1);
    CGContextClosePath(ctx);
    
    CGContextFillPath(ctx);
}
- (void)drawLoading
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect_.size.width * 0.5;
    CGFloat yCenter = rect_.size.height * 0.5;
    [[UIColor lightGrayColor] set];
    
    CGContextSetLineWidth(ctx, 4);
    CGFloat to = - M_PI * 0.06 + _angleInterval; // 初始值0.05
    CGFloat radius = MIN(rect_.size.width, rect_.size.height) * 0.5 - SDProgressViewItemMargin;
    CGContextAddArc(ctx, xCenter, yCenter, radius, _angleInterval, to, 0);
    CGContextStrokePath(ctx);
}

@end

//
//  FSInteractiveMapView.m
//  FSInteractiveMap
//
//  Created by Arthur GUIBERT on 23/12/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "FSInteractiveMapView.h"
#import "FSSVG.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "PulsingHaloLayer.h"
#import "MapLayer.h"

@interface FSInteractiveMapView ()

@property (nonatomic, strong) FSSVG* svg;
@property (nonatomic, strong) NSMutableArray* scaledPaths;
@property (nonatomic) CGRect mapBounds;

@end

@implementation FSInteractiveMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        _scaledPaths = [NSMutableArray array];
        [self setDefaultParameters];
    }
    
    return self;
}

- (void)setDefaultParameters
{
    self.fillColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.strokeColor = [UIColor colorWithWhite:0.6 alpha:1];
}
-(void)renderMap{
    [self computeBounds];
    float scale =1;
    if(self.frame.size.width>0&&self.frame.size.height>0)
        scale=MIN(self.frame.size.width / _mapBounds.size.width, self.frame.size.height / _mapBounds.size.height);
    else if(self.frame.size.width==0&&self.frame.size.height==0){
        self.frame=CGRectMake(0, 0, _mapBounds.size.width, _mapBounds.size.height);
    }
    CGAffineTransform scaleTransform = CGAffineTransformIdentity;
    scaleTransform = CGAffineTransformMakeScale(scale, scale);
    scaleTransform = CGAffineTransformTranslate(scaleTransform,-_mapBounds.origin.x, -_mapBounds.origin.y);
    for (FSSVGPathElement* path in _paths) {
        // Make the map fits inside the frame
        
        UIBezierPath* scaled = [path.path copy];
        [scaled applyTransform:scaleTransform];
        
        MapLayer *shapeLayer = [MapLayer new];
        shapeLayer.path = scaled.CGPath;
        
        // Setting CAShapeLayer properties
        shapeLayer.strokeColor = path.strokeColor?path.strokeColor.CGColor: self.strokeColor.CGColor;
        shapeLayer.fillColor = path.fillColor?path.fillColor.CGColor:self.fillColor.CGColor;
        shapeLayer.lineWidth = path.lineWidth!=0?path.lineWidth: 1;
        path.layer=shapeLayer;
        [self.layer addSublayer:shapeLayer];
        [_scaledPaths addObject:scaled];
        [self addText:path.title toLayer:shapeLayer];
    }
}
#pragma mark - SVG map loading

- (void)loadMap:(NSString*)mapName withColors:(NSDictionary*)colorsDict
{
//    self.contentSize=CGSizeMake(_svg.bounds.size.width, _svg.bounds.size.height);
    _svg = [FSSVG svgWithFile:mapName];
    _paths=_svg.paths;
    float scale =1;
    if(self.frame.size.width>0&&self.frame.size.height>0)
        scale=MIN(self.frame.size.width / _svg.bounds.size.width, self.frame.size.height / _svg.bounds.size.height);
    else if(self.frame.size.width==0&&self.frame.size.height==0){
        self.frame=CGRectMake(0, 0, _svg.bounds.size.width, _svg.bounds.size.height);
    }
    CGAffineTransform scaleTransform = CGAffineTransformIdentity;
    scaleTransform = CGAffineTransformMakeScale(scale, scale);
    scaleTransform = CGAffineTransformTranslate(scaleTransform,-_svg.bounds.origin.x, -_svg.bounds.origin.y);
    for (FSSVGPathElement* path in _paths) {
        // Make the map fits inside the frame
        
        UIBezierPath* scaled = [path.path copy];
        [scaled applyTransform:scaleTransform];
        
        MapLayer *shapeLayer = [MapLayer new];
        shapeLayer.path = scaled.CGPath;
        
        // Setting CAShapeLayer properties
        shapeLayer.strokeColor = self.strokeColor.CGColor;
        shapeLayer.lineWidth = 0.5;
        
        if(path.fill) {
            if(colorsDict && [colorsDict objectForKey:path.identifier]) {
                UIColor* color = [colorsDict objectForKey:path.identifier];
                shapeLayer.fillColor = color.CGColor;
            } else {
                shapeLayer.fillColor = self.fillColor.CGColor;
            }
            
        } else {
            shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        }
        path.layer=shapeLayer;
        [self.layer addSublayer:shapeLayer];
        [_scaledPaths addObject:scaled];
        [self addText:path.title toLayer:shapeLayer];
    }
//    CATextLayer *textLayer = [CATextLayer layer];
//    textLayer.frame = self.bounds;
//    textLayer.contentsScale = [UIScreen mainScreen].scale;
//    [self.layer addSublayer:textLayer];
//    
//    //set text attributes
//    textLayer.alignmentMode = kCAAlignmentJustified;
//    textLayer.wrapped = YES;
//    
//    //choose a font
//    UIFont *font = [UIFont systemFontOfSize:25];
//    
//    //choose some text
//    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing  elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar  leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc  elementum, libero ut porttitor dictum, diam odio congue lacus, vel  fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet  lobortis";
//    
//    //create attributed string
//    NSMutableAttributedString *string = nil;
//    string = [[NSMutableAttributedString alloc] initWithString:text];
//    
//    //convert UIFont to a CTFont
//    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
//    CGFloat fontSize = font.pointSize;
//    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
//    
//    //set text attributes
//    NSDictionary *attribs = @{
//                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
//                              (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
//                              };
//    
//    [string setAttributes:attribs range:NSMakeRange(0, [text length])];
//    attribs = @{
//                (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor,
//                (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
//                (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
//                };
//    [string setAttributes:attribs range:NSMakeRange(6, 5)];
//    
//    //release the CTFont we created earlier
//    CFRelease(fontRef);
//    
//    //set layer text
//    textLayer.string = string;
}
-(void)addIndicatorOnLayer:(CALayer*)layer{
    PulsingHaloLayer* pulse=[PulsingHaloLayer new];
    pulse.bounds=CGRectMake(0, 0, 100, 100);
    pulse.position=layer.position;
    pulse.zPosition=100;
    [layer addSublayer:pulse];
}
-(void)addIndicator:(PulsingHaloLayer*)pulse{
    pulse.zPosition=100;
    [self.layer addSublayer:pulse];
}
-(void)addText:(NSString*)text toLayer:(CAShapeLayer*)layer{
    if(!text)return;
    CGRect frame=CGPathGetPathBoundingBox(layer.path);
    UIFont *font = [UIFont systemFontOfSize:MIN(frame.size.width,frame.size.height)*0.15];
    UILabel* label=[UILabel new];
    label.font=font;
    label.text=text;
    CGSize size=[label sizeThatFits:CGSizeMake(frame.size.width, 0)];
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    textLayer.position=CGPointMake(frame.origin.x+frame.size.width*0.5, frame.origin.y+frame.size.height*0.5);
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:text];
    textLayer.foregroundColor=[[UIColor blackColor] CGColor];
    [layer addSublayer:textLayer];
    textLayer.alignmentMode = kCAGravityCenter;
    textLayer.wrapped = YES;
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
                              (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                              };
    
    [string setAttributes:attribs range:NSMakeRange(0, [text length])];
    textLayer.string=string;
    CFRelease(fontRef);
}
- (void)addMapPath:(FSSVGPathElement*)path
{
    if(!_paths)_paths=[NSMutableArray new];
    [_paths addObject:path];
}

- (void)computeBounds
{
    _mapBounds=CGRectZero;
    _mapBounds.origin.x = MAXFLOAT;
    _mapBounds.origin.y = MAXFLOAT;
    float maxx = -MAXFLOAT;
    float maxy = -MAXFLOAT;
    
    for (FSSVGPathElement* path in _paths) {
        CGRect b =  CGPathGetPathBoundingBox(path.path.CGPath);
        
        if(b.origin.x < _mapBounds.origin.x)
            _mapBounds.origin.x = b.origin.x;
        
        if(b.origin.y < _mapBounds.origin.y)
            _mapBounds.origin.y = b.origin.y;
        
        if(b.origin.x + b.size.width > maxx)
            maxx = b.origin.x + b.size.width;
        
        if(b.origin.y + b.size.height > maxy)
            maxy = b.origin.y + b.size.height;
    }
    
    _mapBounds.size.width = maxx - _mapBounds.origin.x;
    _mapBounds.size.height = maxy - _mapBounds.origin.y;
}

- (void)loadMap:(NSString*)mapName withData:(NSDictionary*)data colorAxis:(NSArray*)colors
{
    [self loadMap:mapName withColors:[self getColorsForData:data colorAxis:colors]];
}

- (NSDictionary*)getColorsForData:(NSDictionary*)data colorAxis:(NSArray*)colors
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:[data count]];
    
    float min = MAXFLOAT;
    float max = -MAXFLOAT;
    
    for (id key in data) {
        NSNumber* value = [data objectForKey:key];
        
        if([value floatValue] > max)
            max = [value floatValue];
        
        if([value floatValue] < min)
            min = [value floatValue];
    }
    
    for (id key in data) {
        NSNumber* value = [data objectForKey:key];
        float s = ([value floatValue] - min) / (max - min);
        float segmentLength = 1.0 / ([colors count] - 1);
        int minColorIndex = MAX(floorf(s / segmentLength),0);
        int maxColorIndex = MIN(ceilf(s / segmentLength), [colors count] - 1);
        
        UIColor* minColor = colors[minColorIndex];
        UIColor* maxColor = colors[maxColorIndex];
        
        s -= segmentLength * minColorIndex;
        
        CGFloat maxColorRed = 0;
        CGFloat maxColorGreen = 0;
        CGFloat maxColorBlue = 0;
        CGFloat minColorRed = 0;
        CGFloat minColorGreen = 0;
        CGFloat minColorBlue = 0;
        
        [maxColor getRed:&maxColorRed green:&maxColorGreen blue:&maxColorBlue alpha:nil];
        [minColor getRed:&minColorRed green:&minColorGreen blue:&minColorBlue alpha:nil];
        
        UIColor* color = [UIColor colorWithRed:minColorRed * (1.0 - s) + maxColorRed * s
                                         green:minColorGreen * (1.0 - s) + maxColorGreen * s
                                          blue:minColorBlue * (1.0 - s) + maxColorBlue * s
                                         alpha:1];
        
        [dict setObject:color forKey:key];
    }
    
    return dict;
}

#pragma mark - Updating the colors and/or the data

- (void)setColors:(NSDictionary*)colorsDict
{
    for(int i=0;i<[_scaledPaths count];i++) {
        FSSVGPathElement* element = _paths[i];
        
        if([self.layer.sublayers[i] isKindOfClass:CAShapeLayer.class] && element.fill) {
            CAShapeLayer* l = self.layer.sublayers[i];
            
            if(element.fill) {
                if(colorsDict && [colorsDict objectForKey:element.identifier]) {
                    UIColor* color = [colorsDict objectForKey:element.identifier];
                    l.fillColor = color.CGColor;
                } else {
                    l.fillColor = self.fillColor.CGColor;
                }
            } else {
                l.fillColor = [[UIColor clearColor] CGColor];
            }
        }
    }
}

- (void)setData:(NSDictionary*)data colorAxis:(NSArray*)colors
{
    [self setColors:[self getColorsForData:data colorAxis:colors]];
}

#pragma mark - Layers enumeration

- (void)enumerateLayersUsingBlock:(void (^)(NSString *, CAShapeLayer *))block
{
    for(int i=0;i<[_scaledPaths count];i++) {
        FSSVGPathElement* element = _paths[i];
        
        if([self.layer.sublayers[i] isKindOfClass:CAShapeLayer.class] && element.fill) {
            CAShapeLayer* l = self.layer.sublayers[i];
            block(element.identifier, l);
        }
    }
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for(int i=0;i<[_scaledPaths count];i++) {
        UIBezierPath* path = _scaledPaths[i];
        if ([path containsPoint:touchPoint])
        {
            FSSVGPathElement* element = _paths[i];
            
            if([self.layer.sublayers[i] isKindOfClass:CAShapeLayer.class] && element.fill) {
                CAShapeLayer* l = self.layer.sublayers[i];
                
                if(_clickHandler) {
                    _clickHandler(element.identifier, l);
                }
            }
        }
    }
}

@end


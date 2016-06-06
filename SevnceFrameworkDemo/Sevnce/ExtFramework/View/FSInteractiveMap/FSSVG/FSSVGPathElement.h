#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FSSVGPathElement : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSString* className;
@property (nonatomic, strong) NSString* tranform;
@property (nonatomic, strong) UIBezierPath* path;
@property (nonatomic, strong) CAShapeLayer* layer;
@property (nonatomic) BOOL fill;
@property (nonatomic) UIColor* strokeColor;
@property (nonatomic) UIColor* fillColor;
@property (nonatomic) float lineWidth;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end

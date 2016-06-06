
#import <UIKit/UIKit.h>
@class FSSVGPathElement,PulsingHaloLayer;
@interface FSInteractiveMapView : UIView

// Graphical properties
@property (nonatomic, strong) UIColor* fillColor;
@property (nonatomic, strong) UIColor* strokeColor;
@property (nonatomic, strong) NSMutableArray* paths;

// Click handler
@property (nonatomic, copy) void (^clickHandler)(NSString* identifier, CAShapeLayer* layer);

// Loading functions
- (void)loadMap:(NSString*)mapName withColors:(NSDictionary*)colorsDict;
- (void)loadMap:(NSString*)mapName withData:(NSDictionary*)data colorAxis:(NSArray*)colors;
- (void)addMapPath:(FSSVGPathElement*)path;
-(void)renderMap;
// Set the colors by element, if you want to make the map dynamic or update the colors
- (void)setColors:(NSDictionary*)colorsDict;
- (void)setData:(NSDictionary*)data colorAxis:(NSArray*)colors;
-(void)addIndicator:(PulsingHaloLayer*)pulse;
// Layers enumeration
- (void)enumerateLayersUsingBlock:(void(^)(NSString* identifier, CAShapeLayer* layer))block;

@end

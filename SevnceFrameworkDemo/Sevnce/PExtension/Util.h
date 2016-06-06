//
//  Util.h
//  chongqingzhiye
//
//  Created by crly on 15/10/14.
//  Copyright © 2015年 sevnce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "UIView+Toast.h"
#import "CustomIOSAlertView.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "AFHTTPRequestOperationManager.h"
#import "CustomIOSAlertView.h"

@interface Util : NSObject

//👇👇👇👇👇👇👇👇👇👇👇👇======================iOS快速开发之常量定义区========================👇👇👇👇👇👇👇👇👇👇👇👇

///屏幕的宽高
#define MAIN_FRAME [[UIScreen mainScreen] bounds]
///屏幕宽
#define screenwidth [UIScreen mainScreen].bounds.size.width
///屏幕高
#define screenheight [UIScreen mainScreen].bounds.size.height
///除去信号区的屏幕的frame
#define Application_Frame  [[UIScreen mainScreen] applicationFrame]
///应用程序的屏幕高度
#define APP_Frame_Height   [[UIScreen mainScreen] applicationFrame].size.height
///应用程序的屏幕宽度
#define App_Frame_Width    [[UIScreen mainScreen] applicationFrame].size.width


///利用RGB值设置颜色:(R,G,B,Alpha值)
#define rgbcolor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
///利用16进制设置颜色:(0x(16进制值)，Alpha值)
#define UIColorFromRGB(rgbValue,ALPHA) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(ALPHA)]

#define FONT_COLOR UIColorFromRGB(0xd8a85d,1)
#define FONT_RED UIColorFromRGB(0xff0d0d,1)
#define FONT_GRAY_TITLE UIColorFromRGB(0x666666,1)
#define FONT_GRAY_CONTENT UIColorFromRGB(0x999286,1)

#define LINE_GRAY [UIColor colorWithRed:231 green:236 blue:241 alpha:1]

///判断设备
#define DEVICE_IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480)
#define DEVICE_IS_IPHONE5S ([[UIScreen mainScreen] bounds].size.height == 568)
#define DEVICE_IS_IPHONE6 ([[UIScreen mainScreen] bounds].size.height == 667)
#define DEVICE_IS_IPHONE6PLUS ([[UIScreen mainScreen] bounds].size.height == 736)

/// View 坐标(x,y)和宽高(width,height)
#define X(v)               (v).frame.origin.x
#define Y(v)               (v).frame.origin.y
#define WIDTH(v)           (v).frame.size.width
#define HEIGHT(v)          (v).frame.size.height
/// 获得控件屏幕的x坐标
#define MinX(v)            CGRectGetMinX((v).frame)
/// 获得控件屏幕的Y坐标
#define MinY(v)            CGRectGetMinY((v).frame)
///横坐标加上到控件中点坐标
#define MidX(v)            CGRectGetMidX((v).frame)
///纵坐标加上到控件中点坐标
#define MidY(v)            CGRectGetMidY((v).frame)
///横坐标加上控件的宽度
#define MaxX(v)            CGRectGetMaxX((v).frame)
///纵坐标加上控件的高度
#define MaxY(v)            CGRectGetMaxY((v).frame)

///设置frame的x,y,width,height
#define CONTRLOS_FRAME(x,y,width,height) CGRectMake(x,y,width,height)

///    系统控件的默认高度
#define kStatusBarHeight   (20.f)
#define kTopBarHeight      (44.f)
#define kBottomBarHeight   (49.f)
#define kCellDefaultHeight (44.f)
#define KstatusBarAndNavigation (64.0)

#define BASEURL @"http://47.88.191.14"

/// 角度和弧度转换
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

///PNG JPG 图片路径
#define PNGPATH(NAME)          [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)          [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME,EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

///加载图片
#define PNGIMAGE(NAME)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE(NAME,EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]
#define IMAGENAMED(NAME)       [UIImage imageNamed:NAME]

///字体大小（常规/粗体）
#define BOLDSYSTEMFONT(FONTSIZE) [UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)     [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME,FONTSIZE)      [UIFont fontWithName:(NAME) size:(FONTSIZE)]

///当前版本
#define FSystenVersion            ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystenVersion            ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion            ([[UIDevice currentDevice] systemVersion])

///app版本号
#define Version [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
///当前语言
#define CURRENTLANGUAGE           ([[NSLocale preferredLanguages] objectAtIndex:0])

/// UIView - viewWithTag 通过tag值获得子视图
#define VIEWWITHTAG(_OBJECT,_TAG)   [_OBJECT viewWithTag : _TAG]

///应用程序的名字
#define AppDisplayName              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

///用于fir.im更新
///帐号的API_token
#define API_TOKEN               @"be5fd0abbfc516d878021348a2bd75cb"
///app bundle id
#define BUNDLE_ID               [[NSBundle mainBundle] bundleIdentifier];
///fir.im 上的app id
#define FIR_APP_ID              @"5732d015748aac3f2400002b"

//👆👆👆👆👆👆👆👆👆👆👆👆👆========================iOS快速开发之常量定义区==========================👆👆👆👆👆👆👆👆👆👆👆👆👆


typedef void (^ReturnAnimationBlock)(void);
@property (nonatomic, copy)ReturnAnimationBlock returnAnimationBlock;
/**
 *事件字符串转NSDate  格式：yyyy-MM-dd hh:mm:ss
 *
 */
+(NSDate*)DateFromString:(NSString*)uiDate;


/**
 *视图添加角标
 *superview: 父视图
 *strBadgeValue: 角标数字
 */
+ (UIView *)addBadgeViewTo:(UIView *)superview withBadgeValue:(NSString *)strBadgeValue;

/**
 *视图移除角标
 *
 */
+(void)removeBadgeValue:(NSArray *)subviews;

/**
 *设置圆角按钮
 *
 */
+(void)setCornersBtn:(UIButton *)btn text:(NSString *)text;

/**
 *设置圆角字符视图
 *
 */
+(void)setCornersTextView:(UITextView *)tv;
/**
 *设置圆角视图
 *
 */
+(void)setCornersView:(UIView *)view;

/**
 *批量设置圆角视图
 *
 */
+(void)setCornersViews:(NSArray *)views borderColor:(UIColor *)borderColor borderWidth:(NSInteger)borderWidth cornerRadius:(NSInteger)cornerRadius;

/**
 *根据文本内容自适应高度
 *
 */
+(void)setTextViewByText:(NSString *)text tv:(UITextView *)tv;


/**
 *根据文本内容自适应高度
 *
 */
+(void)setLabelByText:(NSString *)text tv:(UILabel *)lb;

/**
 *  设置label自适应文本的高度
 *
 */
-(void)setlabelHeight:(NSString *)text font:(UIFont *)font lb:(UILabel *)label;

/**
 *  获取本机语言
 *
 */
+ (NSString*)getPreferredLanguage;

/**
 *  获取用户信息
 *
 */
+(NSDictionary*)getUserInfo;

/*!
@method
@abstract 用于防守得到的data中没有这个字段或者参数为空
@discussion [Util getString:(id)Data];
@param text id
@result String
*/
+ (NSString *)getString:(id)Data;


///把字典对象转换成json对象
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

///设置UIView所有控件不可交互，只有某个控件可以交互
+(void)setUserInteractionInView:(UIView *)currentView without:(UIView *)subView;

///图片局部拉伸,图片名、上距离、左距离、下距离、右距离、模式1:拉伸、模式2:平铺
+(UIImage *)ImageWithCapInsets:(NSString *)ImageName andtop:(CGFloat)Top andleft:(CGFloat)Left andbottom:(CGFloat)Bottom andright:(CGFloat)Right andtype:(NSInteger)Type;

///金额小写转大写
+(NSString *)changetochinese:(NSString *)numstr;

///HTML格式化
+ (NSString *)filterHTML:(NSString *)html;

///将颜色以图片的形式展示
+(UIImage*) createImageWithColor:(UIColor*) color;

/**
 *  给视图添加点击动画
 */
- (void)clickButtonAnimation:(UIView *)view returnAnimation:(ReturnAnimationBlock)block;
/**
 *  获取磁盘总空间大小
 */
+ (CGFloat)diskOfAllSizeMBytes;

/**
 *  获取磁盘可用空间大小
 */
+ (CGFloat)diskOfFreeSizeMBytes;

/**
 *  获取指定路径下某个文件的大小
 */
+ (long long)fileSizeAtPath:(NSString *)filePath;

/**
 *  获取文件夹下所有文件的大小
 */
+ (long long)folderSizeAtPath:(NSString *)folderPath;

/**
 *  获取字符串(或汉字)首字母
 */
+ (NSString *)firstCharacterWithString:(NSString *)string;

/**
 *  将字符串数组按照元素首字母顺序进行排序分组
 */
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array;

/**
 *  获取当前时间
 */
+ (NSString *)currentDateWithFormat:(NSString *)format;

/**
 *  计算上次日期距离现在多久, 如 xx 小时前、xx 分钟前等
 */
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime
                        lastTimeFormat:(NSString *)format1
                         ToCurrentTime:(NSString *)currentTime
                     currentTimeFormat:(NSString *)format2;
+ (NSString *)timeIntervalFromLastTime:(NSDate *)lastTime ToCurrentTime:(NSDate *)currentTime;

/**
 *  判断手机号码格式是否正确
 */
+ (BOOL)valiMobile:(NSString *)mobile;

/**
 *  判断邮箱格式是否正确
 */
+ (BOOL)isAvailableEmail:(NSString *)email;

/**
 *  将十六进制颜色转换为 UIColor 对象
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 *  对图片进行滤镜处理
 */
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;

/**
 *  对图片进行模糊处理
 */
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius;

/**
 *  调整图片饱和度、亮度、对比度
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast;

/**
 *  创建一张实时模糊效果 View (毛玻璃效果)
 */
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame;

/**
 *  全屏截图
 */
+ (UIImage *)shotScreen;

/**
 *   截取一张 view 生成图片
 */
+ (UIImage *)shotWithView:(UIView *)view;

/**
 *  截取view中某个区域生成一张图片
 */
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;

/**
 *  压缩图片到指定尺寸大小
 */
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

/**
 *  压缩图片到指定文件大小
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

/**
 *  获取设备IP地址
 */
+ (NSString *)getIPAddress;

/**
 *  判断字符串中是否含有空格
 */
+ (BOOL)isHaveSpaceInString:(NSString *)string;

/**
 *  判断字符串中是否含有某个字符串
 */
+ (BOOL)isHaveString:(NSString *)string1 InString:(NSString *)string2;

/**
 *  判断字符串中是否含有中文
 */
+ (BOOL)isHaveChineseInString:(NSString *)string;

/**
 *  判断字符串是否都为数字
 */
+ (BOOL)isAllNum:(NSString *)string;

/**
 *  绘制虚线
 */
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color;
///检查更新
+ (void)checkUpdate;
@end

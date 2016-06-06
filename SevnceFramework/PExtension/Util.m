//
//  Util.m
//  chongqingzhiye
//
//  Created by crly on 15/10/14.
//  Copyright © 2015年 sevnce. All rights reserved.
//

#import "Util.h"
#import <UIKit/UIKit.h>

@interface Util ()


@end
@implementation Util

+(NSDate*)DateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

+ (UIView *)addBadgeViewTo:(UIView *)superview withBadgeValue:(NSString *)strBadgeValue
{
    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"" image:nil tag:0];
    item.badgeValue = strBadgeValue;
    NSArray *array = [[NSArray alloc] initWithObjects:item, nil];
    tabBar.items = array;
    //寻找
    for (UIView *viewTab in tabBar.subviews) {
        for (UIView *subview in viewTab.subviews) {
            NSString *strClassName = [NSString stringWithUTF8String:object_getClassName(subview)];
            if ([strClassName isEqualToString:@"UITabBarButtonBadge"] ||
                [strClassName isEqualToString:@"_UIBadgeView"]) {
                //从原视图上移除
                [subview removeFromSuperview];
                //
                [superview addSubview:subview];
                subview.frame = CGRectMake(superview.frame.size.width-15, -5,
                                           subview.frame.size.width, subview.frame.size.height);
                return subview;
            }
        }
    }
    return nil;
}

+(void)removeBadgeValue:(NSArray *)subviews
{
    //
    for (UIView *subview in subviews) {
        NSString *strClassName = [NSString stringWithUTF8String:object_getClassName(subview)];
        if ([strClassName isEqualToString:@"UITabBarButtonBadge"] ||
            [strClassName isEqualToString:@"_UIBadgeView"]) {
            [subview removeFromSuperview];
            break;
        }
    }
}

+(void)setCornersBtn:(UIButton *)btn text:(NSString *)text{
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    btn.layer.borderWidth=1;
    btn.layer.cornerRadius=4;
}

+(void)setCornersTextView:(UITextView *)tv{
    tv.font=[UIFont systemFontOfSize:14];
    tv.textColor=[UIColor blackColor];
    tv.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    tv.layer.borderWidth=1;
    tv.layer.cornerRadius=4;
}

+(void)setCornersView:(UIView *)view{
    
    [view.layer setMasksToBounds:YES];
    view.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    view.layer.borderWidth=1;
    view.layer.cornerRadius=4;
}

/**
 *批量设置圆角视图
 *
 */
+(void)setCornersViews:(NSArray *)views borderColor:(UIColor *)borderColor borderWidth:(NSInteger)borderWidth cornerRadius:(NSInteger)cornerRadius{
    
    for (int i=0; i<views.count; i++) {
        UIView *v=[views objectAtIndex:i];
        [v.layer setMasksToBounds:YES];
        v.layer.borderColor=[borderColor CGColor];
        v.layer.borderWidth=borderWidth;
        v.layer.cornerRadius=cornerRadius;
    }
}

/**
 *根据文本内容自适应高度
 *
 */
+(void)setTextViewByText:(NSString *)text tv:(UITextView *)tv{
    CGRect orgRect=tv.frame;//获取原始UITextView的frame
    CGSize  size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 2000) lineBreakMode:UILineBreakModeWordWrap];
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    tv.frame=orgRect;//重设UITextView的frame
    tv.text=text;
}

/**
 *根据文本内容自适应高度
 *
 */
+(void)setLabelByText:(NSString *)text tv:(UILabel *)lb{
    CGRect orgRect=lb.frame;//获取原始UITextView的frame
    CGSize  size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 2000) lineBreakMode:UILineBreakModeWordWrap];
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    lb.frame=orgRect;//重设UITextView的frame
    lb.text=text;
}

/**
 *  设置label自适应文本的高度
 *
 */
-(void)setlabelHeight:(NSString *)text font:(UIFont *)font lb:(UILabel *)label{
    
    CGRect thisframe=label.frame;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize msize = [text boundingRectWithSize:CGSizeMake(label.frame.size.width, 2000.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGFloat h = ceil(msize.height);//计算出的高度
    thisframe.size.height=h;
    label.frame=thisframe;
}

/**
 *  获取本机语言
 *
 */
+ (NSString*)getPreferredLanguage

{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    NSLog(@"当前语言:%@", preferredLang);
    
    return preferredLang;
    
}

/**
 *  获取用户信息
 *
 */
+(NSDictionary*)getUserInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo_dict=[userDefaults dictionaryForKey:@"UserInfo"];
    return userInfo_dict;
}


//把字典对象转换成json对象
+ (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//设置UIView所有控件不可交互，只有某个控件可以交互

+(void)setUserInteractionInView:(UIView *)currentView without:(UIView *)subView{
    NSArray *subViews = [currentView subviews];
    if (subViews.count >0) {
        for (UIView *view in subViews) {
            if ([self isCurrentView:view contain:subView]) {
                [view setUserInteractionEnabled:YES];
                [self setUserInteractionInView:view without:subView];
            }else{
                [view setUserInteractionEnabled:NO];
            }
            if ([view isKindOfClass:[subView class]]) {
                [view setUserInteractionEnabled:YES];

            }
        }
    }
    [currentView setUserInteractionEnabled:YES];
}
/*!
 * @beirf 用于防守得到的data中没有这个字段或者参数为空
 */

+ (NSString *)getString:(id)Data
{
    NSString *str;
    if (Data == nil || [Data isEqual:NULL]) {
        str = @"";
    }else{
        str = [NSString stringWithFormat:@"%@", Data];
    }
    return str;
}

+(BOOL)isCurrentView:(UIView *)view contain:(UIView *)checkView{

    if ([view.subviews containsObject:checkView]) {
        return YES;
    }
    return NO;
}


///图片局部拉伸,图片名、上距离、左距离、下距离、右距离、模式1:拉伸、模式2:平铺
+(UIImage *)ImageWithCapInsets:(NSString *)ImageName andtop:(CGFloat)Top andleft:(CGFloat)Left andbottom:(CGFloat)Bottom andright:(CGFloat)Right andtype:(NSInteger)Type
{
    UIImage* img=[UIImage imageNamed:ImageName];//原图
    UIEdgeInsets edge=UIEdgeInsetsMake(Top, Left, Bottom, Right);
    //UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
    //UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图
    NSInteger tp;
    if (Type == 1) {
        tp = UIImageResizingModeStretch;
    }else{
        tp = UIImageResizingModeTile;
    }
    
    img= [img resizableImageWithCapInsets:edge resizingMode:tp];
    return img;
}

///金额小写转大写
+(NSString *)changetochinese:(NSString *)numstr
{
    double numberals=[numstr doubleValue];
    NSArray *numberchar = @[@"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖"];
    NSArray *inunitchar = @[@"",@"拾",@"佰",@"仟"];
    NSArray *unitname = @[@"",@"万",@"亿",@"万亿"];
    //金额乘以100转换成字符串（去除圆角分数值）
    NSString *valstr=[NSString stringWithFormat:@"%.2f",numberals];
    NSString *prefix;
    NSString *suffix;
    if (valstr.length<=2) {
        prefix=@"零元";
        if (valstr.length==0) {
            suffix=@"零角零分";
        }
        else if (valstr.length==1)
        {
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[valstr intValue]]];
        }
        else
        {
            NSString *head=[valstr substringToIndex:1];
            NSString *foot=[valstr substringFromIndex:1];
            suffix=[NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[head intValue]],[numberchar objectAtIndex:[foot intValue]]];
        }
    }
    else
    {
        prefix=@"";
        suffix=@"";
        int flag=valstr.length-2;
        NSString *head=[valstr substringToIndex:flag-1];
        NSString *foot=[valstr substringFromIndex:flag];
        if (head.length>13) {
            return@"数值太大（最大支持13位整数），无法处理";
        }
        //处理整数部分
        NSMutableArray *ch=[NSMutableArray array];
        for (int i = 0; i < head.length; i++) {
            NSString * str=[NSString stringWithFormat:@"%x",[head characterAtIndex:i]-'0'];
            [ch addObject:str];
        }
        int zeronum=0;
        
        for (int i=0; i<ch.count; i++) {
            int index=(ch.count -i-1)%4;//取段内位置
            int indexloc=(ch.count -i-1)/4;//取段位置
            if ([[ch objectAtIndex:i] isEqualToString:@"0"]) {
                zeronum++;
            }
            else
            {
                if (zeronum!=0) {
                    if (index!=3) {
                        prefix=[prefix stringByAppendingString:@"零"];
                    }
                    zeronum=0;
                }
                prefix=[prefix stringByAppendingString:[numberchar objectAtIndex:[[ch objectAtIndex:i]intValue]]];
                prefix=[prefix stringByAppendingString:[inunitchar objectAtIndex:index]];
            }
            if (index ==0 && zeronum<4) {
                prefix=[prefix stringByAppendingString:[unitname objectAtIndex:indexloc]];
            }
        }
        prefix =[prefix stringByAppendingString:@"元"];
        //处理小数位
        if ([foot isEqualToString:@"00"]) {
            suffix =[suffix stringByAppendingString:@"整"];
        }
        else if ([foot hasPrefix:@"0"])
        {
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[footch intValue] ]];
        }
        else
        {
            NSString *headch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:0]-'0'];
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[headch intValue]],[numberchar objectAtIndex:[footch intValue]]];
        }
    }
    return [prefix stringByAppendingString:suffix];
}


///HTML格式化
+ (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
//        NSString * regEx = @"<([^>]*)>";
        NSString * regEx = @"\n";
        html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

///将颜色以图片的形式展示
+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  按钮点击动画
 */
- (void)clickButtonAnimation:(UIView *)view returnAnimation:(ReturnAnimationBlock)block{
    
    UIViewAnimationOptions op = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState;
    [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
        [view.layer setValue:@(0.97) forKeyPath:@"transform.scale"];
        view.alpha = 0.85;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
            [view.layer setValue:@(1.008) forKeyPath:@"transform.scale"];
            view.alpha = 0.95;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
                [view.layer setValue:@(1) forKeyPath:@"transform.scale"];
                view.alpha = 1;
            } completion:^(BOOL finished) {
                
                self.returnAnimationBlock = block;
                if (self.returnAnimationBlock) {
                    self.returnAnimationBlock();
                }
                
            
            }];
        }];
    }];

}


//磁盘总空间
+ (CGFloat)diskOfAllSizeMBytes{
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager]attributesOfFileSystemForPath:NSHomeDirectory()error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"error: %@", error.localizedDescription);
#endif
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}

//磁盘可用空间
+ (CGFloat)diskOfFreeSizeMBytes{
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager]attributesOfFileSystemForPath:NSHomeDirectory()error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"error: %@", error.localizedDescription);
#endif
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemFreeSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}

//获取文件大小
+ (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) return 0;
    return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
}

//获取文件夹下所有文件的大小
+ (long long)folderSizeAtPath:(NSString *)folderPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *filesEnumerator = [[fileManager subpathsAtPath:folderPath]objectEnumerator];
    NSString *fileName;
    long long folerSize = 0;
    while ((fileName = [filesEnumerator nextObject]) != nil) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        folerSize += [self fileSizeAtPath:filePath];
    }
    return folerSize;
}

//获取字符串(或汉字)首字母
+ (NSString *)firstCharacterWithString:(NSString *)string{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pingyin = [str capitalizedString];
    return [pingyin substringToIndex:1];
}

//将字符串数组按照元素首字母顺序进行排序分组
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array{
    if (array.count == 0) {
        return nil;
    }
    for (id obj in array) {
        if (![obj isKindOfClass:[NSString class]]) {
            return nil;
        }
    }
    UILocalizedIndexedCollation *indexedCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:indexedCollation.sectionTitles.count];
    //创建27个分组数组
    for (int i = 0; i < indexedCollation.sectionTitles.count; i++) {
        NSMutableArray *obj = [NSMutableArray array];
        [objects addObject:obj];
    }
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:objects.count];
    //按字母顺序进行分组
    NSInteger lastIndex = -1;
    for (int i = 0; i < array.count; i++) {
        NSInteger index = [indexedCollation sectionForObject:array[i]collationStringSelector:@selector(uppercaseString)];
        [[objects objectAtIndex:index]addObject:array[i]];
        lastIndex = index;
    }
    //去掉空数组
    for (int i = 0; i < objects.count; i++) {
        NSMutableArray *obj = objects[i];
        if (obj.count == 0) {
            [objects removeObject:obj];
        }
    }
    //获取索引字母
    for (NSMutableArray *obj in objects) {
        NSString *str = obj[0];
        NSString *key = [self firstCharacterWithString:str];
        [keys addObject:key];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:objects forKey:keys];
    return dic;
}

//获取当前时间
//format: @"yyyy-MM-dd HH:mm:ss"、@"yyyy年MM月dd日 HH时mm分ss秒"
+ (NSString *)currentDateWithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}

/**
 *  计算上次日期距离现在多久
 *
 *  @param lastTime    上次日期(需要和格式对应)
 *  @param format1     上次日期格式
 *  @param currentTime 最近日期(需要和格式对应)
 *  @param format2     最近日期格式
 *
 *  @return xx分钟前、xx小时前、xx天前
 */
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime
                        lastTimeFormat:(NSString *)format1
                         ToCurrentTime:(NSString *)currentTime
                     currentTimeFormat:(NSString *)format2{
    //上次时间
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    dateFormatter1.dateFormat = format1;
    NSDate *lastDate = [dateFormatter1 dateFromString:lastTime];
    //当前时间
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    dateFormatter2.dateFormat = format2;
    NSDate *currentDate = [dateFormatter2 dateFromString:currentTime];
    return [Util timeIntervalFromLastTime:lastDate ToCurrentTime:currentDate];
}

+ (NSString *)timeIntervalFromLastTime:(NSDate *)lastTime ToCurrentTime:(NSDate *)currentTime{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    //上次时间
    NSDate *lastDate = [lastTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:lastTime]];
    //当前时间
    NSDate *currentDate = [currentTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:currentTime]];
    //时间间隔
    NSInteger intevalTime = [currentDate timeIntervalSinceReferenceDate] - [lastDate timeIntervalSinceReferenceDate];
    
    //秒、分、小时、天、月、年
    NSInteger minutes = intevalTime / 60;
    NSInteger hours = intevalTime / 60 / 60;
    NSInteger day = intevalTime / 60 / 60 / 24;
    NSInteger month = intevalTime / 60 / 60 / 24 / 30;
    NSInteger yers = intevalTime / 60 / 60 / 24 / 365;
    
    if (minutes <= 10) {
        return  @"刚刚";
    }else if (minutes < 60){
        return [NSString stringWithFormat: @"%ld分钟前",(long)minutes];
    }else if (hours < 24){
        return [NSString stringWithFormat: @"%ld小时前",(long)hours];
    }else if (day < 30){
        return [NSString stringWithFormat: @"%ld天前",(long)day];
    }else if (month < 12){
        NSDateFormatter * df =[[NSDateFormatter alloc]init];
        df.dateFormat = @"M月d日";
        NSString * time = [df stringFromDate:lastDate];
        return time;
    }else if (yers >= 1){
        NSDateFormatter * df =[[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy年M月d日";
        NSString * time = [df stringFromDate:lastDate];
        return time;
    }
    return @"";
}

//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" "withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

//利用正则表达式验证
+ (BOOL)isAvailableEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//将十六进制颜色转换为 UIColor 对象
+ (UIColor *)colorWithHexString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip "0X" or "#" if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString]scanHexInt:&r];
    [[NSScanner scannerWithString:gString]scanHexInt:&g];
    [[NSScanner scannerWithString:bString]scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)green:((float) g / 255.0f)blue:((float) b / 255.0f)alpha:1.0f];
}

#pragma mark - 对图片进行滤镜处理
// 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:name];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}

#pragma mark - 对图片进行模糊处理
// CIGaussianBlur ---> 高斯模糊
// CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
// CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
// CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
// CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter;
    if (name.length != 0) {
        filter = [CIFilter filterWithName:name];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        if (![name isEqualToString:@"CIMedianFilter"]) {
            [filter setValue:@(radius)forKey:@"inputRadius"];
        }
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
        UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return resultImage;
    }else{
        return nil;
    }
}

/**
 *  调整图片饱和度, 亮度, 对比度
 *
 *  @param image      目标图片
 *  @param saturation 饱和度
 *  @param brightness 亮度: -1.0 ~ 1.0
 *  @param contrast   对比度
 *
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    [filter setValue:@(saturation)forKey:@"inputSaturation"];
    [filter setValue:@(brightness)forKey:@"inputBrightness"];
    [filter setValue:@(contrast)forKey:@"inputContrast"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}

//Avilable in iOS 8.0 and later
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    effectView.frame = frame;
    return effectView;
}

//全屏截图
+ (UIImage *)shotScreen{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContext(window.bounds.size);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//截取view生成一张图片
+ (UIImage *)shotWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self shotWithView:view].CGImage, scope);
    UIGraphicsBeginImageContext(scope.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, scope.size.width, scope.size.height);
    CGContextTranslateCTM(context, 0, rect.size.height);//下移
    CGContextScaleCTM(context, 1.0f, -1.0f);//上翻
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    CGContextRelease(context);
    return image;
}

//压缩图片到指定尺寸大小
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage *resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length/1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}

//获取设备 IP 地址
//+ (NSString *)getIPAddress {
//    NSString *address = @"error";
//    struct ifaddrs*interfaces = NULL;
//    struct ifaddrs*temp_addr = NULL;
//    int success = 0;
//    success = getifaddrs(&interfaces);
//    if (success == 0) {
//        temp_addr = interfaces;
//        while(temp_addr != NULL) {
//            if(temp_addr->ifa_addr->sa_family == AF_INET) {
//                if([[NSString stringWithUTF8String:temp_addr->ifa_name]isEqualToString:@"en0"]) {
//                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in*)temp_addr->ifa_addr)->sin_addr)];
//                }
//            }
//            temp_addr = temp_addr->ifa_next;
//        }
//    }
//    freeifaddrs(interfaces);
//    return address;
//}

+ (BOOL)isHaveSpaceInString:(NSString *)string{
    NSRange _range = [string rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL)isHaveString:(NSString *)string1 InString:(NSString *)string2{
    NSRange _range = [string2 rangeOfString:string1];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL)isHaveChineseInString:(NSString *)string{
    for(NSInteger i = 0; i < [string length]; i++){
        int a = [string characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

/*
 ** lineFrame:     虚线的 frame
 ** length:        虚线中短线的宽度
 ** spacing:       虚线中短线之间的间距
 ** color:         虚线中短线的颜色
 */
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color{
    UIView *dashedLine = [[UIView alloc]initWithFrame:lineFrame];
    dashedLine.backgroundColor = [UIColor clearColor];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:dashedLine.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(dashedLine.frame) / 2, CGRectGetHeight(dashedLine.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:color.CGColor];
    [shapeLayer setLineWidth:CGRectGetHeight(dashedLine.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:length], [NSNumber numberWithInt:spacing], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(dashedLine.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [dashedLine.layer addSublayer:shapeLayer];
    return dashedLine;
}

///检查更新
+ (void)checkUpdate
{
    NSString *api_token = API_TOKEN;
    NSString *bundle_id = BUNDLE_ID;
    NSString *user_id = FIR_APP_ID;
    
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"http://api.fir.im/apps/latest/%@?api_token=%@&type=ios",bundle_id,api_token];
    
    // 3.发送GET请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"%@",responseObject);
         
         NSString *versionShort = responseObject[@"versionShort"];
         NSString *appVersion = Version;
         if (![appVersion isEqual:versionShort]) {
             
             CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
             
             [alertView setContainerView:[self AlertView]];
             
             [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
             
             [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                 NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
                 if (buttonIndex==0) {//取消
                     NSLog(@"1");
                 }
                 else if (buttonIndex==1){//确定
                     NSLog(@"2");
                     
                     // 1.获得请求管理者
                     AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
                     
                     // 2.封装请求参数
                     NSMutableDictionary *params = [NSMutableDictionary dictionary];
                     //    params[@"id"] = @"5732d015748aac3f2400002b";
                     //    params[@"bundle_id"] = @"com.sevnce.app.ZonJo";
                     //    params[@"api_token"] = @"be5fd0abbfc516d878021348a2bd75cb";
                     //    params[@"type"] = @"ios";
                     
                     NSString *url = [NSString stringWithFormat:@"http://api.fir.im/apps/%@/download_token?api_token=%@",user_id,api_token];
                     
                     // 3.发送GET请求
                     [mgr GET:url parameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          NSLog(@"%@",responseObject);
                          
                          // 1.获得请求管理者
                          AFHTTPRequestOperationManager *mgrs = [AFHTTPRequestOperationManager manager];
                          NSString *url = [NSString stringWithFormat:@"http://download.fir.im/apps/%@/install?download_token=%@",user_id,responseObject[@"download_token"]];
                          
                          // 3.发送GET请求
                          [mgrs POST:url parameters:params
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSLog(@"%@",responseObject);
                                 NSString *url = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://fir.im/plists/%@",responseObject[@"url"]];
                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                                 exit(0);
                                 
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 NSLog(@"%@",error);
                             }];
                          
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"%@",error);
                      }];
                     
                 }
                 
             }];
             
             [alertView setUseMotionEffects:true];
             
             [alertView show];
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@",error);
     }];
}

///提示View
+(UIView *)AlertView{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 100)];
    //    view.backgroundColor = [UIColor blueColor];
    UILabel *ti = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, WIDTH(view), 28)];
    ti.text = @"提示";
    ti.font = SYSTEMFONT(23);
    ti.textAlignment = NSTextAlignmentCenter;
    [view addSubview:ti];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(ti)+14, WIDTH(view), 28)];
    label.text = @"有新版本更新!";
    label.font = SYSTEMFONT(17);
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    return view;
}



@end

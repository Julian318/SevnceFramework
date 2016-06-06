//
//  LSPageScrollView.m
//  LSPageControl
//
//  Created by  sen on 15/8/28.
//  Copyright (c) 2015年  sen. All rights reserved.
//

#import "LSPageScrollView.h"

@implementation LSPageScrollView
{
    UIScrollView* myscrollview;
    
    UIView* pagecontrolview;
    
    NSMutableArray* markimgs;
    
    UIView* pagebgview;
    UIImageView* moveMark;
    
    NSInteger _num;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame numberOfItem:(NSInteger)num itemSize:(CGSize)itemsize complete:(blockAllItems)allitems{
    
    self = [super initWithFrame:frame];
    if (self) {
        //
        _num = num;
        myscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        myscrollview.backgroundColor = [UIColor lightGrayColor];
        myscrollview.scrollsToTop = NO;
        myscrollview.showsHorizontalScrollIndicator = NO;
        myscrollview.delegate = self;
        myscrollview.pagingEnabled = YES;
        [self addSubview:myscrollview];

        //
        NSMutableArray* items = [NSMutableArray array];
        for (int i = 0; i<num; i++) {
            // 初始随自己意愿 imageView或者button
            UIImageView* imgview = [[UIImageView alloc] initWithFrame:CGRectMake(i*itemsize.width, 0, itemsize.width, itemsize.height)];
            imgview.contentMode = UIViewContentModeScaleAspectFill;
            imgview.userInteractionEnabled = YES;
            imgview.backgroundColor = [self randomColor];
            [myscrollview addSubview:imgview];
            [items addObject:imgview];
        }
        myscrollview.contentSize = CGSizeMake(itemsize.width*num, myscrollview.bounds.size.height);

        allitems(items);

        //page control view
        [self loadPageControlView];
        
    }
    return self;
    
}

- (void)loadPageControlView{
    //
    markimgs = [NSMutableArray array];
    
    pagecontrolview = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
    [self addSubview:pagecontrolview];
    
    //tb3 tb4 jx10
    
    pagebgview = [[UIView alloc] initWithFrame:CGRectZero];
    [pagecontrolview addSubview:pagebgview];
    
    
    //def
    for (int i = 0; i<_num; i++) {
        UIImageView* imgv = [[UIImageView alloc] initWithFrame:CGRectZero];
        imgv.backgroundColor = [UIColor lightGrayColor];
        [pagebgview addSubview:imgv];
        [markimgs addObject:imgv];
    }
    
    //cur
    moveMark = [[UIImageView alloc] initWithFrame:CGRectZero];
    moveMark.backgroundColor = [UIColor blueColor];
    [pagebgview addSubview:moveMark];
    
    [self reloadPageViewSize];
}

- (void)reloadPageViewSize{
    
    CGSize pageSize_def = CGSizeMake(12, 12);
    CGSize pageSize_cur = CGSizeMake(12, 12);
    
    if (_defaultPageIndicatorImage) {
        //
        pageSize_def = _defaultPageIndicatorImage.size;
        
    }
    if (_currentPageIndicatorImage) {
        //
        pageSize_cur = _currentPageIndicatorImage.size;
        
    }
    
    CGFloat bg_w = pageSize_def.width*0.5*_num+PAGECONTROL_jx*(_num-1);
    CGFloat bg_h = pageSize_def.height*0.5;
    
    pagebgview.frame = CGRectMake(CGRectGetMidX(pagecontrolview.frame)-bg_w*0.5, CGRectGetMidY(pagecontrolview.bounds)-bg_h*0.5, bg_w, bg_h);
    
    //def
    for (int i = 0; i<markimgs.count; i++) {
        UIImageView* imgv = (UIImageView*)markimgs[i];
        imgv.frame = CGRectMake(i*(pageSize_def.width*0.5+PAGECONTROL_jx), 0, pageSize_def.width*0.5, pageSize_def.height*0.5);
    }
    
    //cur
    moveMark.frame = CGRectMake(0, 0, pageSize_cur.width*0.5, pageSize_cur.height*0.5);
}

#pragma mark - SET

- (void)setPages:(NSInteger)pages{
    //未实现
    _pages = pages;
    
}

- (void)setShowstyle:(LSPageShowStyle)showstyle{
    //未实现
    _showstyle = showstyle;
    
}

- (void)setPagingEnabled:(BOOL)pagingEnabled{
    _pagingEnabled = pagingEnabled;
    myscrollview.pagingEnabled = _pagingEnabled;
}
- (void)setHiddenPageControl:(BOOL)hiddenPageControl{
    _hiddenPageControl = hiddenPageControl;
    pagecontrolview.hidden = _hiddenPageControl;
    
}

- (void)setDefaultPageIndicatorImage:(UIImage *)defaultPageIndicatorImage{
    _defaultPageIndicatorImage = defaultPageIndicatorImage;
    for (UIImageView* imgv in markimgs) {
        //
        imgv.image = defaultPageIndicatorImage;
        imgv.backgroundColor = [UIColor clearColor];
    }
    [self reloadPageViewSize];
}
- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage{
    
    _currentPageIndicatorImage = currentPageIndicatorImage;
    moveMark.image = currentPageIndicatorImage;
    moveMark.backgroundColor = [UIColor clearColor];
    [self reloadPageViewSize];

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //
    CGFloat scroll_content_w = myscrollview.contentSize.width-myscrollview.bounds.size.width;
    CGFloat scroll_curr_x = scrollView.contentOffset.x;
    
    CGFloat move_content_w = moveMark.superview.bounds.size.width-moveMark.bounds.size.width;
    
    //求当前滑块的x坐标
    CGFloat move_curr_x = move_content_w*scroll_curr_x/scroll_content_w;
    
    moveMark.frame = CGRectMake(move_curr_x, 0, moveMark.frame.size.width, moveMark.frame.size.height);
    
}

- (UIColor *)randomColor {
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        (time(NULL));
    }
//    CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
//    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
//    CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
//    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    return [UIColor whiteColor];
}

@end

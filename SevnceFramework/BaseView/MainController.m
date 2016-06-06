
#import "MainController.h"
#import "Util.h"
@interface MainController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation MainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.delegate=self;
    
    self.navigationController.navigationBar.tintColor=rgbcolor(216, 151, 0, 1);
    self.navigationController.navigationBar.barTintColor=rgbcolor(216, 151, 0, 1);
    NSDictionary * dict=[NSDictionary dictionaryWithObject:rgbcolor(216, 151, 0, 1) forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes=dict;
    //👇透明navigationBar
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"toum"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage imageNamed:@"toum"];

    UIBarButtonItem *backButton=[[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.backBarButtonItem=backButton;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.type = @"cube";
//        transition.type = @"suckEffect";
//        transition.type = @"oglFlip";//不管subType is "fromLeft" or "fromRight",official只有一种效果
//        transition.type = @"rippleEffect";
//        transition.type = @"pageCurl";
//        transition.type = @"pageUnCurl";
//    transition.type = @"cameraIrisHollowOpen ";
//        transition.type = @"cameraIrisHollowClose ";
//        transition.subtype = kCATransitionFromRight;
//        transition.delegate = viewController;
//    [viewController.view.layer addAnimation:transition forKey:nil];
    [super pushViewController:viewController animated:YES];
}

- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果进入的是当前视图控制器
    if (viewController == self) {
        // 背景设置为黑色
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.000];
        // 透明度设置为0.3
        self.navigationController.navigationBar.alpha = 0.300;
        // 设置为半透明
        self.navigationController.navigationBar.translucent = NO;
    } else {
        // 进入其他视图控制器
        self.navigationController.navigationBar.alpha = 0;
        // 背景颜色设置为系统默认颜色

        self.navigationController.navigationBar.translucent = YES;
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if(self.viewControllers.count>1){
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }else{
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}
@end

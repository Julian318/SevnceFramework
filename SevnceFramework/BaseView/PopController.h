#import <UIKit/UIKit.h>
#import "UIColor+QTExtension.h"
#import "UIView+Extension.h"

@interface PopNavbar : UIView{
    UILabel* title_;
}
@property (retain, nonatomic) UIButton* back;
@property (retain, nonatomic) NSString* Title;
@property (retain, nonatomic) UIButton* action;
@property (retain, nonatomic) UIButton* close;
@end
@interface PopController : UIViewController<UITextFieldDelegate,UITextViewDelegate>{
    NSArray* inputs;
    UIToolbar *toolbar;
    UIBarButtonItem *item1;
    UIBarButtonItem *item2;
}
@property (strong, nonatomic) PopNavbar *navBar;
@property (strong, nonatomic) UIView* currentField;
@property CGFloat keybordHeight;
-(void)goBack;
- (void)doAction;
- (void)close;
- (void)needLogin;
@end

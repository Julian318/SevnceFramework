
#import "PopController.h"
#import "RoundedTextView.h"
@implementation PopNavbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor mainbackgroundColor];
        title_ = [[UILabel alloc]init];
        title_.backgroundColor = [UIColor clearColor];
        title_.textColor = [UIColor whiteColor];
        [title_ sizeToFit];
        title_.center = CGPointMake(frame.size.width*0.5, frame.size.height*0.5);
        [self addSubview:title_];
        
        self.back = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.back setImage:[UIImage imageNamed:@"btngoback"] forState:UIControlStateNormal];
        [self.back sizeToFit];
        self.back.center = CGPointMake(self.back.center.x, title_.center.y);
        [self addSubview:self.back];
        
        self.close = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.close setImage:[UIImage imageNamed:@"btnclose"] forState:UIControlStateNormal];
        [self.close sizeToFit];
        self.close.frame=CGRectMake(frame.size.width-self.close.frame.size.width-10, self.close.frame.origin.y, self.close.frame.size.width, self.close.frame.size.height);
        self.close.center=CGPointMake(self.close.center.x, title_.center.y);
        [self addSubview:self.close];
    }
    return self;
}
- (void)setTitle:(NSString *)Title{
    title_.text = Title;
    [title_ sizeToFit];
    title_.frame = CGRectMake(0, 0, MIN(title_.frame.size.width, self.close.Left-self.back.Right), title_.frame.size.height);
    title_.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
}
@end

@interface PopController (){
    Boolean isKeybordShow;
}
@end

@implementation PopController
- (id)init{
    self = [super init];
    if(self){
        self.navBar = [[PopNavbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        [self.navBar.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [self.navBar.close addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
        toolbar = [[UIToolbar alloc]init];
        toolbar.barTintColor = [UIColor mainbackgroundColor];
        item1 = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(prevOnKeyboard:)];
        [item1 setBackgroundImage:[UIImage imageNamed:@"btnnavright"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [item1 setTintColor:[UIColor whiteColor]];
        item2 = [[UIBarButtonItem alloc]initWithTitle:@"下一栏" style:UIBarButtonItemStylePlain target:self action:@selector(nextOnKeyboard:)];
        [item2 setTintColor:[UIColor whiteColor]];
        [item2 setBackgroundImage:[UIImage imageNamed:@"btnnavright"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        toolbar.items = @[item1, [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], item2];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.view addSubview:self.navBar];
//    toolbar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
//    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-  (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillChangeFrame:(NSNotification *)aNotification
{
    isKeybordShow = YES;
    NSDictionary *info = [aNotification userInfo];
}
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    isKeybordShow = YES;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    self.keybordHeight = kbSize.height;
    [self adjustViewPosition];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    isKeybordShow = NO;
    if(self.view.Top == 0)return;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect = CGRectMake(0.0f,0.0f,width,height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    item1.title = textField.placeholder;
    self.currentField = textField;
    if(isKeybordShow)[self adjustViewPosition];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self nextOnKeyboard:textField];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([textView isKindOfClass:[RoundedTextView class]]){
        item1.title = ((RoundedTextView *) textView).placeholder;
    }
    self.currentField = textView;
    if(isKeybordShow)[self adjustViewPosition];
    return YES;
}

- (void)adjustViewPosition{
    CGFloat diff = MIN(self.view.bounds.size.height-self.currentField.Bottom-self.keybordHeight,0);
    if(diff == 0 && self.view.Top == 0) return;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect = CGRectMake(0.0f, diff, width, height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView *view in self.view.subviews) {
        [view resignFirstResponder];
    }
}

- (void)goBack{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:nil userInfo:nil];
}
- (void)close{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"close" object:nil userInfo:nil];
}

- (void)doAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"close" object:nil userInfo:nil];
}
- (void)needLogin{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"needLogin" object:nil userInfo:nil];
}

- (void)handleInput
{
    
}

- (void)prevOnKeyboard:(UIView *)sender
{
    [self handleInput];
    if([sender isKindOfClass:[UIBarButtonItem class]])sender = self.currentField;
    for(long i = inputs.count - 1; i >= 0; i--){
        if(i == 0){
            [inputs[inputs.count - 1] becomeFirstResponder];
            return;
        }
        else if (sender == inputs[i]) {
            [inputs[i-1] becomeFirstResponder];
            return;
        }
    }
}

//点击键盘上的Return按钮响应的方法
- (void)nextOnKeyboard:(UIView *)sender
{
    [self handleInput];
    if([sender isKindOfClass:[UIBarButtonItem class]])sender = self.currentField;
    for(int i = 0; i < inputs.count; i++){
        if(i == inputs.count - 1){
            [inputs[0] becomeFirstResponder];
            return;
        }
        else if (sender == inputs[i]) {
            [inputs[i + 1] becomeFirstResponder];
            return;
        }
    }
}
@end

//
//  LoginViewController.m
//  CityHousekeeper
//
//  Created by yjq on 15/11/18.
//  Copyright © 2015年 com.millenniumStar. All rights reserved.
//

#import "LoginViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "MainTabViewController.h"
#import "MainNavViewController.h"
#import "RegisterViewController.h"
#import "PassWordViewController.h"
#import "NetworkDetermineTool.h"
#import "ZBButten.h"
#import "IQKeyboardManager.h"
@interface LoginViewController ()
@property (weak,  nonatomic) IBOutlet UITextField *nameFie;
@property (weak,  nonatomic) IBOutlet UITextField *passWordFie;
@property (weak,  nonatomic) IBOutlet UITextField *phoneField;
@property (weak,  nonatomic) IBOutlet UITextField *keyField;
@property (weak,  nonatomic) IBOutlet UIView *loginView;
@property (weak,  nonatomic) IBOutlet UIButton *loginBtn;
@property (weak,  nonatomic) IBOutlet ZBButten *codeBtn;
@property (strong,nonatomic) IBOutletCollection(UIView) NSArray *lines;
@property (nonatomic,  copy) NSString *code;
@property (strong,nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *lineHeights;
@property (weak,  nonatomic) IBOutlet NSLayoutConstraint *logWid;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self loadHomeView];
    [_nameFie setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_passWordFie setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_keyField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *token = [AccountTool account].tokenKey;
        if (token.length>0) {
            //指纹验证
            [self authenticateUser];
        }
    });
}

- (void)authenticateUser
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    NSString* result = @"通过验证指纹解锁应用";
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    window.rootViewController = [[MainTabViewController alloc]init];
                 }];
                return;
            }else{
                
            }
        }];
    }else{
        //不支持指纹识别，LOG出错误详情
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *name = [AccountTool account].userName;
    NSString *password = [AccountTool account].password;
    _nameFie.text = name;
    _passWordFie.text = password;
}

- (void)loadHomeView{
    self.loginView.layer.cornerRadius = 5;
    self.loginView.layer.masksToBounds = YES;
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.masksToBounds = YES;
    [self.codeBtn setbuttenfrontTitle:@"" backtitle:@"s后获取"];
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    for (NSLayoutConstraint *wid in self.lineHeights) {
        wid.constant = SDevHeight *10/640;
    }
    self.logWid.constant = SDevWidth *220/320;
    for (UIView *line in self.lines) {
        CAGradientLayer *layer = [CAGradientLayer new];
        layer.colors = @[(__bridge id)[UIColor blackColor].CGColor,(__bridge id)[UIColor lightGrayColor].CGColor, (__bridge id)[UIColor blackColor].CGColor];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(1, 0);
        layer.frame = (CGRect){CGPointZero, CGSizeMake(SDevWidth *220/320, 0.8)};
        [line.layer addSublayer:layer];
    }
}
//获取验证码
- (IBAction)getCode:(UIButton *)btn{
    [self resignFirst];
    if (self.nameFie.text.length==0||self.passWordFie.text==0){
        [NewUIAlertTool show:@"请输入用户名和密码" with:self];
//        SHOWALERTVIEW(@"请输入用户名和密码");
        return;
    }
    [self requestCheckWord];
}

- (void)requestCheckWord{
    NSString *codeUrl = [NSString stringWithFormat:@"%@GetLoginVerifyCodeDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = self.nameFie.text;
    params[@"password"] = self.passWordFie.text;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showMessage:response.message];
        }else{
            [NewUIAlertTool show:response.message with:self];
//            SHOWALERTVIEW(response.message);
        }
    } requestURL:codeUrl params:params];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignFirst];
}

- (IBAction)registerClick:(id)sender {
    [self resignFirst];
    RegisterViewController *regiVC = [[RegisterViewController alloc]init];
    MainNavViewController *naviVC = [[MainNavViewController alloc]initWithRootViewController:regiVC];
    [self presentViewController:naviVC animated:YES completion:nil];
}

- (IBAction)loginClick:(UIButton *)sender {
    if (![NetworkDetermineTool isExistenceNet]) {
        [MBProgressHUD showMessage:@"网络断开、请联网"];
        return;
    }
    [self resignFirst];
    sender.enabled = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = self.nameFie.text;
    params[@"password"] = self.passWordFie.text;
    params[@"phoneCode"] = self.keyField.text;
    NSString *logUrl = [NSString stringWithFormat:@"%@userLoginDo",baseUrl];
    [BaseApi getNoLogGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            params[@"tokenKey"] = response.data[@"tokenKey"];
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[MainTabViewController alloc]init];
        }else{
            NSString *str = response.message?response.message:@"登录失败";
            SHOWALERTVIEW(str);
        }
        sender.enabled = YES;
    } requestURL:logUrl params:params];
}

- (void)resignFirst{
    [self.nameFie resignFirstResponder];
    [self.keyField resignFirstResponder];
    [self.passWordFie resignFirstResponder];
}

- (IBAction)forgotKeyClick:(id)sender {
    [self resignFirst];
    PassWordViewController *passVc = [[PassWordViewController alloc]init];
    passVc.title = @"忘记密码";
    passVc.isForgot = YES;
    MainNavViewController *naviVC = [[MainNavViewController alloc]initWithRootViewController:passVc];
    [self presentViewController:naviVC animated:YES completion:nil];
}

@end

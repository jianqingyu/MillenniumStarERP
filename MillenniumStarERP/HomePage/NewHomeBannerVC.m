//
//  NewHomeBannerVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/26.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewHomeBannerVC.h"
#import "CustomTopBtn.h"
#import "HYBLoopScrollView.h"
#import "ProductListVC.h"
#import "EditUserInfoVC.h"
#import "NakedDriLibViewController.h"
@interface NewHomeBannerVC ()<UINavigationControllerDelegate>
@property (nonatomic,strong)NSArray *photos;
@property (nonatomic,strong)NSArray *bPhotos;
@property (nonatomic, copy) NSString *openUrl;
@property(nonatomic,  copy) NSDictionary *versionDic;
@property (nonatomic,  weak)HYBLoopScrollView *loopView;
@end

@implementation NewHomeBannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewHomeData];
    self.openUrl = @"https://itunes.apple.com/cn/app/千禧之星珠宝2/id1244977034?mt=8";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatBottomBtn];[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)orientChange:(NSNotification *)notification{
    BOOL isDev = SDevWidth>SDevHeight;
    if (isDev) {
        [self setLoopScrollView:self.photos];
    }else{
        [self setLoopScrollView:self.bPhotos];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    [self loadNewVersion];
}

#pragma mark -- 检查新版本
- (void)loadNewVersion{
    NSString *url = [NSString stringWithFormat:@"%@currentVersion",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"device"] = @"ios";
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            self.versionDic = response.data;
            [self loadAlertView];
        }
    } requestURL:url params:params];
}

- (void)loadAlertView{
    double doubleCurrentVersion = [[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]doubleValue];
    if (doubleCurrentVersion<[self.versionDic[@"version"]doubleValue]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:self.versionDic[@"message"] delegate:self
                                             cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:self.openUrl]];
    application = nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)loadNewHomeData{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@IndexPageForQxzx",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"horizontal"]]) {
                self.photos = response.data[@"horizontal"];
            }
            if ([YQObjectBool boolForObject:response.data[@"vertical"]]) {
                self.bPhotos = response.data[@"vertical"];
            }
            BOOL isDev = SDevWidth>SDevHeight;
            if (isDev) {
                [self setLoopScrollView:self.photos];
            }else{
                [self setLoopScrollView:self.bPhotos];
            }
        }
    } requestURL:url params:params];
}

- (void)setLoopScrollView:(NSArray *)arr{
    if (self.loopView) {
        [self.loopView removeFromSuperview];
        self.loopView = nil;
    }
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:
                               CGRectMake(0, 0, SDevWidth, SDevHeight) imageUrls:arr];
    loop.timeInterval = 6.0;
    loop.didSelectItemBlock = ^(NSInteger atIndex,HYBLoadImageView  *sender){
        
    };
    loop.alignment = kPageControlAlignRight;
    [self.view addSubview:loop];
    [self.view sendSubviewToBack:loop];
    self.loopView = loop;
}

- (void)creatBottomBtn{
    CGFloat width = MIN(SDevWidth,SDevHeight)*0.7;
    UIView *bottomV = [UIView new];
    [self.view addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).with.offset(-15);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(@80);
    }];
    CGFloat mar = (width-4*60)/3;
    NSArray *arr = @[@"p_11",@"p_03",@"p_06",@"p_08"];
    NSArray *arrS = @[@"首页",@"产品",@"裸钻库",@"个人中心"];
    for (int i=0; i<arr.count; i++) {
        CustomTopBtn *right = [CustomTopBtn creatCustomView];
        right.bBtn.tag = i;
        [right.sBtn setBackgroundImage:[UIImage imageNamed:arr[i]] forState:
            UIControlStateNormal];
        right.titleLab.text = arrS[i];
        [right.bBtn addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
        right.frame = CGRectMake(i*(60+mar), 0, 60, 80);
        [bottomV addSubview:right];
    }
}

- (void)openClick:(UIView *)btn{
    if (btn.tag==0) {
        [self loadNewHomeData];
    }else if(btn.tag==1){
        ProductListVC *list = [ProductListVC new];
        [self.navigationController pushViewController:list animated:YES];
    }else if(btn.tag==2){
        NakedDriLibViewController *list = [NakedDriLibViewController new];
        [self.navigationController pushViewController:list animated:YES];
    }else{
        EditUserInfoVC *list = [EditUserInfoVC new];
        [self.navigationController pushViewController:list animated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

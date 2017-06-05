//
//  HomePageVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/5.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "HomePageVC.h"
#import "HomeHeadView.h"
#import "EditUserInfoVC.h"
#import "HomePageCollectionCell.h"
#import "ProductListVC.h"
#import "UserInfo.h"
#import "CusTomLoginView.h"
#import "NakedDriLibViewController.h"
@interface HomePageVC ()<UINavigationControllerDelegate,UICollectionViewDataSource,
                                   UICollectionViewDelegate>
@property(strong,nonatomic) UICollectionView * rightCollection;
@property(strong,nonatomic) UserInfo *userInfo;
@property(nonatomic,  weak) HomeHeadView *headView;
@property(nonatomic,  copy) NSArray *list;
@property(nonatomic,  copy) NSDictionary *versionDic;
@property(nonatomic,  weak) UIButton *selBtn;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    [self setHeaderView];
    [self setupFootBtn];
    [self loadHomeData];
}

- (void)viewWillAppear:(BOOL)animated{
    //注册kvo通知
    //[self addObserver:self.tabBarController forKeyPath:@"tabCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
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
    [application openURL:[NSURL URLWithString:self.versionDic[@"url"]]];
    application = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self removeObserver:self.tabBarController forKeyPath:@"tabCount"];
//}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)setHeaderView{
    CGFloat height = MAX(SDevHeight*0.38, 220);
    HomeHeadView *headView = [HomeHeadView view];
    [self.view addSubview:headView];
    self.headView = headView;
    [headView.setBtn addTarget:self action:@selector(setClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(height);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 0.f;//左右间隔
    flowLayout.minimumLineSpacing = 5.0f;
    self.rightCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.rightCollection.backgroundColor = DefaultColor;
    self.rightCollection.delegate = self;
    self.rightCollection.dataSource = self;
    [self.view addSubview:_rightCollection];
    [_rightCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    //设置当数据小于一屏幕时也能滚动
    self.rightCollection.alwaysBounceVertical = YES;
    UINib *nib = [UINib nibWithNibName:@"HomePageCollectionCell" bundle:nil];
    [self.rightCollection registerNib: nib forCellWithReuseIdentifier:@"HomePageCollectionCell"];
}

- (void)setupFootBtn{
    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    footBtn.backgroundColor = DefaultColor;
    [footBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [footBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footBtn];
    [footBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    self.selBtn = footBtn;
}

- (void)btnClick{
    [self loadHomeData];
}

- (void)loadHomeData{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@userAdminPage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"userInfo"]]) {
                self.selBtn.hidden = YES;
                self.userInfo = [UserInfo objectWithKeyValues:response.data[@"userInfo"]];
                self.headView.userInfo = self.userInfo;
                self.tabCount = self.userInfo.mesCount;
            }
            if ([YQObjectBool boolForObject:response.data[@"functionsList"]]) {
                NSArray *arr = response.data[@"functionsList"];
                self.list = arr;
                [self.rightCollection reloadData];
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

#pragma mark--CollectionView-------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageCollectionCell *collcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageCollectionCell" forIndexPath:indexPath];
    collcell.layer.borderWidth = 0.1;
    collcell.layer.borderColor = CUSTOM_COLOR(207, 207, 210).CGColor;
    NSDictionary *dict = self.list[indexPath.row];
    [collcell.image sd_setImageWithURL:dict[@"pic"] placeholderImage:DefaultImage];
    collcell.title.text = dict[@"title"];
    [collcell.title setAdjustsFontSizeToFitWidth:YES];
    return collcell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            ProductListVC*listVc = [[ProductListVC alloc]init];
            listVc.backDict = [NSMutableDictionary new];
            [self.navigationController pushViewController:listVc animated:YES];
        }
            break;
        case 1:{
            NakedDriLibViewController*listVc = [[NakedDriLibViewController alloc]init];
            [self.navigationController pushViewController:listVc animated:YES];
        }
        default:
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (SDevWidth-0.8)/4;
    return CGSizeMake(width, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0.1, 0.1, 0.1, 0.1);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
                     minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.001f;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
                          minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.001f;
}

- (void)setClick:(id)sender{
    EditUserInfoVC *infoVc = [[EditUserInfoVC alloc]init];
    infoVc.url = self.userInfo.headPic;
    infoVc.editBack = ^(id isSel){
        self.userInfo.headPic = isSel;
        [self.headView.titleImg sd_setImageWithURL:[NSURL URLWithString:isSel] placeholderImage:DefaultImage];
    };
    [self.navigationController pushViewController:infoVc animated:YES];
}

@end

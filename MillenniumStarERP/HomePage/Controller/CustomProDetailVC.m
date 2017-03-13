//
//  CustomProDetailVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/13.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "CustomProDetailVC.h"
#import "ConfirmOrderVC.h"
#import "CustomFirstCell.h"
#import "CustomProCell.h"
#import "CustomLastCell.h"
#import "CusDetailHeadView.h"
#import "RemarkPopView.h"
#import "CustomPopView.h"
#import "DetailTextCustomView.h"
#import "MWPhotoBrowser.h"
#import "ETFoursquareImages.h"
#import "DetailTypeInfo.h"
#import "DetailModel.h"
#import "DetailTypeInfo.h"
#import "OrderListInfo.h"
#import "DetailHeadInfo.h"
#import "StrWithIntTool.h"
#import "OrderNumTool.h"
#import "CommonUtils.h"
@interface CustomProDetailVC ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate,imageTapDelegate>
@property (nonatomic,  weak) IBOutlet UITableView *tableView;
@property (nonatomic,  weak) IBOutlet UIButton *lookBtn;
@property (nonatomic,  weak) IBOutlet UIButton *addBtn;
@property (nonatomic,  weak) IBOutlet UILabel *numLab;
@property (nonatomic,  copy)NSArray *typeArr;
@property (nonatomic,  copy)NSArray *typeSArr;
@property (nonatomic,  copy)NSArray*chooseArr;
@property (nonatomic,  copy)NSArray*detailArr;
@property (nonatomic,  copy)NSArray*firstArr;
@property (nonatomic,  copy)NSArray*IDarray;
@property (nonatomic,  copy)NSArray*photos;
@property (nonatomic,  copy)NSArray*specTitles;
@property (nonatomic,  copy)NSString*lastMess;
@property (nonatomic,  strong)NSMutableArray*nums;
@property (nonatomic,  strong)NSMutableArray*bools;
@property (nonatomic,  strong)DetailModel *modelInfo;
@property (nonatomic,  strong)CustomPopView *popView;
@property (nonatomic,  strong)RemarkPopView *remarkPopView;
@property (nonatomic,  strong)DetailTextCustomView *textCView;
@property (nonatomic,  weak) ETFoursquareImages *foursquareImages;
@end

@implementation CustomProDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制信息";
    self.numLab.layer.cornerRadius = 8;
    self.numLab.layer.masksToBounds = YES;
    [self.numLab setAdjustsFontSizeToFitWidth:YES];
    if (self.isEdit) {
        [self.lookBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.addBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    self.typeArr = @[@"主   石",@"副石A",@"副石B",@"副石C"];
    self.typeSArr = @[@"stone",@"stoneA",@"stoneB",@"stoneC"];
    self.nums = @[@"",@"",@"",@""].mutableCopy;
    self.bools = @[@YES,@NO,@NO,@NO].mutableCopy;
    [self setupPopView];
    [self setupTextView];
    [self setupRemarkPopView];
    [self setupDetailData];
    [self creatNaviBtn];
    [self creatNearNetView:^(BOOL isWifi) {
        [self setupDetailData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    App;
    [OrderNumTool orderWithNum:app.shopNum andView:self.numLab];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)creatNaviBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 35, 54, 54);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES]; 
}

#pragma mark -- loadData 初始化数据
- (void)setupDetailData{
    [SVProgressHUD show];
    NSString *detail;
    if (self.isEdit==1) {
        detail = @"ModelDetailPageForCurrentOrderEditPage";
    }else if (self.isEdit==2){
        detail = @"ModelOrderWaitCheckModelDetailPageForCurrentOrderEditPage";
    }else{
        detail = @"ModelDetailPage";
    }
    NSString *regiUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSString *proId = self.isEdit?@"itemId":@"id";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[proId] = @(_proId);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"model"]]) {
                DetailModel *modelIn = [DetailModel objectWithKeyValues:
                                                       response.data[@"model"]];
                [self setupBaseListData:modelIn];
                [self creatCusTomHeadView];
                [self.tableView reloadData];
            }
            if ([YQObjectBool boolForObject:response.data[@"stoneType"]]) {
                self.chooseArr = @[response.data[@"stoneType"],
                                   response.data[@"stoneType"],
                                   response.data[@"stoneShape"],
                                   response.data[@"stoneColor"],
                                   response.data[@"stonePurity"]];
            }
            if ([YQObjectBool boolForObject:response.data[@"remarks"]]) {
                self.remarkPopView.typeList = response.data[@"remarks"];
            }
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)setupBaseListData:(DetailModel *)modelIn{
    self.modelInfo = modelIn;
    self.lastMess = modelIn.remark;
    if (self.isEdit) {
        self.firstArr = @[modelIn.number,modelIn.handSize];
    }
    [self setupNumbers:@[modelIn.stone,modelIn.stoneA,
                         modelIn.stoneB,modelIn.stoneC]];
    self.detailArr  = @[[self arrWithDict:modelIn.stone],
                        [self arrWithDict:modelIn.stoneA],
                        [self arrWithDict:modelIn.stoneB],
                        [self arrWithDict:modelIn.stoneC]];
    self.specTitles = @[[self arrWithTitle:modelIn.stone],
                        [self arrWithTitle:modelIn.stoneA],
                        [self arrWithTitle:modelIn.stoneB],
                        [self arrWithTitle:modelIn.stoneC]];
    [self.bools setObject:@(modelIn.isSelfStone) atIndexedSubscript:0];
    [self.bools setObject:[self boolWithStone:modelIn.stoneA] atIndexedSubscript:1];
    [self.bools setObject:[self boolWithStone:modelIn.stoneB] atIndexedSubscript:2];
    [self.bools setObject:[self boolWithStone:modelIn.stoneC] atIndexedSubscript:3];
}

- (void)setupNumbers:(NSArray *)stoneArr{
    for (int i=0; i<stoneArr.count; i++) {
        NSDictionary *dict = stoneArr[i];
        if ([YQObjectBool boolForObject:dict[@"number"]]) {
            NSString *numStr = [dict[@"number"] description];
            [self.nums setObject:numStr atIndexedSubscript:i];
        }
    }
}

- (id)boolWithStone:(NSDictionary *)dict{
    id isStone = @NO;
    if ([YQObjectBool boolForObject:dict[@"stoneOut"]]) {
        isStone = dict[@"stoneOut"];
    }
    return isStone;
}

- (NSString *)arrWithTitle:(NSDictionary *)dict{
    NSString *str;
    if ([YQObjectBool boolForObject:dict[@"specSelectTitle"]]) {
        str = dict[@"specSelectTitle"];
    }
    return str;
}

- (NSMutableArray *)arrWithDict:(NSDictionary *)dict{
    DetailTypeInfo *in1 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"typeTitle"]]) {
        in1.id = [dict[@"typeId"]intValue];
        in1.title = dict[@"typeTitle"];
    }
    DetailTypeInfo *in2 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"specTitle"]]) {
        in2.title = dict[@"specTitle"];
    }
    DetailTypeInfo *in3 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"shapeTitle"]]) {
        in3.id = [dict[@"shapeId"]intValue];
        in3.title = dict[@"shapeTitle"];
    }
    DetailTypeInfo *in4 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"colorTitle"]]) {
        in4.id = [dict[@"colorId"]intValue];
        in4.title = dict[@"colorTitle"];
    }
    DetailTypeInfo *in5 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"purityTitle"]]) {
        in5.id = [dict[@"purityId"]intValue];
        in5.title = dict[@"purityTitle"];
    }
    return @[in1,in2,in3,in4,in5].mutableCopy;
}
#pragma mark - 初始化图片
- (void)creatCusTomHeadView{
    NSMutableArray *pic  = @[].mutableCopy;
    NSMutableArray *mPic = @[].mutableCopy;
    NSMutableArray *bPic = @[].mutableCopy;
    for (NSDictionary*dict in self.modelInfo.pics) {
        NSString *str = dict[@"pic"];
        if (str.length>0) {
            [pic addObject:str];
        }
        NSString *strm = dict[@"picm"];
        if (strm.length>0) {
            [mPic addObject:strm];
        }
        NSString *strb = dict[@"picb"];
        if (strb.length>0) {
            [bPic addObject:strb];
        }
    }
    NSArray *headArr;
    //苹果是200x200 400x400,IPAD是400x400 800x800
//    if (IsPhone) {
//        if (pic.count==0) {
//            pic = @[@"pic"].mutableCopy;
//        }
//        headArr = pic.copy;
//        self.IDarray = [mPic copy];
//    }else{
        if (mPic.count==0) {
            mPic = @[@"pic"].mutableCopy;
        }
        headArr = mPic.copy;
        self.IDarray = [bPic copy];
//    }
    [self setupHeadView:headArr];
}

- (void)setupHeadView:(NSArray *)headArr{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, SDevWidth+44)];
    CGRect frame = CGRectMake(0, 0, SDevWidth, SDevWidth);
    ETFoursquareImages *Images = [[ETFoursquareImages alloc]initWithFrame:frame];
    [Images setImagesHeight:SDevWidth];
    Images.delegate = self;
    [Images setImages:headArr];
    [headView addSubview:Images];
    self.foursquareImages = Images;
    
    UIView *fView = [[UIView alloc]init];
    fView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.numberOfLines = 2;
    titleLab.text = self.modelInfo.title;
    CGRect rect = CGRectMake(0, 0, SDevWidth-30, 999);
    rect = [titleLab textRectForBounds:rect limitedToNumberOfLines:0];
    fView.frame = CGRectMake(0, SDevWidth, SDevWidth, 10+rect.size.height);
    titleLab.frame = CGRectMake(15, 5, rect.size.width,rect.size.height);
    [fView addSubview:titleLab];
    [headView addSubview:fView];
    
    self.tableView.tableHeaderView = headView;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

#pragma mark - imageTapDelegate
- (void)imageTapGestureWithIndex:(int)index{
    //网络图片展示
    if (self.IDarray.count==0) {
        [MBProgressHUD showError:@"暂无图片"];
        return;
    }
    [self networkImageShow:index];
}

- (void)networkImageShow:(NSUInteger)index{
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *str in self.IDarray) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:str]];
        [photos addObject:photo];
    }
    self.photos = [photos copy];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count){
        return [_photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark -- CustomPopView
- (void)setupPopView{
    CustomPopView *popV = [[CustomPopView alloc]initWithFrame:
                           CGRectMake(0, 0, SDevWidth, SDevHeight)];
    popV.popBack = ^(id dict){
        [self chooseType:dict];
    };
    self.popView = popV;
}

#pragma mark -- CustomPopView
- (void)setupTextView{
    DetailTextCustomView *popV = [[DetailTextCustomView alloc]initWithFrame:
                           CGRectMake(0, 0, SDevWidth, SDevHeight)];
    popV.textBack = ^(id dict){
        [self chooseType:dict];
    };
    self.textCView = popV;
}
//选择石头
- (void)chooseType:(NSDictionary *)dict{
    NSIndexPath *path = [dict allKeys][0];
    DetailTypeInfo *info = [dict allValues][0];
    NSMutableArray *arr = self.detailArr[path.section];
    [arr setObject:info atIndexedSubscript:path.row];
    if (path.section!=0) {
        [self.bools setObject:@NO atIndexedSubscript:path.section];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:path.section+1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
//一个石头里面的数据齐全
- (BOOL)boolWithArr:(NSArray *)arr{
    for (DetailTypeInfo *info in arr) {
        if (info.title.length==0) {
            return NO;
        }
    }
    return YES;
}
//一个石头里面的数据都是空的
- (BOOL)boolWithNoArr:(NSArray *)arr{
    for (DetailTypeInfo *info in arr) {
        if (info.title.length>0) {
            return NO;
        }
    }
    return YES;
}

#pragma mark -- RemarkPopView
- (void)setupRemarkPopView{
    CGRect frame = CGRectMake(0, 0, SDevWidth, SDevHeight);
    RemarkPopView *popV = [[RemarkPopView alloc]initWithFrame:frame];
    popV.popBack = ^(id message){
        self.lastMess = [NSString stringWithFormat:@"%@%@",self.lastMess,message];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:
                                                   UITableViewRowAnimationNone];
    };
    self.remarkPopView = popV;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.popView removeFromSuperview];
    [self.remarkPopView removeFromSuperview];
    [self.textCView removeFromSuperview];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
                         numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView
                  heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 90;
    if (indexPath.row==5) {
        height = 120;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
                     cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        CustomFirstCell *firstCell = [CustomFirstCell cellWithTableView:tableView];
        [firstCell.btn setTitle:self.modelInfo.categoryTitle forState:UIControlStateNormal];
        firstCell.MessBack = ^(NSArray *messArr){
            self.firstArr = messArr;
        };
        firstCell.messArr = self.firstArr;
        return firstCell;
    }else if (indexPath.row==5){
        CustomLastCell *lastCell = [CustomLastCell cellWithTableView:tableView];
        [lastCell.btn addTarget:self action:@selector(openRemark:)
                                  forControlEvents:UIControlEventTouchUpInside];
        lastCell.messBack = ^(NSString *message){
            self.lastMess = message;
        };
        lastCell.message = self.lastMess;
        return lastCell;
    }else{
        CustomProCell *proCell = [CustomProCell cellWithTableView:tableView];
        proCell.number = self.nums[indexPath.row-1];
        proCell.titleStr = self.typeArr[indexPath.row-1];
        proCell.isSel = [self.bools[indexPath.row-1]boolValue];
        proCell.list = self.detailArr[indexPath.row-1];
        proCell.tableBack = ^(id index){
            if ([index isKindOfClass:[NSString class]]) {
                [self.nums setObject:index atIndexedSubscript:indexPath.row-1];
            }else if ([index isKindOfClass:[NSDictionary class]]){
                BOOL ishave = [index[@"主石"] boolValue];
                [self.bools setObject:@(ishave) atIndexedSubscript:indexPath.row-1];
            }else{
                NSIndexPath *inPath = [NSIndexPath indexPathForRow:[index integerValue]
                                                         inSection:indexPath.row-1];
                [self openPopTableWithInPath:inPath];
            }
        };
        return proCell;
    }
}

- (void)openPopTableWithInPath:(NSIndexPath *)inPath{
    if (inPath.row==1) {
        NSString *titleStr = self.specTitles[inPath.section];
        self.textCView.section = inPath;
        self.textCView.topLab.text = titleStr;
        [self.view addSubview:self.textCView];
    }else{
        NSArray *dictArr = self.chooseArr[inPath.row];
        self.popView.typeList = dictArr;
        self.popView.section = inPath;
        [self.view addSubview:self.popView];
    }
}

- (void)openRemark:(id)sender{
    [self.view addSubview:self.remarkPopView];
}

- (IBAction)lookOrder:(id)sender {
    if (self.isEdit) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    ConfirmOrderVC *orderVC = [ConfirmOrderVC new];
    [self.navigationController pushViewController:orderVC animated:YES];
}
#pragma mark -- 提交订单
- (IBAction)addOrder:(id)sender {
    if ([self.firstArr[0] length]==0) {
        [MBProgressHUD showError:@"请选择件数"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    for (int i=0; i<self.nums.count; i++) {
        NSMutableArray *arr = self.detailArr[i];
        BOOL isAdd = [self boolWithArr:arr]&&[self.nums[i] length]>0;
        BOOL isNoAdd = [self boolWithNoArr:arr]&&[self.nums[i] length]==0;
        if (i==0&&self.bools[0]) {
            [self paramsWithArr:arr andI:i andD:params];
        }else{
            if ([self.bools[i]boolValue]) {
                params[self.typeSArr[i]] = @"||||||1";
                continue;
            }
            if (isAdd) {
                [self paramsWithArr:arr andI:i andD:params];
            }else if (!isNoAdd){
                NSString *str = @"请填写红框";
                [MBProgressHUD showError:str];
                return;
            }
        }
    }
    [self addOrderWithDict:params];
}

- (void)paramsWithArr:(NSArray *)arr andI:(int)i andD:(NSMutableDictionary *)params{
    NSMutableArray *mutA = @[].mutableCopy;
    for (DetailTypeInfo *info in arr) {
        if (info.id) {
            [mutA addObject:@(info.id)];
        }else{
            if (info.title) {
                [mutA addObject:info.title];
            }else{
                [mutA addObject:@""];
            }
        }
    }
    [mutA addObject:self.nums[i]];
    NSString *str = [StrWithIntTool strWithIntOrStrArr:mutA];
    NSString *key = self.typeSArr[i];
    if (![key isEqualToString:@"stone"]) {
        str = [NSString stringWithFormat:@"%@|0",str];
    }
    params[self.typeSArr[i]] = str;
}

- (void)addOrderWithDict:(NSMutableDictionary *)params{
    NSString *detail;
    if (self.isEdit==1) {
        detail = @"OrderCurrentEditModelItemDo";
    }else if (self.isEdit==2){
        detail = @"ModelOrderWaitCheckOrderCurrentEditModelItemDo";
    }else{
        detail = @"OrderDoCurrentModelItemDo";
    }
    NSString *regiUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSString *proId = self.isEdit?@"itemId":@"productId";
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[proId] = @(self.proId);
    params[@"number"] = self.firstArr[0];
    if ([self.firstArr[1] length]>0) {
        params[@"handSize"] = self.firstArr[1];
    }
    params[@"isSelfStone"] = self.bools[0];
    if (!self.isEdit) {
        params[@"categoryId"] = @(self.modelInfo.categoryId);
    }
    if (_qualityId&&_colorId) {
        params[@"qualityId"] = @(_qualityId);
        params[@"purityId"] = @(_colorId);
    }
    if (self.lastMess.length>0) {
        params[@"remarks"] = self.lastMess;
    }
    [self addOrderData:params andUrl:regiUrl];
}

- (void)addOrderData:(NSMutableDictionary *)params andUrl:(NSString *)netUrl{
    [SVProgressHUD show];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if (self.isEdit) {
                [self loadEditType:response.data];
                return;
            }
            if ([YQObjectBool boolForObject:response.data]&&
                [YQObjectBool boolForObject:response.data[@"waitOrderCount"]]) {
                App;
                app.shopNum = [response.data[@"waitOrderCount"]intValue];
                [OrderNumTool orderWithNum:app.shopNum andView:self.numLab];
            }
            [MBProgressHUD showSuccess:@"添加订单成功"];
        }else{
            [MBProgressHUD showError:response.message];
        }
    }requestURL:netUrl params:params];
}

- (void)loadEditType:(NSDictionary *)data{
    OrderListInfo *listI = [OrderListInfo objectWithKeyValues:data];
    if (self.orderBack) {
        self.orderBack(listI);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//
//  SearchOrderVc.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/14.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SearchOrderVc.h"
#import "CustomTextField.h"
#import "CustomDatePick.h"
#import "CustomBtnView.h"
#import "YQDropdownMenu.h"
#import "SearchResultsVC.h"
#import "SearchCustomerVC.h"
#import "CustomerInfo.h"
#import "StrWithIntTool.h"
@interface SearchOrderVc ()<UITextFieldDelegate,YQDropdownMenuDelagate,
                                      UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,  weak)UITextField *searchFie;
@property (nonatomic,  weak)UIButton *titleBtn;
@property (nonatomic,strong)CustomDatePick *datePick;
@property (nonatomic,  weak)CustomBtnView *btnView;
@property (strong,nonatomic) IBOutletCollection(UIView) NSArray *dateViews;
@property (strong,nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@property (strong,nonatomic) IBOutletCollection(UIButton) NSArray *dateBtns;
@property (nonatomic,  copy)NSString *date1;
@property (nonatomic,  copy)NSString *date2;
@property (nonatomic,assign)int isSel;
@property (nonatomic,assign)BOOL isSelBtn;
@property (nonatomic,strong)CustomerInfo *cusInfo;
@property (weak,  nonatomic) IBOutlet UITextField *textFie;
@end

@implementation SearchOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    [self setNaviTitleAndRight];
    [self loadDatePick];
    for (UIView *baV in self.dateViews) {
        baV.layer.cornerRadius = 3;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isSelBtn = NO;
}

#pragma mark -- NaviBarTitleView
- (void)setNaviTitleAndRight{
    CGFloat width = SDevWidth*0.70;
    CGFloat sWidth = 65;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    titleView.layer.cornerRadius = 5;
    titleView.backgroundColor = DefaultColor;
    
    CustomBtnView *btnV = [CustomBtnView creatView];
    btnV.frame = CGRectMake(5, 0, sWidth, 30);
    [btnV.selBtn setImage:[UIImage imageNamed:@"icon_xxx"] forState:UIControlStateNormal];
    btnV.titleLab.text = @"订单号";
    [btnV.allBtn addTarget:self action:@selector(clickDown) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btnV];
    self.btnView = btnV;
    
    CustomTextField *titleFie = [[CustomTextField alloc]initWithFrame:CGRectMake(sWidth+5, 0, width-sWidth-5, 30)];
    titleFie.tag = 101;
    titleFie.delegate = self;
    titleFie.borderStyle = UITextBorderStyleNone;
    [titleView addSubview:titleFie];
    _searchFie = titleFie;
    self.navigationItem.titleView = titleView;
    self.textFie.tag = 102;
    
    UIButton *seaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seaBtn.frame = CGRectMake(0, 0, 30, 30);
    [seaBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [seaBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:seaBtn];
}
#pragma mark -- 导航点击事件
- (void)clickDown{
    YQDropdownMenu *menu = [YQDropdownMenu menu];
    menu.delegate = self;
    menu.content = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [menu showFrom:self.btnView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"menuCell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -- 日历选择
- (void)loadDatePick{
    CustomDatePick *date = [CustomDatePick creatCustomView];
    date.frame = CGRectMake(0, 0, SDevWidth, SDevHeight-64);
    date.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    date.back = ^(NSDate *date){
        NSString *str = [formatter stringFromDate:date];
        UIButton *sBtn = self.dateBtns[self.isSel];
        [sBtn setTitle:str forState:UIControlStateNormal];
        if (self.isSel) {
            self.date1 = str;
        }else{
            self.date2 = str;
        }
    };
    self.datePick = date;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.datePick removeFromSuperview];
}

- (IBAction)dateClick:(UIButton *)sender {
    NSInteger index = [self.dateBtns indexOfObject:sender];
    self.isSel = (int)index;
    [self.view addSubview:self.datePick];
}
//筛选条件
- (IBAction)myClick:(UIButton *)sender {
    NSInteger index = [self.btns indexOfObject:sender];
    for (int i=0; i<self.btns.count; i++) {
        UIButton *sBtn = self.btns[i];
        if (i!=index) {
            sBtn.selected = NO;
        }
    }
    sender.selected = !sender.selected;
}

#pragma mark 客户选择
- (IBAction)searchCustomer:(id)sender {
    [self.textFie resignFirstResponder];
    [self.searchFie resignFirstResponder];
    if (self.isSelBtn) {
        return;
    }
    [self pushSearchVC];
}

- (void)setCusInfo:(CustomerInfo *)cusInfo{
    if (cusInfo) {
        _cusInfo = cusInfo;
        self.textFie.text = cusInfo.customerName;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==101) {
        return;
    }
    NSMutableArray *addArr = @[].mutableCopy;
    if (textField.text.length>0) {
        NSArray *arr = [textField.text componentsSeparatedByString:@" "];
        for (NSString *str in arr) {
            if (![str isEqualToString:@""]) {
                [addArr addObject:str];
            }
        }
        [self loadHaveCustomer:[StrWithIntTool strWithArr:addArr]];
    }
}

- (void)pushSearchVC{
    SearchCustomerVC *cusVc = [SearchCustomerVC new];
    cusVc.searchMes = self.textFie.text;
    cusVc.back = ^(id dict){
        self.cusInfo = dict;
    };
    [self.navigationController pushViewController:cusVc animated:YES];
}

- (void)loadHaveCustomer:(NSString *)message{
    if (self.isSelBtn) {
        return;
    }
    self.isSelBtn = YES;
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@IsHaveCustomer",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"keyword"] = message;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        self.isSelBtn = NO;
        if ([response.error intValue]==0) {
            if ([response.data[@"state"]intValue]==0) {
                SHOWALERTVIEW(@"没有此客户记录");
                self.cusInfo.customerID = 0;
            }else if([response.data[@"state"]intValue]==1){
                self.cusInfo = [CustomerInfo objectWithKeyValues:response.data[@"customer"]];
            }else if ([response.data[@"state"]intValue]==2){
                [self pushSearchVC];
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)searchClick{
    SearchResultsVC *resVc = [SearchResultsVC new];
    [self.navigationController pushViewController:resVc animated:YES];
}

@end

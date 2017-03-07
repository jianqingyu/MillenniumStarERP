//
//  PayViewController.m
//  MillenniumStar
//
//  Created by LanF on 15/6/16.
//  Copyright (c) 2015年 Millennium Star. All rights reserved.
//

#import "PayViewController.h"
//#import "WXApi.h"
//#import "ReturnpageVc.h"
//#import "AliPayTool.h"
//#import "CommonUtils.h"
//#import "payRequsestHandler.h"
#import "CustomInvoice.h"
#import "PayReturnPageVC.h"
#import "PayTableCell.h"
@interface PayViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UILabel*totalPriceLabel;
    UIWindow *__customView;
}
@property (nonatomic, retain) UITableView *payTable;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSArray *payImageArray;
@property (nonatomic, retain) NSArray *payTitleArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, copy) NSString *message;

@end

@implementation PayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"支付";
    [self creatTableView];
    [self initHeadAndFootView];
}

- (void)creatTableView{
    CGRect frame = CGRectMake(0, 0, SDevWidth, SDevHeight);
    self.payImageArray = @[@"icon_pay_ye",@"icon_pay_zfb",@"icon_pay_wx",@"unionpay"];
    self.payTitleArray = @[@"余额",@"支付宝支付",@"微信支付",@"银联支付"];
    self.payTable = [[UITableView alloc] initWithFrame:frame];
    self.payTable.delegate = self;
    self.payTable.dataSource = self;
    [self.view addSubview:self.payTable];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    __customView.hidden = YES;
    __customView = nil;
}

- (void)initHeadAndFootView{
    UIView*footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 80)];
    UIView*headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 100)];
    self.payTable.tableFooterView = footView;
    self.payTable.tableHeaderView = headView;
    
    UIView*line = [UIView new];
    [headView addSubview:line];
    line.backgroundColor = DefaultColor;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(0);
        make.right.equalTo(footView).offset(0);
        make.top.equalTo(footView).offset(0);
        make.height.mas_equalTo(@0.8);
    }];
    
    UIButton*payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footView addSubview:payButton];
    [payButton setBackgroundImage:[CommonUtils createImageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [payButton setBackgroundImage:[CommonUtils createImageWithColor:CUSTOM_COLOR(191, 158, 103)] forState:UIControlStateHighlighted];
    payButton.layer.masksToBounds = YES;
    payButton.layer.cornerRadius = 5;
    [payButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payBtnClick:)
                                  forControlEvents:UIControlEventTouchUpInside];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(10);
        make.right.equalTo(footView).offset(-10);
        make.top.equalTo(footView).offset(20);
        make.height.mas_equalTo(@40);
    }];
    
    UILabel*lable = [UILabel new];
    [headView addSubview:lable];
    lable.text = @"需支付金额";
    lable.textColor = [UIColor grayColor];
    lable.lineBreakMode = NSLineBreakByTruncatingMiddle;
    lable.font = [UIFont systemFontOfSize:12];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.equalTo(headView).offset(20);
    }];

    totalPriceLabel = [UILabel new];
    [headView addSubview:totalPriceLabel];
    totalPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f",_amount];
    totalPriceLabel.textColor = [UIColor redColor];
    totalPriceLabel.font = [UIFont systemFontOfSize:16];
    [totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.equalTo(lable.mas_bottom).offset(5);
    }];
    
    UILabel*lable2 = [UILabel new];
    [headView addSubview:lable2];
    lable2.text = @"选择支付方式";
    lable2.textColor = [UIColor darkGrayColor];
    lable2.lineBreakMode = NSLineBreakByTruncatingMiddle;
    lable2.font = [UIFont systemFontOfSize:12];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(20);
        make.bottom.equalTo(headView).offset(-10);
    }];
    
    UIView*line2 = [UIView new];
    [headView addSubview:line2];
    line2.backgroundColor = DefaultColor;
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(0);
        make.right.equalTo(headView).offset(0);
        make.bottom.equalTo(headView).offset(0);
        make.height.mas_equalTo(@0.8);
    }];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payImageArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayTableCell *tableCell = [PayTableCell cellWithTableView:tableView];
    if (indexPath.row == self.selectIndex) {
        tableCell.accessoryView = [self imageAccessoryView];
    }else{
        tableCell.accessoryView = nil;
    }
    tableCell.logImage.image = [UIImage imageNamed:[self.payImageArray objectAtIndex:indexPath.row]];
    tableCell.payName.text = [self.payTitleArray objectAtIndex:indexPath.row];
    tableCell.textLabel.font = [UIFont systemFontOfSize:14];
    return tableCell;
}

- (UIImageView *)imageAccessoryView{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.image = [UIImage imageNamed:@"icon_lisel"];
    return imageView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
    [self.payTable reloadData];
}
//支付按钮
- (void)payBtnClick:(UIButton*)button{
    __customView = [CustomInvoice showAlertViewCallBlock:^(NSString *message) {
        if (message.length>0) {
            _message = message;
            PayReturnPageVC *pageVc = [PayReturnPageVC new];
            [self.navigationController pushViewController:pageVc animated:YES];
        }
        __customView.hidden = YES;
        __customView = nil;
    }];
//    if (self.selectIndex == 0) {
//        [self alipayMent];
//    }else if(self.selectIndex == 1){
//        if ([WXApi isWXAppInstalled]) {
//            [self wechatPay];
//        } else {
//            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"您的手机没有安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }
}
////支付宝支付
//-(void)alipayMent{
//    App;
//    app.aliPayCallBack = ^(BOOL isSuccees) {
//        if(isSuccees){
//            ReturnpageVc *pageVc = [[ReturnpageVc alloc]init];
//            pageVc.price   = self.amount;
//            pageVc.address = self.address;
//            pageVc.orderId = self.orderId;
//            pageVc.isOrder = self.isOrder;
//            [self.navigationController pushViewController:pageVc animated:YES];
//        }
//    };
//    
//    [AliPayTool alipayMentWithTradeNO:self.trade_no andProductName:self.productName andProductDescription:self.productDescription andPrice:self.amount];
//}
////微信支付
//-(void)wechatPay{
//    [SVProgressHUD show];
//    App;
//    app.weChatPayBlock = ^(BOOL isSuccees){
//        if(isSuccees){
//            ReturnpageVc *pageVc = [[ReturnpageVc alloc]init];
//            pageVc.price   = self.amount;
//            pageVc.address = self.address;
//            pageVc.orderId = self.orderId;
//            pageVc.isOrder = self.isOrder;
//            [self.navigationController pushViewController:pageVc animated:YES];
//        }
//    };
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"out_trade_no"] = _trade_no;
//    dic[@"total_fee"] = @(int(self.amount*100));
//    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
//        [SVProgressHUD dismiss];
//        if([response.error intValue]==0){
//                //调起微信支付
//                PayReq* req             = [[PayReq alloc] init];
//                req.openID              = APP_ID;
//                req.partnerId           = MCH_ID;
//                req.prepayId            = response.data[@"prepayid"];
//                req.nonceStr            = response.data[@"noncestr"];
//                req.timeStamp           = [response.data[@"timestamp"]intValue];
//                req.package             = @"Sign=WXPay";
//                req.sign                = response.data[@"sign"];
//            [WXApi sendReq:req];
////            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign);
//        }
//    } requestURL:WeiXinPay params:dic];
//}

@end

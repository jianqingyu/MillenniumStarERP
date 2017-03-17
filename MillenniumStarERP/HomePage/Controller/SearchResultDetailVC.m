//
//  SearchResultDetailVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/15.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SearchResultDetailVC.h"
#import "UserManagerMenuHrizontal.h"
#import "UserManagerScrollPageView.h"
#define MENUHEIHT 40
@interface SearchResultDetailVC ()<UserManagerMenuHrizontalDelegate,UserManagerScrollPageViewDelegate>{
    NSArray*titleArray;
    UserManagerScrollPageView*mScrollPageView;
    UserManagerMenuHrizontal*menuHorizontalView;
}
@end

@implementation SearchResultDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制";
    titleArray = @[@{@"title":@"待审核",@"netUrl":@"ModelOrderWaitCheckList",@"proId":@"10"},
                   @{@"title":@"生产中",@"netUrl":@"ModelOrderProduceListPage",@"proId":@"20"},
                   @{@"title":@"已发货",@"netUrl":@"ModelBillList",@"proId":@"30"},
                   @{@"title":@"已完成",@"netUrl":@"",@"proId":@"40"}];
    [self initCustomView];
}

#pragma mark UI初始化
- (void)initCustomView{
    //main view
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CGRect vViewRect = CGRectMake(0, 0, SDevWidth, SDevHeight);
    UIView *mainContentView = [[UIView alloc] initWithFrame:vViewRect];
    menuHorizontalView = [[UserManagerMenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, SDevWidth, MENUHEIHT) ButtonItems:titleArray];
    menuHorizontalView.delegate = self;
    //默认选中第一个button
    [menuHorizontalView clickButtonAtIndex:_index];
    
    [mainContentView addSubview:menuHorizontalView];
    //初始化滑动列表
    mScrollPageView = [[UserManagerScrollPageView alloc] initScrollPageView:CGRectMake(0, MENUHEIHT, SDevWidth, mainContentView.frame.size.height - MENUHEIHT) navigation:self.navigationController];
    mScrollPageView.delegate = self;
    [mScrollPageView setContentOfTables:titleArray table:@"SearchResultTableView"];
    [mainContentView addSubview:mScrollPageView];
    //初始化选择
    [mScrollPageView moveScrollowViewAthIndex:_index];
    [menuHorizontalView changeButtonStateAtIndex:_index];
    [self.view addSubview:mainContentView];
}

#pragma mark - 其他辅助功能
- (void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)index{
    _index = (int)index;
    [mScrollPageView moveScrollowViewAthIndex:index];
}

#pragma mark ScrollPageViewDelegate
- (void)didScrollPageViewChangedPage:(NSInteger)page{
    _index = (int)page;
    [menuHorizontalView changeButtonStateAtIndex:page];
}

@end

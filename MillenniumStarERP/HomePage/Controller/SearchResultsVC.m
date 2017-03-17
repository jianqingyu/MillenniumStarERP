//
//  SearchResultsVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/15.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SearchResultsVC.h"
#import "SearchResultDetailVC.h"
#import "SearchResultTableCell.h"
@interface SearchResultsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *resultTable;
@end

@implementation SearchResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultTableCell *resCell = [SearchResultTableCell cellWithTableView:tableView];
    return resCell;
}

@end

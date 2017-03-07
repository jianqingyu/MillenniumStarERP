//
//  ScrollPageView.m
//  ShowProduct
//
//  Created by JIMU on 14-8-29.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "UserManagerScrollPageView.h"
#import "UserManagerTableView.h"
UINavigationController*navigationController;
@implementation UserManagerScrollPageView

- (id)initScrollPageView:(CGRect)frame navigation:(UINavigationController*)navigation{
    self = [super initWithFrame:frame];
    if (self) {
        mNeedUseDelegate = YES;
        [self commInit];
    }
    navigationController = navigation;
    return self;
}

- (void)commInit{
    if (_contentItems == nil) {
        _contentItems = [[NSMutableArray alloc] init];
    }
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SDevWidth, self.frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    [self addSubview:_scrollView];
}

#pragma mark - 其他辅助功能
#pragma mark 添加ScrollowViewd的ContentView
-(void)setContentOfTables:(NSArray*)proidArray nav:(UINavigationController*)nav{
    for (int i=0;i<proidArray.count;i++) {;
        UserManagerTableView*contentView = [[UserManagerTableView alloc]initWithFrame:CGRectMake(i*SDevWidth, 0, SDevWidth, self.frame.size.height)];
        contentView.superNav = self.navigationController;
        contentView.netUrl = proidArray[i][@"netUrl"];
        contentView.proid = [proidArray[i][@"proId"] intValue];
        [_scrollView addSubview:contentView];
        [_contentItems addObject:contentView];
    }
    [_scrollView setContentSize:CGSizeMake(SDevWidth * proidArray.count, self.frame.size.height)];
}

#pragma mark 移动ScrollView到某个页面
- (void)moveScrollowViewAthIndex:(NSInteger)index{
    mNeedUseDelegate = NO;
    CGRect vMoveRect = CGRectMake(self.frame.size.width * index, 0, self.frame.size.width, self.frame.size.width);
    [_scrollView scrollRectToVisible:vMoveRect animated:YES];
    mCurrentPage= index;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)]) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    mNeedUseDelegate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (_scrollView.contentOffset.x+[UIScreen mainScreen].bounds.size.width/2.0) / [UIScreen mainScreen].bounds.size.width;
    if (mCurrentPage == page) {
        return;
    }
    mCurrentPage= page;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && mNeedUseDelegate) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

@end
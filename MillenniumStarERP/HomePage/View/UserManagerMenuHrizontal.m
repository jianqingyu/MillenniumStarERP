//
//  MenuHrizontal.m
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "UserManagerMenuHrizontal.h"
#import "CommonUtils.h"
#import "OrderNumTool.h"
#define BUTTONITEMWIDTH   70

@implementation UserManagerMenuHrizontal
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray
{
    self = [super initWithFrame:frame];
    if (self) {
        if (mButtonArray == nil) {
            mButtonArray = [[NSMutableArray alloc] init];
        }
        if (mScrollView == nil) {
            
            mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,SDevWidth/3*aItemsArray.count, self.frame.size.height)];
            mScrollView.showsHorizontalScrollIndicator = YES;
            mScrollView.showsVerticalScrollIndicator = NO;
        }
        if (mItemInfoArray == nil) {
            mItemInfoArray = [[NSMutableArray alloc]init];
        }
        if (mLabArray == nil) {
            mLabArray = [NSMutableArray array];
        }
        [mItemInfoArray removeAllObjects];
        [self createMenuItems:aItemsArray];
    }
    return self;
}

- (void)createMenuItems:(NSArray *)itemArray{
    int i = 0;
    float menuWidth = 0.0;
    for (NSDictionary *dic in itemArray) {
        NSString *buttonTitle = dic[@"title"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[CommonUtils createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"frame"] forState:UIControlStateSelected];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [button setTag:i];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(menuWidth, 0, SDevWidth/itemArray.count, self.frame.size.height)];
        [mScrollView addSubview:button];
        [mButtonArray addObject:button];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(SDevWidth/itemArray.count-16, 8, 16 ,16)];
        lab.layer.cornerRadius = 8;
        lab.layer.masksToBounds = YES;
        lab.backgroundColor = MAIN_COLOR;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:12];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.hidden = YES;
        //根据宽度适配文字大小
        lab.adjustsFontSizeToFitWidth = YES;
        [button addSubview:lab];
        [mLabArray addObject:lab];
        
        menuWidth += SDevWidth/itemArray.count;
        i++;
        //保存button资源信息，同时增加button.oringin.x的位置，方便点击button时，移动位置。
        NSMutableDictionary *newDic = [dic mutableCopy];
        [newDic setObject:[NSNumber numberWithFloat:menuWidth] forKey:TOTALWIDTH];
        [mItemInfoArray addObject:newDic];
    }
    [mScrollView setContentSize:CGSizeMake(menuWidth, self.frame.size.height)];
    [self addSubview:mScrollView];
    mTotalWidth = menuWidth;
}
#pragma mark - 其他辅助功能
#pragma mark 取消所有button点击状态
-(void)changeButtonsToNormalState{
    for (UIButton *vButton in mButtonArray) {
        vButton.selected = NO;
    }
}
#pragma mark 模拟选中第几个button
-(void)clickButtonAtIndex:(NSInteger)aIndex{
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self menuButtonClicked:vButton];
}

#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex{
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self changeButtonsToNormalState];
    vButton.selected = YES;
    [self moveScrolViewWithIndex:aIndex];
}

#pragma mark 移动button到可视的区域
-(void)moveScrolViewWithIndex:(NSInteger)aIndex{
    if (mItemInfoArray.count < aIndex) {
        return;
    }
    //宽度小于320肯定不需要移动
    if (mTotalWidth <= SDevWidth-20) {
        return;
    }
    NSDictionary *vDic = [mItemInfoArray objectAtIndex:aIndex];
    float vButtonOrigin = [[vDic objectForKey:TOTALWIDTH] floatValue];
    if (vButtonOrigin >= SDevWidth-20) {
        if ((vButtonOrigin + 180) >= mScrollView.contentSize.width) {
            [mScrollView setContentOffset:CGPointMake(mScrollView.contentSize.width - SDevWidth, mScrollView.contentOffset.y) animated:YES];
            return;
        }
        float vMoveToContentOffset = vButtonOrigin - 180;
        if (vMoveToContentOffset > 0) {
            [mScrollView setContentOffset:CGPointMake(vMoveToContentOffset, mScrollView.contentOffset.y) animated:YES];
        }
    }else{
        [mScrollView setContentOffset:CGPointMake(0, mScrollView.contentOffset.y) animated:YES];
        return;
    }
}

#pragma mark - 点击事件
-(void)menuButtonClicked:(UIButton *)aButton{
    [self changeButtonStateAtIndex:aButton.tag];
    if ([_delegate respondsToSelector:@selector(didMenuHrizontalClickedButtonAtIndex:)]) {
        [_delegate didMenuHrizontalClickedButtonAtIndex:aButton.tag];
    }
}

- (void)setImgArr:(NSArray *)imgArr{
    if (imgArr) {
        _imgArr = imgArr;
        for (int i=0; i<_imgArr.count; i++) {
            UILabel *lab = mLabArray[i];
            int cum = [_imgArr[i]intValue];
            [OrderNumTool orderWithNum:cum andView:lab];
        }
    }
}

@end

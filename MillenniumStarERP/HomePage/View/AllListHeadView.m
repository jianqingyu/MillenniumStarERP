//
//  AllListHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/10.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "AllListHeadView.h"

@implementation AllListHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *heBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        heBtn.frame = CGRectMake(20, 5, 100, 30);
        [heBtn setTitle:@"筛选条件" forState:UIControlStateNormal];
        heBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [heBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [heBtn setBackgroundColor:DefaultColor];
        
        UIButton *log = [UIButton buttonWithType:UIButtonTypeCustom];
        log.frame = CGRectMake(100, 15, 10, 10);
        [log setImage:[UIImage imageNamed:@"icon_right_red"] forState:UIControlStateNormal];
        [log setImage:[UIImage imageNamed:@"icon_down_red"] forState:UIControlStateSelected];
        
        UIButton *dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dBtn.frame = CGRectMake(SDevWidth-90, 5, 80, 30);
        [dBtn setTitle:@"" forState:UIControlStateDisabled];
        dBtn.enabled = NO;
        dBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        dBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [dBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UILabel *sLab = [UILabel new];
        sLab.frame = CGRectMake(SDevWidth-170, 5, 80, 30);
        sLab.text = @"搜索关键字:";
        sLab.font = [UIFont systemFontOfSize:14];
        sLab.textColor = [UIColor blackColor];
        
        [self addSubview:heBtn];
        [self addSubview:log];
        [self addSubview:dBtn];
        [self addSubview:sLab];
        self.tBtn = heBtn;
        self.lBtn = log;
        self.seaLab = sLab;
        self.deleBtn = dBtn;
    }
    return self;
}

@end

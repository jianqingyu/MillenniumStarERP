//
//  ProgressListView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/22.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ProgressListView.h"
#define widthV (SDevWidth-30)
@implementation ProgressListView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *view1 = [[UIView alloc]init];
        view1.backgroundColor = MAIN_COLOR;
        [self addSubview:view1];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.top.equalTo(self).offset(0);
            make.width.mas_equalTo(0);
            make.bottom.equalTo(self).offset(0);
        }];
        self.oneView = view1;
        
        UIView *view2 = [[UIView alloc]init];
        view2.backgroundColor = DefaultColor;
        [self addSubview:view2];
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.width.mas_equalTo(widthV);
            make.right.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(0);
        }];
        self.secView = view2;
        
        UILabel *lab = [[UILabel alloc]init];
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = [UIColor blackColor];
        lab.hidden = YES;
        [self addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5);
            make.top.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(0);
        }];
        self.titleLab = lab;
    }
    return self;
}

- (void)setProgress:(float)progress{
    if (progress) {
        _progress = progress;
        [self.oneView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(widthV*_progress);
        }];
        [self.secView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(widthV*(1-_progress));
        }];
    }
}

@end

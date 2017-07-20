//
//  NakedDriSeaHeadV.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriSeaHeadV.h"
#import "CustomShapeBtn.h"
@interface NakedDriSeaHeadV()
@property (nonatomic,weak)UIButton *imgBtn;
@end
@implementation NakedDriSeaHeadV

- (void)setTopArr:(NSArray *)topArr{
    if (topArr) {
        _topArr = topArr;
        NSInteger total = _topArr.count;
        CGFloat rowWid = 60;
        CGFloat rowhei = 30;
        for (int i=0; i<total; i++) {
            UIButton *btn = [self creatBtn];
            btn.frame = CGRectMake(rowWid*i,0, rowWid, rowhei);
            if (i==1) {
                UIButton *img = [UIButton buttonWithType:UIButtonTypeCustom];
                img.frame = CGRectMake(40, 0, 20, 30);
                [img setImage:[UIImage imageNamed:@"icon_sort"] forState:UIControlStateNormal];
                [img addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn addSubview:img];
                self.imgBtn = img;
            }
            if (i==total-1) {
                btn.width = 100;
            }
            [btn setTitle:_topArr[i] forState:UIControlStateNormal];
        }
    }
}

- (UIButton *)creatBtn{
    CustomShapeBtn *btn = [CustomShapeBtn buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self addSubview:btn];
    return btn;
}

- (void)sortClick:(id)sender{
    NSString *imgName;
    if ([_string isEqualToString:@"weight_desc"]) {
        _string = @"weight_asc";
        imgName = @"icon_sort_u";
    }else if ([_string isEqualToString:@"weight_asc"]){
        _string = @"";
        imgName = @"icon_sort";
    }else{
        _string = @"weight_desc";
        imgName = @"icon_sort_d";
    }
    [self.imgBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    if (self.back) {
        self.back(_string);
    }
}

@end

//
//  NakedDriLibBLabCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriLibBLabCell.h"
#import "NakedDriLibInfo.h"
@implementation NakedDriLibBLabCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"textBCell";
    NakedDriLibBLabCell *imgCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (imgCell==nil) {
        imgCell = [[NakedDriLibBLabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return imgCell;
}

- (void)setTextInfo:(NakedDriLiblistInfo *)textInfo{
    if (textInfo) {
        _textInfo = textInfo;
        [UIView animateWithDuration:0.1 animations:^{
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 40, 20)];
        lab.font = [UIFont systemFontOfSize:14];
        CGFloat height = CGRectGetMaxY(lab.frame)+5;
        lab.text = _textInfo.title;
        [self.contentView addSubview:lab];
        
        int COLUMN = 5;
        CGFloat ROWSPACE = 10;
        NSInteger total = _textInfo.values.count;
        CGFloat rowWid = (SDevWidth - 6*10)/5;
        CGFloat rowhei = 25;
        
        CGFloat cellHeight = 0;
        for (int i=0; i<total; i++) {
            int row = i / COLUMN;
            int column = i % COLUMN;
            NakedDriLibInfo *dInfo = _textInfo.values[i];
            UIButton *btn = [self creatBtn];
            btn.frame = CGRectMake(ROWSPACE + rowWid*column + ROWSPACE * column,height+ ROWSPACE + (rowhei + ROWSPACE)*row, rowWid, rowhei);
            btn.tag = i;
            [btn setTitle:dInfo.name forState:UIControlStateNormal];
            btn.selected = dInfo.isSel;
            cellHeight = CGRectGetMaxY(btn.frame)+10;
        }
        self.bounds = CGRectMake(0, 0, SDevWidth, cellHeight);
    }
}

- (UIButton *)creatBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:MAIN_COLOR] forState:UIControlStateSelected];
    [btn setLayerWithW:5 andColor:BordColor andBackW:0.5];
    [btn addTarget:self action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    return btn;
}

- (void)subCateBtnAction:(UIButton *)btn{
    NakedDriLibInfo *dInfo = _textInfo.values[btn.tag];
    btn.selected = !btn.selected;
    dInfo.isSel = btn.selected;
}

@end

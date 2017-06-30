//
//  NakedDriSeaTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/1.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriSeaTableCell.h"
#import "CustomShapeBtn.h"
@implementation NakedDriSeaTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"textSCell";
    NakedDriSeaTableCell *imgCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (imgCell==nil) {
        imgCell = [[NakedDriSeaTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return imgCell;
}

- (void)setTopArr:(NSArray *)topArr{
    if (topArr) {
        _topArr = topArr;
        [UIView animateWithDuration:0.1 animations:^{
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        NSInteger total = _topArr.count;
        CGFloat rowWid = 60;
        CGFloat rowhei = 30;
        for (int i=0; i<total; i++) {
            UIButton *btn = [self creatBtn];
            btn.frame = CGRectMake(rowWid*i,0, rowWid, rowhei);
            if (i==1) {
                NSString *imgStr;
                if ([_string isEqualToString:@"weight_desc"]) {
                    imgStr = @"icon_sort_d";
                }else if ([_string isEqualToString:@"weight_asc"]){
                    imgStr = @"icon_sort_u";
                }else{
                    imgStr = @"icon_sort";
                }
                UIButton *img = [UIButton buttonWithType:UIButtonTypeCustom];
                img.frame = CGRectMake(40, 0, 20, 30);
                [img setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
                [img addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn addSubview:img];
                [btn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (i==total-1) {
                btn.width = 100;
            }
            [btn setTitle:_topArr[i] forState:UIControlStateNormal];
        }
    }
}

- (void)setSeaInfo:(NakedDriSeaListInfo *)seaInfo{
    if (seaInfo) {
        _seaInfo = seaInfo;
        [UIView animateWithDuration:0.1 animations:^{
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        NSArray *arr = [self arrWithModel];
        NSInteger total = arr.count;
        CGFloat rowWid = 60;
        CGFloat rowhei = 30;
        for (int i=0; i<total; i++) {
            UIButton *btn = [self creatBtn];
            btn.frame = CGRectMake(rowWid*i,0, rowWid, rowhei);
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            if (i==0) {
                btn.selected = _seaInfo.isSel;
                [btn setImage:[UIImage imageNamed:@"icon_select4"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"icon_select3"] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (i==total-2) {
                btn.width = 100;
            }
            if (i==total-1) {
                btn.x = rowWid*i+40;
                [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

- (NSArray *)arrWithModel{
    NSArray *arr = @[@"",[self str:_seaInfo.Weight],[self str:_seaInfo.Price],[self str:_seaInfo.Shape],[self str:_seaInfo.Color],[self str:_seaInfo.Purity],[self str:_seaInfo.Cut],[self str:_seaInfo.Polishing],[self str:_seaInfo.Symmetric],[self str:_seaInfo.Fluorescence],[self str:_seaInfo.CertAuth],[self str:_seaInfo.CertCode],@"报价"];
    return arr;
}

- (NSString *)str:(NSString *)mes{
    NSString *arrStr;
    if (mes.length>0) {
        arrStr = mes;
    }else{
        arrStr = @"";
    }
    if ([mes containsString:@"."]) {
        NSRange range = [mes rangeOfString:@"."];
        if (mes.length>range.location+2) {
            mes = [mes substringToIndex:range.location+3];
        }
        arrStr = mes;
    }
    return arrStr;
}

- (UIButton *)creatBtn{
    CustomShapeBtn *btn = [CustomShapeBtn buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [btn setLayerWithW:0.001 andColor:BordColor andBackW:0.5];
    [self.contentView addSubview:btn];
    return btn;
}

- (void)sortClick:(id)sender{
    NSString *imgStr;
    if ([_string isEqualToString:@"weight_desc"]) {
        imgStr = @"weight_asc";
    }else if ([_string isEqualToString:@"weight_asc"]){
        imgStr = @"";
    }else{
        imgStr = @"weight_desc";
    }
    if (self.back) {
        self.back(YES,imgStr);
    }
}

- (void)btnClick:(id)sender{
    if (self.back) {
        self.back(NO,@"");
    }
}

- (void)subCateBtnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    _seaInfo.isSel = btn.selected;
}

@end

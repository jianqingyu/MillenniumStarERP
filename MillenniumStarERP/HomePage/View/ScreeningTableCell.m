//
//  ScreeningTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/22.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ScreeningTableCell.h"
#import "ScreenDetailInfo.h"
#import "StrWithIntTool.h"
@interface ScreeningTableCell()<UITextFieldDelegate>
//@property (nonatomic,strong)NSMutableArray *screenArr;
@property (nonatomic,strong)NSMutableArray *screenBtns;
@end
@implementation ScreeningTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"screenCell";
    ScreeningTableCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[ScreeningTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return addCell;
}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//    }
//    return self;
//}

- (void)setInfo:(ScreeningInfo *)info{
    if (info) {
        _info = info;
        self.screenBtns = @[].mutableCopy;
        [UIView animateWithDuration:0.1 animations:^{
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        if (!info.isOpen) {
            CGFloat height = 0;
            if (!info.mulSelect) {
                UIView *view = [self setupTextField];
                height = CGRectGetMaxY(view.frame);
            }
            NSInteger total = info.attributeList.count;
            for (int i=0; i<total; i++) {
                int row = i / COLUMN;
                int column = i % COLUMN;
                ScreenDetailInfo *dInfo = info.attributeList[i];
                UIButton *btn = [self creatBtn];
                btn.frame = CGRectMake(ROWSPACE + ROWWIDTH*column + ROWSPACE * column,height+ ROWSPACE + (ROWHEIHT + ROWSPACE)*row, ROWWIDTH, ROWHEIHT);
                btn.tag = i;
                btn.selected = dInfo.isSelect;
                [btn setTitle:dInfo.title forState:UIControlStateNormal];
                [self.screenBtns addObject:btn];
            }
        }
    }
}

- (UIView *)setupTextField{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(ROWSPACE, ROWSPACE, SDevWidth*0.8-20, ROWHEIHT)];
    view.backgroundColor = DefaultColor;
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    [self.contentView addSubview:view];
    UITextField *min = [self creatFieWithFrame:CGRectMake(5, 5, (view.width-30)/2, ROWHEIHT-10)];
    min.placeholder = @"最小值";
    min.delegate = self;
    UITextField *max = [self creatFieWithFrame:CGRectMake(view.width-min.width-5, 5, min.width, ROWHEIHT-10)];
    max.placeholder = @"最大值";
    max.delegate = self;
    [view addSubview:min];
    [view addSubview:max];
    self.minFie = min;
    self.maxFie = max;
    UILabel *lin = [[UILabel alloc]initWithFrame:CGRectMake(min.width+10, (ROWHEIHT-5)/2, 10, 5)];
    lin.text = @"~";
    [view addSubview:lin];
    return view;
}

- (UITextField *)creatFieWithFrame:(CGRect)frame{
    UITextField *min = [[UITextField alloc]initWithFrame:frame];
    min.borderStyle = UITextBorderStyleRoundedRect;
    min.textAlignment = NSTextAlignmentCenter;
    min.keyboardType = UIKeyboardTypeNumberPad;
    min.font = [UIFont systemFontOfSize:14];
    return min;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        for (int i=0; i<_info.attributeList.count; i++) {
            UIButton *sBtn = self.screenBtns[i];
            ScreenDetailInfo *dInfo = _info.attributeList[i];
            sBtn.selected = NO;
            dInfo.isSelect = NO;
        }
        if (self.minFie.text.length>0&&self.maxFie.text.length==0) {
            self.clickblock([NSString stringWithFormat:@"%@|",self.minFie.text]);
        }
        if (self.minFie.text.length==0&&self.maxFie.text.length>0) {
            self.clickblock([NSString stringWithFormat:@"|%@",self.maxFie.text]);
        }
        if (self.minFie.text.length>0&&self.maxFie.text.length>0) {
            self.clickblock([NSString stringWithFormat:@"%@|%@",self.minFie.text,self.maxFie.text]);
        }
    }
}

- (void)cleanTextFie{
    [self.minFie resignFirstResponder];
    [self.maxFie resignFirstResponder];
    self.minFie.text = @"";
    self.maxFie.text = @"";
}

- (UIButton *)creatBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:DefaultColor]
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:[CommonUtils createImageWithColor:CUSTOM_COLOR(248, 205, 207)] forState:UIControlStateSelected];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    return btn;
}

- (void)subCateBtnAction:(UIButton *)btn{
    ScreenDetailInfo *dInfo = _info.attributeList[btn.tag];
    if (!_info.mulSelect) {
        for (int i=0; i<_info.attributeList.count; i++) {
            UIButton *sBtn = self.screenBtns[i];
            ScreenDetailInfo *dInfo = _info.attributeList[i];
            if (i!=(int)btn.tag) {
                sBtn.selected = NO;
                dInfo.isSelect = NO;
            }
        }
        [self cleanTextFie];
    }
    btn.selected = !btn.selected;
    dInfo.isSelect = btn.selected;
}

@end

//
//  CustomProCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/13.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "CustomProCell.h"
#import "DetailStone.h"
#import "DetailTypeInfo.h"
@interface CustomProCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *numFie;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@property (weak, nonatomic) IBOutlet UIButton *mainBtn;
@end
@implementation CustomProCell
+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    CustomProCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[CustomProCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return addCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:
                        (NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomProCell" owner:nil options:nil][0];
        self.numFie.delegate = self;
        for (UIButton *btn in self.btns) {
            [btn setLayerWithW:3.0 andColor:DefaultColor andBackW:0.001];
        }
        [self.mainBtn setLayerWithW:3.0 andColor:DefaultColor andBackW:0.001];
        [self.priceLab setLayerWithW:3.0 andColor:DefaultColor andBackW:0.001];
        [self.priceLab setAdjustsFontSizeToFitWidth:YES];
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self setBtnBackLine];
    [self setNumberFie];
    if (self.tableBack) {
        self.tableBack(textField.text);
    }
}
//赋值
- (void)setTitleStr:(NSString *)titleStr{
    if (titleStr) {
        _titleStr = titleStr;
        self.titleLab.text = _titleStr;
        if (![_titleStr isEqualToString:@"主   石"]) {
            [self.mainBtn setTitle:@"封石" forState:UIControlStateNormal];
        }
    }
}

- (void)setNumber:(NSString *)number{
    if (number) {
        _number = number;
        self.numFie.text = _number;
    }
}

- (void)setIsSel:(BOOL)isSel{
    _isSel = isSel;
    self.mainBtn.selected = isSel;
}

- (void)setList:(NSArray *)list{
    if (list.count>0) {
        _list = list;
        if (![_titleStr isEqualToString:@"主   石"]&&_isSel) {
            [self clearAllViewStaue];
            return;
        }
        [self setBtnBackLine];
        [self setNumberFie];
        if ([self boolWithArr:list]) {
            [self setupPrice];
        }
    }
}
//设置红框方法
- (void)setBtnBackLine{
    BOOL isStaue = !self.mainBtn.selected&&([self boolWithOneArr:_list]||self.numFie.text.length>0);
    for (int i=0; i<self.list.count; i++) {
        if ([_list[i]isKindOfClass:[DetailTypeInfo class]]) {
            UIButton *btn = self.btns[i];
            DetailTypeInfo *info = _list[i];
            if (info.title.length>0) {
                [btn setTitle:info.title forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                if (isStaue) {
                    [btn setLayerWithW:3.0 andColor:MAIN_COLOR andBackW:0.5];
                }else{
                    [btn setLayerWithW:3.0 andColor:DefaultColor andBackW:0.001];
                }
            }
        }
    }
}
//设置数量红框
- (void)setNumberFie{
    BOOL isStaue = [self boolWithOneArr:_list]&&self.numFie.text.length==0&&!self.mainBtn.selected;
    if (isStaue) {
        [self.numFie setLayerWithW:3.0 andColor:MAIN_COLOR andBackW:0.5];
    }else{
        [self.numFie setLayerWithW:3.0 andColor:DefaultColor andBackW:0.001];
    }
}

//一个石头里面的数据至少有一个
- (BOOL)boolWithOneArr:(NSArray *)arr{
    for (DetailTypeInfo *info in arr) {
        if (info.title.length!=0) {
            return YES;
        }
    }
    return NO;
}
//一个石头里面的数据齐全
- (BOOL)boolWithArr:(NSArray *)arr{
    for (DetailTypeInfo *info in arr) {
        if (info.title.length==0) {
            return NO;
        }
    }
    return YES;
}
//获取价格
- (void)setupPrice{
    NSString *regiUrl = [NSString stringWithFormat:@"%@getStonePrice",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"categoryId"] = @([self infoWith:0].id);
    params[@"specValue"] = [self infoWith:1].title;
    params[@"colorId"] = @([self infoWith:3].id);
    params[@"purityId"] = @([self infoWith:4].id);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            self.priceLab.text = response.data[@"price"];
        }else{
            [MBProgressHUD showError:response.message];
        }
    }requestURL:regiUrl params:params];
}

- (DetailTypeInfo *)infoWith:(NSInteger)index{
    DetailTypeInfo *info = self.list[index];
    return info;
}

- (IBAction)btnClick:(UIButton *)sender {
    [self.numFie resignFirstResponder];
    NSInteger index = [self.btns indexOfObject:sender];
    if (self.tableBack) {
        self.tableBack(@(index));
    }
}

- (IBAction)mainStoneClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.tableBack) {
        self.tableBack(@{@"主石":@(sender.selected)});
    }
    if (![_titleStr isEqualToString:@"主   石"]) {
        if (sender.selected) {
            [self clearAllViewStaue];
        }else{
            self.numFie.text = self.number;
            [self setBtnBackLine];
            [self setNumberFie];
        }
        return;
    }
    [self setupAllBtnStaue:sender.selected];
    [self setNumberFie];
}
//设置按钮状态
- (void)setupAllBtnStaue:(BOOL)isMain{
    if (isMain) {
        for (UIButton *btn in self.btns) {
            [btn setLayerWithW:3.0 andColor:DefaultColor andBackW:0.001];
        }
    }else{
        for (int i=0; i<_list.count; i++) {
            UIButton *btn = self.btns[i];
            DetailTypeInfo *info = _list[i];
            if (info.title.length==0&&[self boolWithOneArr:_list]) {
                [btn setLayerWithW:3.0 andColor:MAIN_COLOR andBackW:0.5];
            }
        }
    }
}
//清空所有状态
- (void)clearAllViewStaue{
    NSArray *titleArr = @[@"类型",@"规格",@"形状",@"颜色",@"净度"];
    for (int i=0; i<self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setLayerWithW:3.0 andColor:DefaultColor andBackW:0.001];
    }
    self.numFie.text = @"";
    [self setNumberFie];
}

@end

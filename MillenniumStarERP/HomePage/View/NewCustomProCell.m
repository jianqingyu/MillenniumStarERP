//
//  NewCustomProCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/17.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewCustomProCell.h"
#import "DetailTypeInfo.h"
#import "StrWithIntTool.h"
@interface NewCustomProCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@end
@implementation NewCustomProCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"newCusCell";
    NewCustomProCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[NewCustomProCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"NewCustomProCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr{
    if (titleStr) {
        _titleStr = titleStr;
        self.titleLab.text = _titleStr;
        if ([_titleStr isEqualToString:@"主   石"]) {
            self.nextBtn.hidden = NO;
        }else{
            self.nextBtn.hidden = YES;
        }
    }
}

- (void)setList:(NSArray *)list{
    if (list) {
        _list = list;
        NSArray *titleArr = @[@"类型",@"规格",@"形状",@"颜色",@"净度"];
        NSMutableArray *mutA = [NSMutableArray new];
        if ([self boolWithOneArr]) {
            self.addBtn.hidden = YES;
            self.infoLab.hidden = NO;
            for (int i=0; i<_list.count; i++) {
                DetailTypeInfo *info = _list[i];
                if (info.title.length>0) {
                    NSString *str = [NSString stringWithFormat:@"%@:%@",titleArr[i],info.title];
                    [mutA addObject:str];
                }
            }
            self.infoLab.text = [StrWithIntTool strWithArr:mutA With:@","];
        }else{
            self.addBtn.hidden = NO;
            self.infoLab.hidden = YES;
        }
    }
}

- (void)setCertCode:(NSString *)certCode{
    if (certCode) {
        _certCode = certCode;
        if (_certCode.length>0&&[_titleStr isEqualToString:@"主   石"]) {
            self.infoLab.text = [NSString stringWithFormat:@"%@,证书编号:%@",self.infoLab.text,_certCode];
        }
    }
}
//一个石头里面的数据至少有一个
- (BOOL)boolWithOneArr{
    for (DetailTypeInfo *info in _list) {
        if (info.title.length!=0) {
            return YES;
        }
    }
    return NO;
}

@end
//
//  DeliveryOrderTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "DeliveryOrderTableCell.h"
@interface DeliveryOrderTableCell()
@property (nonatomic,strong)UIView *imgView;
@property (nonatomic,strong)UIView *LabView;
@property (nonatomic,weak)UILabel *titleLab;
@property (nonatomic,weak)UILabel *priceLab;
@property (nonatomic,weak)UILabel *detailLab;
@property (nonatomic,weak)UIImageView *imageV;
@property (nonatomic,weak)UILabel *detailLab2;
@end

@implementation DeliveryOrderTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"DeliveryCell";
    DeliveryOrderTableCell *tableCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (tableCell==nil) {
        tableCell = [[DeliveryOrderTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    return tableCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatImageView];
    }
    return self;
}

- (UILabel *)LabWithFont:(CGFloat)font andColor:(UIColor *)color{
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont systemFontOfSize:font];
    titleLab.textColor = color;
    [self addSubview:titleLab];
    return titleLab;
}

- (UILabel *)Lab:(CGFloat)font Color:(UIColor *)color andSup:(UIView *)supView{
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont systemFontOfSize:font];
    titleLab.textColor = color;
    [supView addSubview:titleLab];
    return titleLab;
}

- (void)creatImageView{
    self.titleLab = [self LabWithFont:16 andColor:[UIColor blackColor]];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(@20);
    }];
    
    self.priceLab = [self LabWithFont:16 andColor:[UIColor redColor]];
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(@20);
    }];
    
    UILabel *lab = [self LabWithFont:16 andColor:[UIColor blackColor]];
    lab.text = @"成本：";
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLab.mas_left).with.offset(0);
        make.top.equalTo(self).offset(10);
        make.height.mas_equalTo(@20);
    }];
    
    //文字视图
    self.LabView = [[UIView alloc]init];
    [self addSubview:self.LabView];
    [self.LabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).with.offset(15);
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-15);
        make.right.equalTo(self).offset(-15);
    }];
    
    self.detailLab = [self Lab:14 Color:[UIColor darkGrayColor] andSup:self.LabView];
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.LabView).offset(0);
        make.left.equalTo(self.LabView).offset(0);
    }];
    
    UIImageView *imgLog = [[UIImageView alloc]init];
    imgLog.image = [UIImage imageNamed:@"icon_down"];
    [self.LabView addSubview:imgLog];
    [imgLog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.LabView).offset(0);
        make.right.equalTo(self.LabView).offset(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    //图片列表
    self.imgView = [[UIView alloc]init];
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).with.offset(15);
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-15);
        make.right.equalTo(self).offset(-15);
    }];
    
    UIImageView *image = [[UIImageView alloc]init];
    [self.imgView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView).offset(0);
        make.top.equalTo(self.imgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    self.imageV = image;
    
    self.detailLab2 = [self Lab:14 Color:[UIColor darkGrayColor] andSup:self.imgView];
    self.detailLab2.numberOfLines = 0;
    [self.detailLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView).with.offset(0);
        make.left.equalTo(self.imageV.mas_right).with.offset(3);
        make.bottom.equalTo(self.imgView).offset(0);
        make.right.equalTo(self.imgView).offset(0);
    }];
    
    UIImageView *imgLog2 = [[UIImageView alloc]init];
    imgLog2.image = [UIImage imageNamed:@"icon_up"];
    [self.imgView addSubview:imgLog2];
    [imgLog2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgView).offset(0);
        make.right.equalTo(self.imgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)setDeliveryInfo:(DeliveryListInfo *)deliveryInfo{
    if (deliveryInfo) {
        _deliveryInfo = deliveryInfo;
        CGSize size = _deliveryInfo.isOpen?CGSizeMake(70, 70):CGSizeMake(0, 0);
        [self.imageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
        }];
        self.LabView.hidden = _deliveryInfo.isOpen;
        self.imgView.hidden = !_deliveryInfo.isOpen;
        NSString *title = [NSString stringWithFormat:@"%d %@ %@",self.index,_deliveryInfo.title,_deliveryInfo.ordernum];
        self.titleLab.text = title;
        self.priceLab.text = [NSString stringWithFormat:@"￥%0.2f",_deliveryInfo.price];
        self.detailLab.text = _deliveryInfo.sDetail;
        self.detailLab2.text = _deliveryInfo.detail;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:_deliveryInfo.pic] placeholderImage:DefaultImage];
    }
}

@end

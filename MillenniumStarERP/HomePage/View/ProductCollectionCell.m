//
//  ProductCollectionCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/9.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "ProductCollectionCell.h"
@interface ProductCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@end
@implementation ProductCollectionCell
//数据更新
- (void)setProInfo:(ProductInfo *)proInfo{
    if (proInfo) {
        _proInfo = proInfo;
        self.bottomV.hidden = self.isShow;
        self.titleLab.text = _proInfo.title;
        [self.headView sd_setImageWithURL:[NSURL URLWithString:_proInfo.pic]
                         placeholderImage:DefaultImage];
        self.priceLab.text = [NSString stringWithFormat:@"¥%0.2f",_proInfo.price];
    }
}

@end

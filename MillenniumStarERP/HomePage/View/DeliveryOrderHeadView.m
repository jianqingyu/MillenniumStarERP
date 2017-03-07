//
//  DeliveryOrderHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "DeliveryOrderHeadView.h"
@interface DeliveryOrderHeadView()
@property (weak, nonatomic) IBOutlet UILabel *cusName;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *deliveryNum;
@property (weak, nonatomic) IBOutlet UILabel *colorLab;
@property (weak, nonatomic) IBOutlet UILabel *goldLab;
@property (weak, nonatomic) IBOutlet UILabel *totalNum;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@end

@implementation DeliveryOrderHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"DeliveryOrderHeadView" owner:nil options:nil][0];
    }
    return self;
}

+ (id)createHeadView{
    return [[NSBundle mainBundle]loadNibNamed:@"DeliveryOrderHeadView" owner:nil options:nil][0];
}

@end

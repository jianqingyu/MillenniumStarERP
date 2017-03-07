//
//  SettlementHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementHeadView.h"
@interface SettlementHeadView()
@property (weak, nonatomic) IBOutlet UILabel *cusName;
@property (weak, nonatomic) IBOutlet UILabel *colorLab;
@property (weak, nonatomic) IBOutlet UILabel *comDate;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *dedate;
@property (weak, nonatomic) IBOutlet UILabel *orderDate;
@property (weak, nonatomic) IBOutlet UILabel *comNum;
@end
@implementation SettlementHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SettlementHeadView" owner:nil options:nil][0];
    }
    return self;
}

+ (id)createHeadView{
    return [[NSBundle mainBundle]loadNibNamed:@"SettlementHeadView" owner:nil options:nil][0];
}

@end

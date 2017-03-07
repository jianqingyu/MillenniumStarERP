//
//  SettlementFootView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/6.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementFootView.h"

@implementation SettlementFootView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SettlementFootView" owner:nil options:nil][0];
    }
    return self;
}

+ (id)createHeadView{
    return [[NSBundle mainBundle]loadNibNamed:@"SettlementFootView" owner:nil options:nil][0];
}

@end

//
//  SettlementListHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementListHeadView.h"
@interface SettlementListHeadView()
@end
@implementation SettlementListHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SettlementListHeadView" owner:nil options:nil][0];
    }
    return self;
}

+ (id)createHeadView{
    return [[NSBundle mainBundle]loadNibNamed:@"SettlementListHeadView" owner:nil options:nil][0];
}

- (IBAction)clickBtn:(id)sender {
    if (self.clickBack) {
        self.clickBack(YES);
    }
}

@end

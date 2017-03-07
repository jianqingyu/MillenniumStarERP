//
//  SettlementSecHedView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/6.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettlementSecHedView : UIView
+ (SettlementSecHedView *)creatView;
@property (nonatomic,weak)UILabel *tLab;
@property (nonatomic,weak)UILabel *priceLab;
@end

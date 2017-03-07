//
//  SettlementFootView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/6.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettlementFootView : UIView
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
+ (id)createHeadView;
@end

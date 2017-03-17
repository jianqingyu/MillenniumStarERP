//
//  CustomDatePick.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/15.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DateBack)(NSDate *dateMess);
@interface CustomDatePick : UIView
@property (nonatomic,copy)DateBack back;
+ (id)creatCustomView;
@end

//
//  DeliveryHeadInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryHeadInfo : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *ordernum;
@property (nonatomic,copy)NSString *delNum;
@property (nonatomic,copy)NSString *color;
@property (nonatomic,assign)double price;
@property (nonatomic,assign)double gold;
@property (nonatomic,assign)int num;
@end

//
//  DeliveryListInfo.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryListInfo : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *ordernum;
@property (nonatomic,copy)NSString *sDetail;
@property (nonatomic,copy)NSString *detail;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,assign)double price;
@property (nonatomic,assign)BOOL isOpen;
@end

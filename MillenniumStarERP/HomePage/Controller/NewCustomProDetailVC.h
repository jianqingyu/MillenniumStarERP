//
//  NewCustomProDetailVC.h
//  MillenniumStarERP
//
//  Created by yjq on 17/7/14.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^NewEditBack)(id orderInfo);
@interface NewCustomProDetailVC : BaseViewController
@property (nonatomic,assign)int proId;
@property (nonatomic,assign)int isEdit;
@property (nonatomic,  copy)NewEditBack orderBack;
@end

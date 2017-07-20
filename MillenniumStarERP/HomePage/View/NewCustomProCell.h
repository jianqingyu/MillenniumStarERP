//
//  NewCustomProCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/7/17.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCustomProCell : UITableViewCell
@property (nonatomic,  copy)NSString *titleStr;
@property (nonatomic,  copy)NSString *certCode;
@property (nonatomic,strong)NSArray *list;
+ (id)cellWithTableView:(UITableView *)tableView;
@end

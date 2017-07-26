//
//  EditCustomDriLibCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/7/21.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCustomDriLibCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,copy)NSString *topStr;
@property (nonatomic,copy)NSArray *libArr;
@property (nonatomic,copy)NSString *titleStr;
@end

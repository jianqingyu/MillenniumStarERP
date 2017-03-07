//
//  CustomLastCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQTextView.h"
typedef void (^CustomLastBack)(NSString *message);
@interface CustomLastCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet YQTextView *textView;
@property (copy, nonatomic) CustomLastBack messBack;
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,copy)NSString *message;
@end

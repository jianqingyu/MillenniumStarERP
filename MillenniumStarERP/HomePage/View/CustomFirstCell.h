//
//  CustomFirstCell.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CustomFirBack)(BOOL isSel,NSString*messArr);
@interface CustomFirstCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *fie1;
@property (weak, nonatomic) IBOutlet UIButton *handbtn;
@property (nonatomic, copy) NSString *messArr;
@property (nonatomic, copy) NSString *handSize;
@property (nonatomic, copy) CustomFirBack MessBack;
+ (id)cellWithTableView:(UITableView *)tableView;
@end

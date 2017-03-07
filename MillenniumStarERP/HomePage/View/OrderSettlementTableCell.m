//
//  OrderSettlementTableCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/6.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "OrderSettlementTableCell.h"

@implementation OrderSettlementTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"orderListCell";
    OrderSettlementTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[OrderSettlementTableCell alloc]initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"OrderSettlementTableCell" owner:nil options:nil][0];
    }
    return self;
}

@end

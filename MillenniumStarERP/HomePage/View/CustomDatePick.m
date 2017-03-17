//
//  CustomDatePick.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/15.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CustomDatePick.h"
@interface CustomDatePick()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePick;
@end
@implementation CustomDatePick

+ (id)creatCustomView{
    return [[NSBundle mainBundle]loadNibNamed:@"CustomDatePick" owner:nil options:nil][0];
}

- (IBAction)cancelClick:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)determineClick:(id)sender {
    if (self.back) {
        self.back([self.datePick date]);
    }
    [self removeFromSuperview];
}

@end

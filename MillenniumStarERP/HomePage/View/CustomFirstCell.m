//
//  CustomFirstCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "CustomFirstCell.h"
@interface CustomFirstCell()<UITextFieldDelegate>

@end
@implementation CustomFirstCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"firstCell";
    CustomFirstCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[CustomFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [addCell.btn setLayerWithW:3.0 andColor:BordColor andBackW:0.5];
        [addCell.fie1 setLayerWithW:3.0 andColor:BordColor andBackW:0.001];
        [addCell.handbtn setLayerWithW:3.0 andColor:BordColor andBackW:0.5];
    }
    return addCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomFirstCell" owner:nil options:nil][0];
        self.fie1.delegate = self;
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (![textField.text isEqualToString:@"0.5"]&&[textField.text containsString:@"."]) {
        [MBProgressHUD showError:@"请填写正确件数"];
        textField.text = @"";
    }
    if (self.MessBack) {
        self.MessBack(YES,textField.text);
    }
}

- (IBAction)handClick:(id)sender {
    if (self.MessBack) {
        self.MessBack(NO,@"");
    }
}

- (IBAction)accClick:(id)sender {
    float str = [self.fie1.text floatValue];
    if (str==0) {
        return;
    }
    str--;
    [self backText:str];
}

- (IBAction)addClick:(id)sender {
    float str = [self.fie1.text floatValue];
    str++;
    [self backText:str];
}

- (void)backText:(float)str{
    NSString *string = [NSString stringWithFormat:@"%0.1f",str];
    if ([string rangeOfString:@".5"].location != NSNotFound) {
        self.fie1.text = string;
    }else{
        self.fie1.text = [NSString stringWithFormat:@"%0.0f",str];
    }
    if (self.MessBack) {
        self.MessBack(YES,self.fie1.text);
    }
}

- (void)setMessArr:(NSString *)messArr{
    if (messArr) {
        _messArr = messArr;
        self.fie1.text = _messArr;
    }
}

- (void)setHandSize:(NSString *)handSize{
    if (handSize) {
        _handSize = handSize;
    }
    [self.handbtn setTitle:_handSize forState:UIControlStateNormal];
}

@end

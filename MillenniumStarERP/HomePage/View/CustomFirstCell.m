//
//  CustomFirstCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "CustomFirstCell.h"
@interface CustomFirstCell()<UITextFieldDelegate>
@property (nonatomic,strong)NSMutableArray *arr;
@end
@implementation CustomFirstCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"firstCell";
    CustomFirstCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[CustomFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [addCell.btn setLayerWithW:3.0 andColor:DefaultColor andBackW:0.001];
        [addCell.fie1 setLayerWithW:3.0 andColor:DefaultColor andBackW:0.001];
        [addCell.fie2 setLayerWithW:3.0 andColor:DefaultColor andBackW:0.001];
    }
    return addCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomFirstCell" owner:nil options:nil][0];
        self.fie1.tag = 1;
        self.fie2.tag = 2;
        self.fie1.delegate = self;
        self.fie2.delegate = self;
        self.arr = @[@"",@""].mutableCopy;
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==1) {
        if (![textField.text isEqualToString:@"0.5"]&&[textField.text containsString:@"."]) {
            [MBProgressHUD showError:@"请填写正确件数"];
            textField.text = @"";
        }
    }
    [self.arr setObject:textField.text atIndexedSubscript:textField.tag-1];
    if (self.MessBack) {
        self.MessBack(self.arr);
    }
}

- (void)setMessArr:(NSArray *)messArr{
    if (messArr) {
        _messArr = messArr;
        self.arr = _messArr.mutableCopy;
        self.fie1.text = _messArr[0];
        if (![_messArr[1] isEqualToString:@"0"]) {
            self.fie2.text = _messArr[1];
        }
    }
}

@end

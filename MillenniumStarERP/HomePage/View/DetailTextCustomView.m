//
//  DetailTextCustomView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/28.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "DetailTextCustomView.h"
#import "DetailTypeInfo.h"
@implementation DetailTextCustomView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
        UIView *back = [[UIView alloc]init];
        back.backgroundColor = [UIColor whiteColor];
        [self addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(300, 168));
        }];
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.font = [UIFont systemFontOfSize:18];
        titleLab.backgroundColor = DefaultColor;
        titleLab.textAlignment = NSTextAlignmentCenter;
        [back addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(back).offset(0);
            make.top.equalTo(back).offset(0);
            make.right.equalTo(back).offset(0);
            make.height.mas_equalTo(@44);
        }];
        self.topLab = titleLab;
        
        UITextField *textFie = [[UITextField alloc]init];
        textFie.borderStyle = UITextBorderStyleRoundedRect;
        textFie.textAlignment = NSTextAlignmentCenter;
        textFie.placeholder = @"请输入规格值";
        [back addSubview:textFie];
        [textFie mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(back).offset(10);
            make.top.equalTo(titleLab.mas_bottom).with.offset(20);
            make.right.equalTo(back).offset(-10);
            make.height.mas_equalTo(@44);
        }];
        self.scanfText = textFie;
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"确定" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        cancel.backgroundColor = DefaultColor;
        [back addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(back).offset(0);
            make.bottom.equalTo(back).offset(0);
            make.height.mas_equalTo(@44);
            make.right.equalTo(back).offset(0);
        }];
    }
    return self;
}

- (void)btnClick:(id)sender{
    if (self.scanfText.text.length==0) {
        [MBProgressHUD showError:@"请输入规格"];
        return;
    }
    NSString *regiUrl = [NSString stringWithFormat:@"%@CheckSpecificationsForm",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"value"] = self.scanfText.text;
    
    NSMutableDictionary *mud = @{}.mutableCopy;
    DetailTypeInfo *info = [DetailTypeInfo new];
    info.title = self.scanfText.text;
    mud[self.section] = info;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            
            if (self.textBack) {
                self.textBack(mud);
                [self removeFromSuperview];
            }
        }else{
            [MBProgressHUD showError:response.message];
        }
    }requestURL:regiUrl params:params];
}

@end

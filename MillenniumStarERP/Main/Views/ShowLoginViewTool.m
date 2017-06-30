//
//  ShowLoginViewTool.m
//  MillenniumStarERP
//
//  Created by yjq on 16/11/3.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ShowLoginViewTool.h"
#import "IQKeyboardManager.h"
#import "CusTomLoginView.h"
@implementation ShowLoginViewTool

+ (ShowLoginViewTool *)creatTool{
    static ShowLoginViewTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[ShowLoginViewTool alloc]init];
    });
    return _tool;
}

- (void)showLoginView:(BOOL)isBack{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    UIWindow *lastWindow = [UIApplication sharedApplication].keyWindow;
    lastWindow.frame = CGRectMake(0, 0, SDevWidth, SDevHeight);
    CusTomLoginView * cusLog = [CusTomLoginView createLoginView];
    cusLog.btnBack = ^(int isYes){
        if (isYes&&isBack) {
            [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
            [self upData];
        }
    };
    cusLog.frame = lastWindow.frame;
    [UIView animateWithDuration:0.5 animations:^{
        [lastWindow addSubview:cusLog];
    }];
    SHOWALERTVIEW(@"请重新登录");
}

- (void)upData{
    if (_dict.count==0||_url.length==0) {
        return;
    }
    _dict[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi upData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if (self.toBack) {
                self.toBack(response);
            }
        }
    }URL:_url params:_dict];
}

@end

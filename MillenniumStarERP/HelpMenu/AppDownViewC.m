//
//  AppDownViewC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/8.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "AppDownViewC.h"

@interface AppDownViewC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;
@end

@implementation AppDownViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"版本下载";
    self.titleLab.text = self.dict[@"title"];
    self.codeImg.image = [UIImage imageNamed:self.dict[@"image"]];
}

- (IBAction)btnClick:(id)sender {
    UIApplication *application = [UIApplication sharedApplication];
//    NSString *str = @"itms-services://?action=download-manifest&url=https%3A%2F%2Fwww.pgyer.com%2Fapiv1%2Fapp%2Fplist%3FaId%3D13d7af0fc022f6c7db56913c4bc7cbc1%26_api_key%3D90266c3f38506a07ee9bfb3b5ea4fdd9";
    [application openURL:[NSURL URLWithString:self.dict[@"url"]]];
    application = nil;
}

@end

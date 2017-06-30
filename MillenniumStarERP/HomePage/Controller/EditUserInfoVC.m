//
//  EditUserInfoVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/7.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "EditUserInfoVC.h"
#import "PassWordViewController.h"
#import "EditAddressVC.h"
#import "AccountTool.h"
#import "EditPhoneNumVc.h"
#import "LoginViewController.h"
#import "CommonUsedTool.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
@interface EditUserInfoVC ()<UITableViewDelegate,UITableViewDataSource,
                 UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,  copy)NSString *url;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,  copy)NSArray *textArr;
@property (nonatomic,strong)NSMutableDictionary *mutDic;
@end

@implementation EditUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改资料";
    self.mutDic = [NSMutableDictionary new];
    [self setBaseViewData];
    [self loadUserInfoData];
}

- (void)setBaseViewData{
    self.textArr = @[@[@"用户名",@"修改头像",@"是否申请升级为定制用户",@"是否显示价格"],
                  @[@"修改密码",@"修改手机号码",@"管理地址",@"清理缓存",@"分享该应用"]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 80)];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = MAIN_COLOR;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 5;
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [footView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footView);
        make.size.mas_equalTo(CGSizeMake(SDevWidth-80, 44));
    }];
    self.tableView.tableFooterView = footView;
}

- (void)loadUserInfoData{
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@userModifyPage",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data]) {
                self.isShow = [response.data[@"isShowPrice"]intValue];
                if ([YQObjectBool boolForObject:response.data[@"headPic"]]) {
                    self.url = response.data[@"headPic"];
                }
                if ([YQObjectBool boolForObject:response.data[@"userName"]]) {
                    self.mutDic[@"用户名"] = response.data[@"userName"];
                }
                if ([YQObjectBool boolForObject:response.data[@"phone"]]) {
                    self.mutDic[@"修改手机号码"] = response.data[@"phone"];
                }
                if ([YQObjectBool boolForObject:response.data[@"address"]]) {
                    self.mutDic[@"管理地址"] = response.data[@"address"];
                }
                [self.tableView reloadData];
            }
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)cancelClick{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[LoginViewController alloc]init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.textArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = self.textArr[section];
    return list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==1) {
        return 80;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (tableCell == nil){
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"myCell"];
        tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        tableCell.textLabel.font = [UIFont systemFontOfSize:15];
        tableCell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        tableCell.detailTextLabel.numberOfLines = 2;
    }
    NSArray *arr = self.textArr[indexPath.section];
    NSString *key = arr[indexPath.row];
    tableCell.textLabel.text = key;
    NSString *detailStr = self.mutDic[key];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            tableCell.accessoryType = UITableViewCellAccessoryNone;
        }else if(indexPath.row==1){
            if ([key isEqualToString:@"修改头像"]) {
                UIImageView *imageView = [self creatImageView];
                tableCell.accessoryView = imageView;
            }
        }else if(indexPath.row==2){
            UISwitch *switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
            tableCell.accessoryView = switchBtn;
            [switchBtn addTarget:self action:@selector(changeClick:)
                forControlEvents:UIControlEventTouchUpInside];
        }else{
            UISwitch *switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
            [switchBtn setOn:self.isShow];
            tableCell.accessoryView = switchBtn;
            [switchBtn addTarget:self action:@selector(showPriceClick:)
                forControlEvents:UIControlEventTouchUpInside];
        }
    }
    tableCell.detailTextLabel.text = detailStr;
    return tableCell;
}

- (UIImageView *)creatImageView{
    CGFloat width = 70;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width,width)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    //设置头像
    if (self.image) {
        imageView.image = self.image;
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.url]placeholderImage:
                                              [UIImage imageNamed:@"head_nor"]];
    }
    [imageView setLayerWithW:35 andColor:[UIColor whiteColor] andBackW:3.0f];
    return imageView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            UITableViewCell *cell = [self tableView:tableView
                                               cellForRowAtIndexPath:indexPath];
            if (indexPath.row==1) {
                [self creatUIAlertView:cell];
            }
        }
            break;
        case 1:
            if (indexPath.row==0) {
                PassWordViewController *passVc = [[PassWordViewController alloc]init];
                passVc.title = @"修改密码";
                passVc.isForgot = NO;
                [self.navigationController pushViewController:passVc animated:YES];
            }else if(indexPath.row==1){
                [MBProgressHUD showSuccess:@"功能暂未开放"];
//                EditPhoneNumVc *editNum = [EditPhoneNumVc new];
//                [self.navigationController pushViewController:editNum animated:YES];
            }else if(indexPath.row==2){
                EditAddressVC *addVc = [EditAddressVC new];
                [self.navigationController pushViewController:addVc animated:YES];
            }else if(indexPath.row==3){
                [self clearTmpPics];
            }else{
                [MBProgressHUD showSuccess:@"功能暂未开放"];
//                [self setShare];
            }
            break;
        default:
            break;
    }
}

- (void)changeClick:(UISwitch *)btn{
    
}

- (void)showPriceClick:(UISwitch *)btn{
    NSString *url = [NSString stringWithFormat:@"%@UpdateIsShowPrice",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"value"] = @(btn.on);
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:@"更新成功"];
        }
    } requestURL:url params:params];
}

- (void)clearTmpPics{
    float tmpSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
    [[SDImageCache sharedImageCache] clearDisk];
    [MBProgressHUD showSuccess:clearCacheName];
}

- (void)setShare{
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:[UIImage imageNamed:@"传入的图片名"]
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:@"分享标题" type:SSDKContentTypeAuto];
    // 定制新浪微博的分享内容
    [shareParams SSDKSetupSinaWeiboShareParamsByText:@"定制新浪微博的分享内容"title:nil
                                               image:[UIImage imageNamed:@"传入的图片名"]
                                                 url:nil latitude:0 longitude:0
                                            objectID:nil type:SSDKContentTypeAuto];
    // 定制微信好友的分享内容
    [shareParams SSDKSetupWeChatParamsByText:@"定制微信的分享内容" title:@"title"
                                         url:[NSURL URLWithString:@"http://mob.com"]
                                  thumbImage:nil image:[UIImage imageNamed:@"传入的图片名"]
                                musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil
                                        type:SSDKContentTypeAuto  forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
    [ShareSDK showShareActionSheet:self.view items:nil shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
    }];
}

- (void)creatUIAlertView:(UIView *)cell{
    [NewUIAlertTool creatActionSheetPhoto:^{
        [self openAlbum];
    } andCamera:^{
        [self openCamera];
    } andCon:self andView:cell];
}

//打开相机
- (void)openCamera{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}
//打开相册
//TypePhotoLibrary > TypeSavedPhotosAlbum
- (void)openAlbum{
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}
//通过imagePickerController获取图片
- (void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = type;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:ipc animated:YES completion:nil];
    }];
}

#pragma mark -- UIImagePickerControllerDelagate
- (void)imagePickerController:(UIImagePickerController *)picker
                             didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //info中包含选择的图片 UIImagePickerControllerOriginalImage
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
        [self loadUpDateImage:image];
    }];
}
//上传图片
- (void)loadUpDateImage:(UIImage *)image{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *key = [AccountTool account].tokenKey;
    NSString *url = [NSString stringWithFormat:@"%@userModifyHeadPicDo?tokenKey=%@",baseUrl,key];
    [CommonUsedTool loadUpDate:^(NSDictionary *response, NSError *error) {
        NSString *imageStr;
        if ([response[@"error"]intValue]==0) {
            if ([YQObjectBool boolForObject:response[@"data"][@"headPic"]]) {
                imageStr = response[@"data"][@"headPic"];
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (self.editBack) {
                    self.editBack(imageStr);
                }
            }];
        }
    } image:image Dic:params Url:url];
}

@end

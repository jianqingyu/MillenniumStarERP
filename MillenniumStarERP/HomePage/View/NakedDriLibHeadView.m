//
//  NakedDriLibHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriLibHeadView.h"
#import "TTRangeSlider.h"
#import "NakedDriLibInfo.h"
@interface NakedDriLibHeadView()<TTRangeSliderDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topBtns;
@property (weak, nonatomic) IBOutlet UILabel *sliderLab1;
@property (weak, nonatomic) IBOutlet UILabel *sliderLab2;
@property (weak, nonatomic) IBOutlet TTRangeSlider *sliderView1;
@property (weak, nonatomic) IBOutlet TTRangeSlider *sliderView2;
@property (nonatomic,strong)NSMutableDictionary *mutDic;
@end
@implementation NakedDriLibHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"NakedDriLibHeadView" owner:nil options:nil][0];
        self.mutDic = @{}.mutableCopy;
        for (UIButton *btn in _topBtns) {
            [btn setLayerWithW:3 andColor:BordColor andBackW:0.5];
            [btn setBackgroundImage:[CommonUtils createImageWithColor:MAIN_COLOR] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        }
        [self setRangeSlider];
    }
    return self;
}

- (void)setInfo:(NakedDriLiblistInfo *)info{
    if (info) {
        _info = info;
        for (int i=0; i<_topBtns.count; i++) {
            NakedDriLibInfo *linfo = info.values[i];
            UIButton *btn = _topBtns[i];
            [btn setTitle:linfo.name forState:UIControlStateNormal];
            btn.selected = linfo.isSel;
        }
    }
}

- (void)setDicArr:(NSArray *)dicArr{
    if (dicArr) {
        _dicArr = dicArr;
        [self setSliderDataView];
    }
}

- (void)setSliderDataView{
    NSDictionary *dic = _dicArr[0];
    self.sliderView1.minValue = [dic[@"minimum"]intValue];
    self.sliderView1.maxValue = [dic[@"maximum"]intValue];
    self.sliderView1.selectedMinimum = [dic[@"minimum"]intValue];
    self.sliderView1.selectedMaximum = [dic[@"maximum"]intValue];
    [self setLabWithRed:self.sliderLab1 and:dic[@"title"] and:@""];
    
    NSDictionary *dic1 = _dicArr[1];
    self.sliderView2.minValue = [dic1[@"minimum"]intValue];
    self.sliderView2.maxValue = [dic1[@"maximum"]intValue];
    self.sliderView2.selectedMinimum = [dic1[@"minimum"]intValue];
    self.sliderView2.selectedMaximum = [dic1[@"maximum"]intValue];
    [self setLabWithRed:self.sliderLab2 and:dic1[@"title"] and:@""];
}

- (void)setRangeSlider{
    self.sliderView1.delegate = self;
    self.sliderView1.hideLabels = YES;
    self.sliderView1.handleImage = [UIImage imageNamed:@"icon_20"];
    self.sliderView1.selectedHandleDiameterMultiplier = 1;
    self.sliderView1.tintColorBetweenHandles = [UIColor redColor];
    self.sliderView1.lineHeight = 5;
    
    self.sliderView2.delegate = self;
    self.sliderView2.hideLabels = YES;
    self.sliderView2.handleImage = [UIImage imageNamed:@"icon_20"];
    self.sliderView2.selectedHandleDiameterMultiplier = 1;
    self.sliderView2.tintColorBetweenHandles = [UIColor redColor];
    self.sliderView2.lineHeight = 5;
}

#pragma mark TTRangeSliderViewDelegate
- (void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    if (sender == self.sliderView1) {
        NSString *slider = [NSString stringWithFormat:@"%0.1f ~ %0.1f",selectedMinimum, selectedMaximum];
        NSString *sDic = [NSString stringWithFormat:@"%0.1f,%0.1f",selectedMinimum, selectedMaximum];
        NSDictionary *dic = _dicArr[0];
        [self setLabWithRed:self.sliderLab1 and:dic[@"title"] and:slider];
        self.mutDic[dic[@"keyword"]] = sDic;
    }else if (sender == self.sliderView2){
        NSString *slider = [NSString stringWithFormat:@"%0.1f ~ %0.1f",selectedMinimum, selectedMaximum];
        NSString *sDic = [NSString stringWithFormat:@"%0.1f,%0.1f",selectedMinimum, selectedMaximum];
        NSDictionary *dic = _dicArr[1];
        [self setLabWithRed:self.sliderLab2 and:dic[@"title"] and:slider];
        self.mutDic[dic[@"keyword"]] = sDic;
    }
    if (self.back) {
        self.back(self.mutDic);
    }
}

- (void)setLabWithRed:(UILabel *)lab and:(NSString *)str and:(NSString *)num{
    NSString *redStr = str;
    if (num.length>0) {
        NSArray *b = [str componentsSeparatedByString:@")"];
        redStr = [NSString stringWithFormat:@"%@) %@",b[0],num];
    }
    NSRange range = [str rangeOfString:@")"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:redStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location+1,redStr.length-range.location-1)];
    lab.attributedText = attributedStr;
}

- (IBAction)accClick:(id)sender {
    int str = [self.numFie.text intValue];
    if (str==0) {
        return;
    }
    str--;
    self.numFie.text = [NSString stringWithFormat:@"%d",str];
}

- (IBAction)addClick:(id)sender {
    int str = [self.numFie.text intValue];
    str++;
    self.numFie.text = [NSString stringWithFormat:@"%d",str];
}

- (IBAction)topBtnClick:(UIButton *)sender {
    NSInteger idex = [self.topBtns indexOfObject:sender];
    NakedDriLibInfo *linfo = _info.values[idex];
    sender.selected = !sender.selected;
    linfo.isSel = sender.selected;
}

@end

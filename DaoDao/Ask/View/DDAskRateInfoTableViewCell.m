//
//  DDAskRateInfoTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/11/14.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskRateInfoTableViewCell.h"

@interface DDAskRateInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *labHappy;
@property (weak, nonatomic) IBOutlet UILabel *labUseful;
@property (weak, nonatomic) IBOutlet UIView *impressView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *impressHeight;
@end

@implementation DDAskRateInfoTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self labStyle:self.labHappy];
    [self labStyle:self.labUseful];
    [[self.impressView subviews] enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL * _Nonnull stop) {
        [self labStyle:lab];
    }];
}

- (void)labStyle:(UILabel *)lab
{
    lab.layer.cornerRadius = 27.0 / 2;
    lab.layer.borderColor = TextColor.CGColor;
    lab.layer.borderWidth = 1;
}

- (void)configureCellWithData:(id)data
{
    DDAsk *ask = (DDAsk *)data;
    DDRate *rate = nil;
    if (ask.isMyAsk) {
        rate = ask.answer.answerRate;
    } else {
        rate = ask.answer.askRate;
    }
    self.labHappy.text = rate.happy.boolValue ? @"愉快" : @"乏味";
    self.labUseful.text = rate.useful.boolValue ? @"有收获" : @"没有收获";

    NSArray *impressArray = rate.impress;
    if (impressArray.count <= 3) {
        self.impressHeight.constant = 47.0;
    } else {
        self.impressHeight.constant = 94.0;
    }

    for (UILabel *lab in self.impressView.subviews)
    {
        if (lab.tag < impressArray.count) {
            NSArray *strs = [impressArray[lab.tag] componentsSeparatedByString:@"@"];
            lab.text = [strs lastObject];
            lab.hidden = NO;
        } else {
            lab.hidden = YES;
        }
    }
}


@end

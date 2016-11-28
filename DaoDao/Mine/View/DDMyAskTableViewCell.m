//
//  DDMyAskTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/11/1.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDMyAskTableViewCell.h"

@interface DDMyAskTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
@property (weak, nonatomic) IBOutlet UILabel *labDemand;
@property (weak, nonatomic) IBOutlet UILabel *labDesc;

@end

@implementation DDMyAskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.labDesc.textColor = TextColor;
}

- (void)configureCellWithData:(id)data
{
    DDAsk *ask = (DDAsk *)data;
    NSInteger status = ask.status.integerValue;

    self.statusImgView.image = [ask statusImage];
    self.labDemand.text = ask.demand;

    if (status == DDAskPostSuccess ||
        status == DDAskWaitingHandOut ||
        status == DDAskWaitingAnswerInterest) {
        NSString *left = @"已派发给";
        NSString *right = @"人，请耐心等待响应者";
        NSString *text = [NSString stringWithFormat:@"%@%@%@", left, ask.answers, right];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attrStr setAttributes:@{NSForegroundColorAttributeName : MainColor} range:NSMakeRange(left.length, text.length - left.length - right.length)];

        self.labDesc.attributedText = attrStr;
    } else if ((status >= DDAskWaitingSendMeet &&
                status <= DDAskBothUnRate) ||
               status == DDAskAskerRate) {
        NSString *left = @"";
        NSString *right = @"个响应者正在解决您的需求";
        NSString *text = [NSString stringWithFormat:@"%@%@%@", left, ask.favorites, right];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attrStr setAttributes:@{NSForegroundColorAttributeName : MainColor} range:NSMakeRange(left.length, text.length - left.length - right.length)];

        self.labDesc.attributedText = attrStr;
    }
}

+ (BOOL)showDetailWithAsk:(DDAsk *)ask
{
    NSInteger status = ask.status.integerValue;
    if (status == DDAskPostSuccess ||
        status == DDAskWaitingHandOut ||
        status == DDAskWaitingAnswerInterest) {
        return YES;
    } else if ((status >= DDAskWaitingSendMeet &&
                status <= DDAskBothUnRate) ||
               status == DDAskAskerRate) {
        return YES;
    }
    return NO;
}

+ (CGFloat)cellHeightWithAsk:(DDAsk *)ask
{
    if ([self showDetailWithAsk:ask]) {
        return 94.0;
    } else {
        return 54.0;
    }
}

@end

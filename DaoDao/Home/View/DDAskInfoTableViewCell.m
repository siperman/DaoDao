//
//  DDAskInfoTableViewCell.m
//  DaoDao
//
//  Created by hetao on 16/9/30.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskInfoTableViewCell.h"
#import "SepView.h"

@interface DDAskInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UILabel *labStatus;

@property (weak, nonatomic) IBOutlet UILabel *labName; // 花名
@property (weak, nonatomic) IBOutlet UILabel *labGrade; // 届别
@property (weak, nonatomic) IBOutlet UILabel *labDemand; // 需求
@property (weak, nonatomic) IBOutlet UILabel *labRelation; // 关系
@end

@implementation DDAskInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bigView shadowStyle];
    [self.labDemand normalTextStyle];
    [self.btnLeft setTitleColor:ColorHex(@"707070")];
}

- (void)setAskInfo:(DDAsk *)askInfo
{
    _askInfo = askInfo;
    [self.imgHead sy_setThumbnailImageWithUrl:askInfo.user.headUrl];
    [self.imgGender setImage:askInfo.user.genderImage];

    self.labName.text = askInfo.user.title;
    self.labGrade.text = MajorGrade(askInfo.user.major, askInfo.user.grade);
    self.labDemand.text = askInfo.demand;
    self.labRelation.text = askInfo.user.relation;

    if (askInfo.status.integerValue  == DDAskWaitingAnswerInterest) {
        self.labStatus.hidden = YES;
        self.btnLeft.hidden = NO;
        self.btnRight.hidden = NO;
    } else {
        self.labStatus.hidden = NO;
        self.btnLeft.hidden = YES;
        self.btnRight.hidden = YES;
        self.labStatus.textColor = ColorHex(@"707070");
        NSInteger status = askInfo.status.integerValue;

        if (status == DDAskWaitingSendMeet) {
            self.labStatus.text = @"您已感兴趣";
        } else if (status == DDAskWaitingAgreeMeet) {
            self.labStatus.text = @"待赴约";
        } else if (status == DDAskWaitingMeet) {
            self.labStatus.text = @"待见面";
        } else if (status == DDAskAnswerRate ||
                   status == DDAskBothUnRate) {
            self.labStatus.text = @"待评价";
        } else if (status == DDAskAskerRate ||
                   status == DDAskBothRate) {
            self.labStatus.text = @"已完成";
        } else if (status == DDAskAnswerUninterested) {
            self.labStatus.text = @"您已不感兴趣";
            self.labStatus.textColor = CCCColor;
        } else {
            self.labStatus.text = @"已失效";
            self.labStatus.textColor = CCCColor;
        }
    }

    [self layoutIfNeeded];
}

- (IBAction)goUserPage:(UIButton *)sender
{
    DDUserHomePageViewController *vc = [DDUserHomePageViewController viewController];
    vc.userId = self.askInfo.user.uid;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (IBAction)disinterest:(UIButton *)sender
{
    [MobClick event:PieceDtl_uninterestBtn_click];
    [self.viewController showLoadingHUD];
    [SYRequestEngine disinterestAskWithId:_askInfo.aid
                                 callback:^(BOOL success, id response) {
                                     [self.viewController hideAllHUD];
                                     if (success) {
                                         _askInfo.status = @(DDAskAnswerUninterested);
                                         if ([self.delegete respondsToSelector:@selector(disinterest:)]) {
                                             [self.delegete disinterest:_askInfo];
                                         }
                                     } else {
                                         [self.viewController showRequestNotice:response];
                                     }
                                 }];
}

- (IBAction)interest:(UIButton *)sender
{
    [MobClick event:PieceDtl_interestBtn_click];
    [self.viewController showLoadingHUD];

    [SYRequestEngine interestAskWithId:_askInfo.aid
                              callback:^(BOOL success, id response) {
                                  [self.viewController hideAllHUD];
                                  if (success) {
                                      _askInfo.status = @(3); // 待约见
                                      if ([self.delegete respondsToSelector:@selector(interest:)]) {
                                          [self.delegete interest:_askInfo];
                                      }
                                  } else {
                                      [self.viewController showRequestNotice:response];
                                  }
                              }];
}

+ (CGFloat)cellHeight
{
    return 186.0;
}

@end

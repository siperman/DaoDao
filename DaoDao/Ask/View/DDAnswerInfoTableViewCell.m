//
//  DDAnswerInfoTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/11/2.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAnswerInfoTableViewCell.h"
#import "DDChatKitManager.h"
#import "DDRateViewController.h"

@interface DDAnswerInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;

@property (weak, nonatomic) IBOutlet UILabel *labName; // 花名
@property (weak, nonatomic) IBOutlet UILabel *labGrade; // 届别
@property (weak, nonatomic) IBOutlet UILabel *labRelation; // 关系
@property (weak, nonatomic) IBOutlet UILabel *labMeetTime;
@property (weak, nonatomic) IBOutlet UILabel *labStatus;

@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;

@property (nonatomic, strong) DDAsk *ask;
@end

@implementation DDAnswerInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.imgHead sy_round];
    [self.btnChat actionTransparentStyle];
    [self.btnAction actionStyle];
    self.btnChat.titleLabel.font = NormalTextFont;
    self.btnAction.titleLabel.font = NormalTextFont;
}

- (void)configureCellWithData:(id)data
{
    DDAsk *ask = (DDAsk *)data;
    DDUser *user = ask.answer.user;
    _ask = ask;

    [self.imgHead sy_setThumbnailImageWithUrl:user.headUrl];
    [self.imgGender setImage:user.genderImage];

    self.labName.text = user.nickName;
    self.labGrade.text = MajorGrade(user.major, user.grade);
    self.labRelation.text = user.relation;

    NSInteger status = ask.status.integerValue;
    if (status == DDAskWaitingSendMeet) {
        self.labStatus.text = @"已感兴趣";
        self.labStatus.textColor = MainColor;
        self.trailingConstraint.constant = 10.0;
        self.btnAction.hidden = YES;
    } else if (status == DDAskWaitingAgreeMeet) {
        self.labStatus.text = @"等待赴约";
        self.labStatus.textColor = SecondColor;
        self.trailingConstraint.constant = 10.0;
        self.btnAction.hidden = YES;
    } else if (status == DDAskWaitingMeet) {
        self.labStatus.text = @"等待见面";
        self.labStatus.textColor = MainColor;

        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:( kCFCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute ) fromDate:[NSDate dateWithTimeIntervalSince1970:ask.answer.meet.time.doubleValue]];

        NSString *timeStr = [NSString stringWithFormat:@"距离见面时间：%ld天%ld小时%ld分", components.day, components.hour, components.minute];
        self.labMeetTime.text = timeStr;
    } else if (status == DDAskBothUnRate ||
               status == DDAskAnswerRate) {
        self.labStatus.text = @"等待评价";
        self.labStatus.textColor = SecondColor;
        [self.btnAction setTitle:@"去评价"];
        self.btnChat.hidden = YES;
    } else if (status > 0) {
        self.labStatus.text = @"已完成评价！约见结束！";
        self.labStatus.textColor = MainColor;
        self.btnAction.hidden = YES;
        self.btnChat.hidden = YES;
    } else {
        self.labStatus.text = @"对方拒绝赴约，约见结束！";
        self.labStatus.textColor = TextColor;
        self.btnAction.hidden = YES;
        self.btnChat.hidden = YES;
    }
}

- (IBAction)chat:(UIButton *)sender
{
    [MobClick event:ChatBtn_click];

    if (_ask.answer.conversionId) {
        [DDChatKitManager exampleOpenConversationViewControllerWithConversaionId:_ask.answer.conversionId fromNavigationController:self.viewController.navigationController];
    }
}

// 深色按钮
- (IBAction)action:(UIButton *)sender
{
    NSInteger status = _ask.status.integerValue;

    if (status == DDAskBothUnRate ||
        status == DDAskAnswerRate) {
        // 去评价
        DDRateViewController *vc = [[DDRateViewController alloc] init];
        vc.ask = self.ask;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else {
        [self makeCall:_ask.answer.user.mobilePhone];
    }
}

+ (CGFloat)cellHeightWithAsk:(DDAsk *)ask
{
    if (ask.status.integerValue == DDAskWaitingMeet) {
        return 32.0 + 72.0 + 40.0;
    } else {
        return 72.0 + 40.0;
    }
}
@end

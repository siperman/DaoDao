//
//  DDAskMeetActionTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/11/4.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskMeetActionTableViewCell.h"
#import "DDChatKitManager.h"

@interface DDAskMeetActionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWithConstraint;

@property (nonatomic, strong) DDAsk *ask;
@end

@implementation DDAskMeetActionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.btnChat sy_round:kCornerRadius];
    [self.btnCall sy_round:kCornerRadius];
}

- (void)configureCellWithData:(id)data
{
    DDAsk *ask = (DDAsk *)data;
    _ask = ask;

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ask.answer.meet.time.doubleValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm";

    NSString *timeStr = [dateFormatter stringFromDate:date];
    NSString *text = [NSString stringWithFormat:@"时间：%@\n地点：%@ %@", timeStr, ask.answer.meet.city, ask.answer.meet.addr];
    self.labTime.text = text;

    if (ask.status.integerValue == DDAskWaitingMeet) {
        self.btnWithConstraint.constant = (SCREEN_WIDTH - 15.0)/2 - 12;
    } else {
        self.btnWithConstraint.constant = SCREEN_WIDTH - 24;
        self.btnCall.hidden = YES;
    }
}

- (IBAction)chat:(UIButton *)sender
{
    [MobClick event:ChatBtn_click];
    [DDChatKitManager exampleOpenConversationViewControllerWithConversaionId:_ask.answer.conversionId fromNavigationController:self.viewController.navigationController];
}

- (IBAction)call:(UIButton *)sender
{
    [self makeCall:_ask.answer.user.mobilePhone];
}

+ (CGFloat)cellHeight
{
    return 120.0;
}

@end

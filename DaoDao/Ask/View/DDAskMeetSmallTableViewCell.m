//
//  DDAskMeetSmallTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/11/9.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskMeetSmallTableViewCell.h"
#import "DDChatKitManager.h"
#import "DDRateViewController.h"

@interface DDAskMeetSmallTableViewCell ()
@property (nonatomic, strong) DDAsk *ask;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation DDAskMeetSmallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.button actionStyle];
}

- (void)configureCellWithData:(id)data
{
    DDAsk *ask = (DDAsk *)data;
    _ask = ask;

    if ([self isToRate]) {
        [self.button setTitle:@"评价TA"];
    } else {
        [self.button setTitle:@"聊一下"];
    }
}

- (BOOL)isToRate
{
    DDAsk *ask = self.ask;
    if (!ask.isMyAsk) {
        return (ask.status.integerValue == DDAskBothUnRate || ask.status.integerValue == DDAskAnswerRate);
    } else {
        return (ask.status.integerValue == DDAskBothUnRate || ask.status.integerValue == DDAskAskerRate);
    }
}

- (IBAction)action:(UIButton *)sender
{
    if ([self isToRate]) {
        DDRateViewController *vc = [[DDRateViewController alloc] init];
        vc.ask = self.ask;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else {
        [MobClick event:ChatBtn_click];
        [DDChatKitManager exampleOpenConversationViewControllerWithConversaionId:_ask.answer.conversionId fromNavigationController:self.viewController.navigationController];
    }
}


@end

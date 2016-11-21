//
//  DDAskerInfoTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/11/10.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskerInfoTableViewCell.h"
#import "DDChatKitManager.h"

@interface DDAskerInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;

@property (weak, nonatomic) IBOutlet UILabel *labName; // 花名
@property (weak, nonatomic) IBOutlet UILabel *labGrade; // 届别
@property (weak, nonatomic) IBOutlet UILabel *labRelation; // 关系

@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;

@property (nonatomic, strong) DDAsk *ask;
@end

@implementation DDAskerInfoTableViewCell

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
    DDUser *user = ask.user;
    _ask = ask;

    [self.imgHead sy_setThumbnailImageWithUrl:user.headUrl];
    [self.imgGender setImage:user.genderImage];

    self.labName.text = user.nickName;
    self.labGrade.text = MajorGrade(user.major, user.grade);
    self.labRelation.text = user.relation;

    NSInteger status = ask.status.integerValue;
    if (status != DDAskWaitingMeet) {
        self.btnAction.hidden = YES;
    }
}

- (IBAction)goUserPage:(UIButton *)sender
{
    DDUser *user = _ask.user;

    DDUserHomePageViewController *vc = [DDUserHomePageViewController viewController];
    vc.userId = user.uid;
    [self.viewController.navigationController pushViewController:vc animated:YES];
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
    [self makeCall:_ask.user.mobilePhone];
}

+ (CGFloat)cellHeightWithAsk:(DDAsk *)ask
{
    if (ask.status.integerValue == DDAskAnswerDisagreeMeet) {
        return 72.0;
    } else {
        return 72.0 + 40.0;
    }
}

@end

//
//  DDInvitationInfoTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/11/10.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDInvitationInfoTableViewCell.h"
#import "DDMeetDetailViewController.h"

@interface DDInvitationInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) DDAsk *ask;

@end

@implementation DDInvitationInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.button setTitleColor:SecondColor forState:UIControlStateNormal];

    self.button.layer.borderColor = MainColor.CGColor;
    self.button.layer.borderWidth = OnePixelHeight;
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = kCornerRadius;
}

- (void)configureCellWithData:(id)data
{
    DDAsk *ask = (DDAsk *)data;
    DDUser *user = ask.user;
    _ask = ask;
    self.labName.text = user.title;
}

- (IBAction)clickBtn:(UIButton *)sender
{
    DDMeetDetailViewController *vc = [DDMeetDetailViewController viewController];
    vc.conversationId = self.ask.answer.conversionId;

    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end

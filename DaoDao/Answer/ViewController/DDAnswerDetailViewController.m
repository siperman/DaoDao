//
//  DDAnswerDetailViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/2.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAnswerDetailViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "DDDemandInfoAnswerTableViewCell.h"
#import "DDAskerInfoTableViewCell.h"
#import "DDInvitationInfoTableViewCell.h"
#import "DDMeetNoticeTableViewCell.h"
#import "DDAskMeetSmallTableViewCell.h"
#import "DDDemandDescTableViewCell.h"

@interface DDAnswerDetailViewController ()

@end

@implementation DDAnswerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [MobClick event:YingjuDtlBtn_click];
    self.showHead = YES;
    [self.tableView registerNib:[DDDemandInfoAnswerTableViewCell class]];
    [self.tableView registerNib:[DDAskerInfoTableViewCell class]];
    [self.tableView registerNib:[DDInvitationInfoTableViewCell class]];
    [self.tableView registerNib:[DDMeetNoticeTableViewCell class]];
    [self.tableView registerNib:[DDAskMeetSmallTableViewCell class]];
    [self.tableView registerNib:[DDDemandDescTableViewCell class]];

    if (self.ask.status.integerValue == DDAskWaitingSendMeet) {
        self.showSmall = NO;
    } else {
        self.showSmall = YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.ask) {
        return 0;
    }

    NSInteger status = self.ask.status.integerValue;
    if (status == DDAskAnswerDisagreeMeet ||
        status == DDAskWaitingSendMeet) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class class = [self cellClassForRowAtIndexPath:indexPath];
    DDBaseTableViewCell *cell = [tableView dequeueCell:class indexPath:indexPath];

    [cell configureCellWithData:self.ask];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [DDAskerInfoTableViewCell cellHeightWithAsk:self.ask];
    }
    Class class = [self cellClassForRowAtIndexPath:indexPath];

    return [tableView fd_heightForCellWithIdentifier:[class defaultReuseIdentifier] cacheByIndexPath:indexPath configuration:^(DDBaseTableViewCell *cell) {
        [cell configureCellWithData:self.ask];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        self.showSmall = !self.showSmall;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark helper

- (Class)cellClassForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;

    if (section == 0) {
        return [DDAskerInfoTableViewCell class];
    } else if (section == 1) {
        if (self.ask.status.integerValue == DDAskWaitingSendMeet) {
            return [DDDemandDescTableViewCell class]; // 无见面时间
        }
        if (self.showSmall) {
            return [DDDemandInfoSmallTableViewCell class];
        } else {
            return [DDDemandInfoAnswerTableViewCell class];
        }
    } else {
        if (self.ask.status.integerValue == DDAskWaitingAgreeMeet) {
            return [DDInvitationInfoTableViewCell class];
        } else if (self.ask.status.integerValue == DDAskWaitingMeet) {
            return [DDMeetNoticeTableViewCell class];
        } else if (self.ask.status.integerValue >= DDAskAskerRate) {
            return [DDAskRateInfoTableViewCell class];
        } else {
            return [DDAskMeetSmallTableViewCell class];
        }
    }

    return [DDDemandInfoSmallTableViewCell class];
}

@end

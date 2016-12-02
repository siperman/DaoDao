//
//  DDAskMeetDetailViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/2.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskMeetDetailViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "DDAskMeetActionTableViewCell.h"
#import "DDDemandInfoMeetTableViewCell.h"
#import "DDAskMeetSmallTableViewCell.h"

@interface DDAskMeetDetailViewController ()

@end

@implementation DDAskMeetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:YuejianDtlBtn_click];

    self.showHead = YES;
    [self.tableView registerNib:[DDAskMeetActionTableViewCell class]];
    [self.tableView registerNib:[DDDemandInfoMeetTableViewCell class]];
    [self.tableView registerNib:[DDAskMeetSmallTableViewCell class]];

}

#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.ask) {
        return 0;
    }
    if (self.ask.status.integerValue == DDAskAnswerDisagreeMeet) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 &&
        ![self isFinish]) {
        return 2;
    }
    return 1;
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
    Class class = [self cellClassForRowAtIndexPath:indexPath];

    return [tableView fd_heightForCellWithIdentifier:[class defaultReuseIdentifier] cacheByIndexPath:indexPath configuration:^(DDBaseTableViewCell *cell) {
        [cell configureCellWithData:self.ask];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        self.showSmall = !self.showSmall;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark helper

- (Class)cellClassForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        if (row == 0) {
            return [DDUserInfoTableViewCell class];
        }
        if (self.showSmall) {
            return [DDDemandInfoSmallTableViewCell class];
        } else {
            return [DDDemandInfoMeetTableViewCell class];
        }
    } else if (section == 1) {
        if (self.ask.status.integerValue == DDAskWaitingAgreeMeet ||
            self.ask.status.integerValue == DDAskWaitingMeet) {
            return [DDAskMeetActionTableViewCell class];
        } else if (self.ask.status.integerValue == DDAskAnswerRate ||
                   self.ask.status.integerValue == DDAskBothRate) {
            return [DDAskRateInfoTableViewCell class];
        } else {
            // 只有一个按钮的cell
            return [DDAskMeetSmallTableViewCell class];
        }
    }

    return [DDDemandInfoSmallTableViewCell class];
}

- (BOOL)isFinish
{
    return (self.ask.status.integerValue == DDAskAnswerRate ||
            self.ask.status.integerValue == DDAskBothRate);
}
@end

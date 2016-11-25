//
//  DDAskDetailViewController.m
//  DaoDao
//
//  Created by hetao on 2016/10/9.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskDetailViewController.h"
#import "DDBaseTableViewCell.h"
#import "DDAnswerInfoTableViewCell.h"
#import "DDAskMeetDetailViewController.h"

#import "UITableView+FDTemplateLayoutCell.h"

@interface DDAskDetailViewController ()

@property (nonatomic, strong) NSMutableArray <DDAsk *>*answers;
@end

@implementation DDAskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:YuejuDtlBtn_click];

    [self.tableView registerNib:[DDAnswerInfoTableViewCell class]];
    if (self.ask.status.integerValue >= DDAskWaitingSendMeet ||
        self.ask.status.integerValue < 0) {
        [self requestAnswers];
        [self subscribeNotication:kUpdateAskInfoNotification selector:@selector(handleNotification:)];
    }

    if (self.ask.status.integerValue == DDAskPostSuccess ||
        self.ask.status.integerValue == DDAskWaitingHandOut ||
        self.ask.status.integerValue == DDAskWaitingAnswerInterest ||
        self.ask.status.integerValue == -2) {
        self.showSmall = NO;
    } else {
        self.showSmall = YES;
    }

}

#pragma mark Request

- (void)requestAnswers
{
    [self showLoadingHUD];
    [SYRequestEngine requestAnswerListWithAskId:self.ask.aid callback:^(BOOL success, id response) {
        [self hideAllHUD];
        if (success) {
            self.answers = [[DDAsk parseFromDicts:response[kPageKey][kResultKey]] mutableCopy];
            [self.tableView reloadData];
        } else {
            [self showRequestNotice:response];
        }
    }];
}

- (void)handleNotification:(NSNotification*) notification
{
    NSDictionary *userInfo = [notification userInfo];
    if ([userInfo isKindOfClass:[NSDictionary class]]) {
        DDAsk *oldAsk = userInfo[kOldAskKey];
        DDAsk *newAsk = userInfo[kNewAskKey];
        for (DDAsk *ask in self.answers) {
            if (oldAsk == ask) {
                NSInteger idx = [self.answers indexOfObject:oldAsk];
                [self.answers replaceObjectAtIndex:idx withObject:newAsk];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:idx + 1];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
        }
    }
}

#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.ask) {
        return 0;
    }

    if ([self isWaitingAnswer]) {
        return 2;
    } else {
        return self.answers.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class class = [self cellClassForRowAtIndexPath:indexPath];
    DDBaseTableViewCell *cell = [tableView dequeueCell:class indexPath:indexPath];

    NSInteger section = indexPath.section;

    if (section == 0) {
        [cell configureCellWithData:self.ask];
        return cell;
    }

    if ([self isWaitingAnswer]) {
        [cell configureCellWithData:self.ask];
    } else {
        DDAsk *ask = self.answers[section - 1];
        [cell configureCellWithData:ask];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;

    if (section == 0) {
        Class class = [self cellClassForRowAtIndexPath:indexPath];

        return [tableView fd_heightForCellWithIdentifier:[class defaultReuseIdentifier] cacheByIndexPath:indexPath configuration:^(DDBaseTableViewCell *cell) {
            [cell configureCellWithData:self.ask];
        }];
    }

    if ([self isWaitingAnswer]) {
        return [DDAskHandOutTableViewCell cellHeight];
    } else {
        DDAsk *ask = self.answers[section - 1];
        return [DDAnswerInfoTableViewCell cellHeightWithAsk:ask];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;

    if (section == 0) {
        self.showSmall = !self.showSmall;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (![self isWaitingAnswer]) {
        DDAsk *ask = self.answers[section - 1];
        DDAskMeetDetailViewController *vc = [[DDAskMeetDetailViewController alloc] init];
        vc.ask = ask;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark helper

- (Class)cellClassForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;

    if (section == 0) {
        if (self.showSmall) {
            return [DDDemandInfoSmallTableViewCell class];
        } else {
            return [DDDemandInfoTableViewCell class];
        }
    }

    if ([self isWaitingAnswer]) {
        return [DDAskHandOutTableViewCell class];
    } else {
        return [DDAnswerInfoTableViewCell class];
    }
}

- (BOOL)isWaitingAnswer
{
    NSInteger status = self.ask.status.integerValue;
    if (status == DDAskPostSuccess ||
        status == DDAskWaitingHandOut ||
        status == DDAskWaitingAnswerInterest) {
        return YES;
    } else {
        return NO;
    }
}


@end

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

#import "UITableView+FDTemplateLayoutCell.h"

@interface DDAskDetailViewController ()

@property (nonatomic, strong) NSArray <DDAsk *>*answers;
@end

@implementation DDAskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[DDAnswerInfoTableViewCell class]];
    if (self.ask.status.integerValue >= DDAskWaitingSendMeet) {
        [self requestAnswers];
    }
}

#pragma mark Request

- (void)requestAnswers
{
    [self showLoadingHUD];
    [SYRequestEngine requestAnswerListWithAskId:self.ask.aid callback:^(BOOL success, id response) {
        [self hideAllHUD];
        if (success) {
            self.answers = [DDAsk parseFromDicts:response[kPageKey][kResultKey]];
            [self.tableView reloadData];
        } else {
            [self showRequestNotice:response];
        }
    }];
}

#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.ask) {
        return 0;
    }

    NSInteger status = self.ask.status.integerValue;
    if (status == DDAskPostSuccess ||
        status == DDAskWaitingHandOut ||
        status == DDAskWaitingAnswerInterest) {
        return 2;
    } else {
        return self.answers.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class class = [self cellClassForRowAtIndexPath:indexPath];
    DDBaseTableViewCell *cell = [tableView dequeueCell:class indexPath:indexPath];

    NSInteger status = self.ask.status.integerValue;
    NSInteger section = indexPath.section;

    if (section == 0) {
        [cell configureCellWithData:self.ask];
        return cell;
    }

    if (status == DDAskPostSuccess ||
        status == DDAskWaitingHandOut ||
        status == DDAskWaitingAnswerInterest) {
        [cell configureCellWithData:self.ask];
    } else {
        DDAsk *ask = self.answers[section - 1];
        [cell configureCellWithData:ask];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger status = self.ask.status.integerValue;
    NSInteger section = indexPath.section;

    if (section == 0) {
        if (self.showSmall) {
            return [DDDemandInfoSmallTableViewCell cellHeight];
        } else {
            return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([DDDemandInfoTableViewCell class]) cacheByIndexPath:indexPath configuration:^(DDBaseTableViewCell *cell) {
                [cell configureCellWithData:self.ask];
            }];
        }
    }

    if (status == DDAskPostSuccess ||
        status == DDAskWaitingHandOut ||
        status == DDAskWaitingAnswerInterest) {
        return [DDAskHandOutTableViewCell cellHeight];
    } else {
        DDAsk *ask = self.answers[section - 1];
        return [DDAnswerInfoTableViewCell cellHeightWithAsk:ask];
    }
}

- (Class)cellClassForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger status = self.ask.status.integerValue;
    NSInteger section = indexPath.section;

    if (section == 0) {
        if (self.showSmall) {
            return [DDDemandInfoSmallTableViewCell class];
        } else {
            return [DDDemandInfoTableViewCell class];
        }
    }

    if (status == DDAskPostSuccess ||
        status == DDAskWaitingHandOut ||
        status == DDAskWaitingAnswerInterest) {
        return [DDAskHandOutTableViewCell class];
    } else {
        return [DDAnswerInfoTableViewCell class];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;

    if (section == 0) {
        self.showSmall = !self.showSmall;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end

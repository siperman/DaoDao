//
//  DDAskListViewModel.m
//  DaoDao
//
//  Created by hetao on 2016/11/1.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskListViewModel.h"
#import "DDBaseTableViewCell.h"
#import "DDMyAskTableViewCell.h"
#import "DDMyAnswerTableViewCell.h"

#import "DDAskDetailViewController.h"
#import "DDAnswerDetailViewController.h"

@interface DDAskListViewModel ()

@property (nonatomic, assign, getter=isFreshing) BOOL freshing;

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) BOOL hasNextPage;
@end

@implementation DDAskListViewModel

- (instancetype)init
{
    self = [super init];

    [self subscribeNotication:kUpdateAskInfoNotification selector:@selector(handleNotification:)];
    return self;
}

- (void)handleNotification:(NSNotification*) notification
{
    NSDictionary *userInfo = [notification userInfo];
    if ([userInfo isKindOfClass:[NSDictionary class]]) {
        DDAsk *oldAsk = userInfo[kOldAskKey];
        DDAsk *newAsk = userInfo[kNewAskKey];
        for (DDAsk *ask in self.dataArray) {
            if (oldAsk == ask) {
                NSInteger idx = [self.dataArray indexOfObject:oldAsk];
                [self.dataArray replaceObjectAtIndex:idx withObject:newAsk];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:idx];
                [self.viewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
        }
    }
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isMyAsk) {
        [tableView configureEmptyNoticeForDataSource:self.dataArray type:SYEmptyNoticeTypeEmptyMyAsk];
    } else {
        [tableView configureEmptyNoticeForDataSource:self.dataArray type:SYEmptyNoticeTypeEmptyMyAnswer];
    }
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger idx = indexPath.section;
    DDAsk *ask = [self.dataArray objectAtIndex:idx];
    if (self.isMyAsk) {
        DDMyAskTableViewCell *cell = [tableView dequeueCell:[DDMyAskTableViewCell class] indexPath:indexPath];

        [cell configureCellWithData:ask];
        return cell;
    } else {
        DDMyAnswerTableViewCell *cell = [tableView dequeueCell:[DDMyAnswerTableViewCell class] indexPath:indexPath];

        [cell configureCellWithData:ask];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isMyAsk) {
        NSInteger idx = indexPath.section;
        DDAsk *ask = [self.dataArray objectAtIndex:idx];
        return [DDMyAskTableViewCell cellHeightWithAsk:ask];
    } else {
        return [DDMyAnswerTableViewCell cellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 5.0 : CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger idx = indexPath.section;
    DDAsk *ask = [self.dataArray objectAtIndex:idx];

    if (ask.isMyAsk) {
        DDAskDetailViewController *vc = [[DDAskDetailViewController alloc] init];
        vc.ask = ask;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else {
        DDAnswerDetailViewController *vc = [[DDAnswerDetailViewController alloc] init];
        vc.ask = ask;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - refresh

- (void)setFreshing:(BOOL)freshing {
    _freshing = freshing;
    if (freshing == NO) {
        [self.viewController.tableView.mj_header endRefreshing];
    }
}

- (void)setHasNextPage:(BOOL)hasNextPage
{
    _hasNextPage = hasNextPage;
    if (hasNextPage) {
        [self.viewController.tableView.mj_footer endRefreshing];
    } else {
        [self.viewController.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)refresh {
    self.freshing = YES;
    [self requestDataWithPage:1];
}

- (void)loadMore
{
    if (!self.isFreshing) {
        self.freshing = YES;
        [self requestDataWithPage:self.currentPage + 1];
    }
}

- (void)requestDataWithPage:(NSInteger)page
{
    AZNetworkResultBlock callback = ^(BOOL success, id response) {
        self.freshing = NO;

        if (success) {
            NSArray *results = response[kPageKey][kResultKey];
            self.hasNextPage = [response[kPageKey][kHasNextPageKey] boolValue];
            self.currentPage = page;

            if (page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:[DDAsk parseFromDicts:results]];
            [self.viewController.tableView reloadData];

        } else {
            self.hasNextPage = NO;
            [self.viewController showRequestNotice:response];
        }
    };

    if (self.isMyAsk) {
        [SYRequestEngine requestMyAskListWithPageNumber:page
                                               callback:callback];
    } else {
        [SYRequestEngine requestMyAnswerListWithPageNumber:page
                                               callback:callback];
    }
}


#pragma mark - Getter

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end

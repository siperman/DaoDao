//
//  DDChessDetailViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/30.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDChessDetailViewController.h"
#import "DDAskInfoTableViewCell.h"
#import "DDReloadView.h"
#import "DDChatKitManager.h"
#import "LCCKUser.h"
#import "DDAnswerDetailViewController.h"
#import "DDUserFactory.h"

@interface DDChessDetailViewController () <DDAskInfoProtocol>

@property (nonatomic, strong) DDReloadView *reloadView;
@property (nonatomic, strong) NSMutableArray <DDAsk *>* answerList;

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) BOOL hasNextPage;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation DDChessDetailViewController

+ (instancetype)viewController
{
    DDChessDetailViewController *vc = [[DDChessDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [vc setHidesBottomBarWhenPushed:YES];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    /*
     *  all@industry : 我的行业 集合
     */
    if ([self.cid isEqualToString:@"all@industry"]) {
        self.title = @"我的行业";
    } else {
        self.title = self.cid;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[DDAskInfoTableViewCell class]];
    [self.tableView registerNib:[DDLoadingMoreTableViewCell class]];

    _answerList = [NSMutableArray array];
    self.view.backgroundColor = BackgroundColor;

    WeakSelf;
    self.tableView.mj_header = [MJRefreshHeader normalHeader];
    self.tableView.mj_header.refreshingBlock = ^{
        [weakSelf refreshAsk];
    };
    [self.tableView.mj_header beginRefreshing];

}

- (void)refreshAsk
{
    if (!self.isLoading) {
        self.isLoading = YES;
        [self requestDataWithPage:1];
    }
}

- (void)loadMore
{
    if (!self.isLoading) {
        self.isLoading = YES;
        [self requestDataWithPage:self.currentPage + 1];
    }
}

- (void)requestDataWithPage:(NSInteger)page
{
    [SYRequestEngine requestAnswerListWithChessId:self.cid
                                       pageNumber:page
                                    callback:^(BOOL success, id response) {
                                        [self endRefreshing];

                                        if (success) {
                                            NSArray *results = response[kPageKey][kResultKey];
                                            self.hasNextPage = [response[kPageKey][kHasNextPageKey] boolValue];
                                            self.currentPage = page;

                                            if (page == 1) {
                                                [self.answerList removeAllObjects];
                                            }
                                            [self.answerList addObjectsFromArray:[DDAsk parseFromDicts:results]];

                                            [self.reloadView removeFromSuperview];
                                            self.reloadView = nil;
                                            [self.tableView reloadData];
                                        } else {
                                            if (!self.reloadView) {
                                                WeakSelf;
                                                self.reloadView = [DDReloadView showReloadViewOnView:self.view reloadAction:^{
                                                    [weakSelf.tableView.mj_header beginRefreshing];
                                                }];
                                            } else {
                                                [self showRequestNotice:response];
                                            }
                                        }
                                    }];
}

- (void)endRefreshing
{
    [self.tableView.mj_header endRefreshing];
    self.isLoading = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self configureEmptyNoticeForDataSource:self.answerList type:SYEmptyNoticeTypeEmptyAsk];

    return self.hasNextPage ? self.answerList.count + 1 : self.answerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;

    if (row < self.answerList.count) {
        DDAskInfoTableViewCell *cell = [tableView dequeueCell:[DDAskInfoTableViewCell class] indexPath:indexPath];

        cell.askInfo = self.answerList[row];
        cell.delegete = self;

        return cell;
    } else {
        DDLoadingMoreTableViewCell *cell = [tableView dequeueCell:[DDLoadingMoreTableViewCell class] indexPath:indexPath];

        [self loadMore];

        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row < self.answerList.count ? [DDAskInfoTableViewCell cellHeight] : [DDLoadingMoreTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;

    if (row < self.answerList.count) {
        DDAsk *ask = self.answerList[row];
        if (ask.status.integerValue == DDAskAnswerUninterested) {
            [self showNotice:@"您已不感兴趣"];
        } else if (ask.status.integerValue != DDAskWaitingAnswerInterest) {
            DDAnswerDetailViewController *vc = [[DDAnswerDetailViewController alloc] init];
            vc.ask= self.answerList[row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark DDAskInfoProtocol

- (void)interest:(DDAsk *)askInfo
{
    NSInteger idx = [self.answerList indexOfObject:askInfo];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    // 缓存聊天用户信息
    [DDUserFactory cacheUser:[LCCKUser userTransform:askInfo.user]];

    // 去聊天室
    [DDChatKitManager exampleOpenConversationViewControllerWithConversaionId:askInfo.answer.conversionId fromNavigationController:self.navigationController];
    [self.tableView.mj_header beginRefreshing];
}

- (void)disinterest:(DDAsk *)askInfo
{
    NSInteger idx = [self.answerList indexOfObject:askInfo];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView.mj_header beginRefreshing];
}

@end

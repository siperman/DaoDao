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
    
    self.title = self.cid;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[DDAskInfoTableViewCell class]];
    [self.tableView registerNib:[DDLoadingMoreTableViewCell class]];

    _answerList = [NSMutableArray array];
    [self.refreshControl addTarget:self action:@selector(refreshAsk) forControlEvents:UIControlEventValueChanged];
    [self refreshAsk];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    if (page == 1) {
        [self showLoadingHUD];
    }
    [SYRequestEngine requestAnswerListWithChessId:self.cid
                                       pageNumber:page
                                    callback:^(BOOL success, id response) {
                                        [self hideAllHUD];
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
                                                    [weakSelf refreshAsk];
                                                }];
                                            } else {
                                                [self showRequestNotice:response];
                                            }
                                        }
                                    }];
}

- (void)endRefreshing
{
    [self.refreshControl endRefreshingSmoothly];
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

#pragma mark DDAskInfoProtocol

- (void)interest:(DDAsk *)askInfo
{
    [self.answerList removeObject:askInfo];
    [self.tableView reloadData];
    // 去聊天室
    [DDChatKitManager exampleOpenConversationViewControllerWithConversaionId:askInfo.answer.conversionId fromNavigationController:self.navigationController];
}

- (void)disinterest:(DDAsk *)askInfo
{
    [self.answerList removeObject:askInfo];
    [self.tableView reloadData];
}

@end

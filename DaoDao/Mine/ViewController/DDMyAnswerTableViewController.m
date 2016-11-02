//
//  DDMyAnswerTableViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/1.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDMyAnswerTableViewController.h"
#import "DDAskListViewModel.h"
#import "DDMyAnswerTableViewCell.h"

@interface DDMyAnswerTableViewController ()

@property (nonatomic, strong) NSMutableArray *asks;
@property (nonatomic, strong) DDAskListViewModel *viewModel;
@end

@implementation DDMyAnswerTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我响应的需求";
    self.view.backgroundColor = BackgroundColor;

    self.tableView.delegate = self.viewModel;
    self.tableView.dataSource = self.viewModel;
    [self.tableView registerNib:[DDMyAnswerTableViewCell class]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WeakSelf;
    self.tableView.mj_header = [MJRefreshHeader normalHeader];
    self.tableView.mj_header.refreshingBlock = ^{
        [weakSelf.viewModel refresh];
    };
    [self.tableView.mj_header beginRefreshing];

    self.tableView.mj_footer = [MJRefreshFooter normalFooter];
    self.tableView.mj_footer.refreshingBlock = ^{
        [weakSelf.viewModel loadMore];
    };
}

- (DDAskListViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[DDAskListViewModel alloc] init];
        _viewModel.viewController = self;
        _viewModel.isMyAsk = NO;
    }
    return _viewModel;
}

@end

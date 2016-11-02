//
//  DDMyAskTableViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/1.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDMyAskTableViewController.h"
#import "DDAskListViewModel.h"
#import "DDMyAskTableViewCell.h"

@interface DDMyAskTableViewController ()

@property (nonatomic, strong) NSMutableArray *asks;
@property (nonatomic, strong) DDAskListViewModel *viewModel;
@end

@implementation DDMyAskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我发布的需求";
    self.view.backgroundColor = BackgroundColor;

    self.tableView.delegate = self.viewModel;
    self.tableView.dataSource = self.viewModel;
    [self.tableView registerNib:[DDMyAskTableViewCell class]];
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
        _viewModel.isMyAsk = YES;
    }
    return _viewModel;
}

@end

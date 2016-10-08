//
//  DDChessDetailViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/30.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDChessDetailViewController.h"
#import "AppMacro.h"

@interface DDChessDetailViewController ()

@property (nonatomic, strong) NSMutableArray <DDAsk *>* answerList;

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) BOOL hasNextPage;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation DDChessDetailViewController

+ (instancetype)viewController
{
    DDChessDetailViewController *vc = [[DDChessDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.cid;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _answerList = [NSMutableArray array];
    [self.refreshControl addTarget:self action:@selector(refreshAsk) forControlEvents:UIControlEventValueChanged];
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
                                            
                                            [self.tableView reloadData];
                                        } else {
                                            [self showRequestNotice:response];
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
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

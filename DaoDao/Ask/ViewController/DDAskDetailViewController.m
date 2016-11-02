//
//  DDAskDetailViewController.m
//  DaoDao
//
//  Created by hetao on 2016/10/9.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskDetailViewController.h"
#import "DDBaseTableViewCell.h"

@interface DDAskDetailViewController ()

@property (nonatomic, strong) NSArray <DDAsk *>*answers;
@end

@implementation DDAskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.ask.status.integerValue >= DDAskWaitingSendMeet) {

    }
}

#pragma mark Request

- (void)requestAnswers
{
    [self showLoadingHUD];
    [SYRequestEngine requestAnswerListWithAskId:self.ask.aid callback:^(BOOL success, id response) {
        if (success) {
            self.answers = [DDAsk parseFromDicts:response[kPageKey][kResultKey]];

        }
    }];
}

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
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.ask) {
        return 0;
    }

    NSInteger status = self.ask.status.integerValue;
    if (status == DDAskPostSuccess ||
        status == DDAskWaitingHandOut ||
        status == DDAskWaitingAnswerInterest) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger status = self.ask.status.integerValue;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (status == DDAskPostSuccess ||
        status == DDAskWaitingHandOut) {

    }

    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end

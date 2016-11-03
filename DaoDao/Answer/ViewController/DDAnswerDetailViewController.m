//
//  DDAnswerDetailViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/2.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAnswerDetailViewController.h"

@interface DDAnswerDetailViewController ()

@end

@implementation DDAnswerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

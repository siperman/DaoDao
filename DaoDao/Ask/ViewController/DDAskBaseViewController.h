//
//  DDAskBaseViewController.h
//  DaoDao
//
//  Created by hetao on 2016/10/27.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDUserInfoTableViewCell.h"
#import "DDDemandInfoTableViewCell.h"
#import "DDDemandInfoSmallTableViewCell.h"
#import "DDAskHandOutTableViewCell.h"

@interface DDAskBaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *labHead;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) DDAsk *ask;
@property (nonatomic) BOOL showSmall; // 收起详情cell

- (Class)cellClassForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

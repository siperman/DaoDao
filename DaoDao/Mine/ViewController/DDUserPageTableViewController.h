//
//  DDUserPageTableViewController.h
//  DaoDao
//
//  Created by hetao on 2016/11/16.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDUserHomePageViewController.h"

@interface DDUserPageTableViewController : UITableViewController

@property (nonatomic, weak) DDUserHomePageViewController *parentVC;

- (void)freshWithUser:(DDUser *)user;
@end

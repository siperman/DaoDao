//
//  DDMeetTableViewController.h
//  DaoDao
//
//  Created by hetao on 2016/10/24.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMeetTableViewController : UITableViewController

@property (nonatomic, strong) DDAsk *ask;
@property (nonatomic, copy) SYVoidBlock callback;
+ (instancetype)viewController;

@end

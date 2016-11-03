//
//  DDAskListViewModel.h
//  DaoDao
//
//  Created by hetao on 2016/11/1.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDAskListViewModel : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<DDAsk *> *dataArray;
@property (nonatomic, weak) UITableViewController *viewController;
@property (nonatomic) BOOL isMyAsk;

- (void)refresh;
- (void)loadMore;

@end

//
//  DDMeetDetailViewController.h
//  DaoDao
//
//  Created by hetao on 2016/10/25.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

// 邀请函详情
@interface DDMeetDetailViewController : UIViewController

@property (nonatomic, strong) NSString *conversationId;
@property (nonatomic, copy) SYEditBlock callback;
+ (instancetype)viewController;

@end

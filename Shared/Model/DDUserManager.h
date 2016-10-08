//
//  DDUserManager.h
//  DaoDao
//
//  Created by hetao on 16/9/6.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDUser.h"
#import "DDNotificationManager.h"

@interface DDUserManager : NSObject

+ (instancetype)manager;

@property (nonatomic, readonly) BOOL isLogined;
@property (nonatomic, strong) DDUser *user;
@property (nonatomic, strong) DDNotificationManager *notificationManager;

@end

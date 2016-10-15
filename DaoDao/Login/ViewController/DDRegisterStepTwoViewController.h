//
//  DDRegisterStepTwoViewController.h
//  DaoDao
//
//  Created by hetao on 16/9/14.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDRegisterStepTwoViewController : UIViewController

@property (nonatomic, copy) DDUser *user;
@property (nonatomic, strong) NSString *inviteCode;

+ (instancetype)viewController;
@end

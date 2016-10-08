//
//  DDRegisterStepThreeViewController.h
//  DaoDao
//
//  Created by hetao on 16/9/14.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDRegisterStepThreeViewController : UIViewController

@property (nonatomic, strong) DDUser *user;
@property (nonatomic, strong) NSString *authCode; // 短信验证码
@property (nonatomic, strong) NSString *inviteCode; // 邀请码

+ (instancetype)viewController;
@end

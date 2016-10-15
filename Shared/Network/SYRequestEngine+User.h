//
//  SYRequestEngine+User.h
//  Soouya
//
//  Created by hetao on 16/5/18.
//  Copyright © 2016年 Soouya. All rights reserved.
//

#import "SYRequestEngine.h"


//###################################用户信息相关###################################
@interface SYRequestEngine (User)

+ (void)requestUserWithId:(NSString *)uid callback:(AZNetworkResultBlock)callback;

+ (void)requestUserWithIds:(NSString *)uids callback:(AZNetworkResultBlock)callback;

+ (void)updateUserInfo:(NSDictionary *)params
                avatar:(UIImage *)avatar
              callback:(AZNetworkResultBlock)callback;

+ (void)updateUser:(AZNetworkResultBlock)callback;

@end

//###################################登录登出注册###################################
@interface SYRequestEngine (Login)

+ (void)userLoginWithPhone:(NSString *)phone code:(NSString *)pwd callback:(AZNetworkResultBlock)callback;

+ (void)userLogout:(AZNetworkResultBlock)callback;

+ (void)registerNewUserWithParams:(NSDictionary *)params
                           avatar:(UIImage *)avatar
                         callback:(AZNetworkResultBlock)callback;

@end




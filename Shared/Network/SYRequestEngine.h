//
//  SYRequestEngine.h
//  Soouya
//
//  Created by hetao on 1/19/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYNetworkManager.h"

OBJC_EXPORT NSString * kHostUrl;
OBJC_EXPORT NSString * kPicHostUrl;

@interface SYRequestEngine : NSObject

// 未读消息红点数
+ (void)requestCountCallback:(AZNetworkResultBlock)callback;

// 系统配置
+ (void)requestConfigCallback:(AZNetworkResultBlock)callback;

// 反馈
+ (void)sendFeedback:(NSString *)content
             contact:(NSString *)contact
            callback:(AZNetworkResultBlock)callback;

@end

//#####################################Chess######################################
@interface SYRequestEngine (Chess)

// 获取棋子列表
+ (void)requestChessCallback:(AZNetworkResultBlock)callback;

// 清除棋子未读消息
+ (void)cleanChessWithId:(NSString *)cid
                callback:(AZNetworkResultBlock)callback;

@end

//#####################################Check######################################
@interface SYRequestEngine (Check)

+ (void)checkVerifyCode:(NSString *)phone
                   code:(NSString *)code
               callback:(AZNetworkResultBlock)callback;

@end

//#####################################短信验证码######################################
#pragma mark --outbox
@interface SYRequestEngine (outbox)

+ (void)requestVerifyCodeWithPhone:(NSString *)phone
                          callback:(AZNetworkResultBlock)callback;

+ (void)requestVerifyCodeWithParams:(NSDictionary *)params
                           callback:(AZNetworkResultBlock)callback;

@end



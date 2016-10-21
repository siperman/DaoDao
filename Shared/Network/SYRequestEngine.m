//
//  SYRequestEngine.m
//  Soouya
//
//  Created by hetao on 1/19/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import "SYRequestEngine.h"
#import "SYPrefManager.h"
#import "UIImage+SYScale.h"
#import "NSString+MD5Addition.h"

#if DEBUG
NSString * kHostUrl = @"http://devapi.daodaoclub.com/v1";
//NSString * kHostUrl = @"http://testapi.daodaoclub.com/v1";
#else
NSString * kHostUrl = @"http://apidaodao.soouya.com/v1";
#endif
NSString * kPicHostUrl = @"http://img.daodaoclub.com";

// 剩余次数
static NSString * const kCountPath                             = @"/count/{_model}";

//搜索
static NSString * const kConfigPath                            = @"/config/my";

//反馈
static NSString * const kFeedbackPath                          = @"/feedback";

@interface SYRequestEngine ()

@property (nonatomic, readwrite) BOOL networkReachable;

@end

@implementation SYRequestEngine

+ (void)requestCountWithParams:(NSDictionary *)params callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kCountPath)
                       method:SYRequestMethodGet
                       params:params
                         body:nil
                     callback:callback];
}

+ (void)requestConfigCallback:(AZNetworkResultBlock)callback;
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kConfigPath)
                       method:SYRequestMethodGet
                       params:nil
                         body:nil
                     callback:callback];
}

+ (void)sendFeedback:(NSString *)content
             contact:(NSString *)contact
            callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kFeedbackPath)
                                   method:SYRequestMethodPost
                                   params:@{
                                            @"content" : content,
                                            @"contact" : contact,
                                            }
                                     body:nil
                                 callback:callback];
}

@end

static NSString * const kChessListPath                      = @"/chess";
static NSString * const kCleanChessPath                     = @"/chess/{id}";

//#####################################Chess######################################
@implementation SYRequestEngine (Chess)

// 获取棋子列表
+ (void)requestChessCallback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kChessListPath)
                                   method:SYRequestMethodGet
                                   params:nil
                                     body:nil
                                 callback:callback];

}

// 清除棋子未读消息
+ (void)cleanChessWithId:(NSString *)cid
                callback:(AZNetworkResultBlock)callback;

{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kChessListPath)
                                   method:SYRequestMethodDelete
                                   params:@{kIDKey : cid}
                                     body:nil
                                 callback:callback];

}

@end


//#####################################Check######################################
// 校验验证码
#pragma mark - Check

static NSString * const kUserVerifySMSPath                     = @"/check/verifyCode";
@implementation SYRequestEngine (Check)

+ (void)checkVerifyCode:(NSString *)phone code:(NSString *)code callback:(AZNetworkResultBlock)callback
{
    NSDictionary *params = @{ kPhoneKey : phone,
                              @"code" : code,
                              };
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kUserVerifySMSPath)
                       method:SYRequestMethodGet
                       params:params
                         body:nil
                     callback:callback];
}

@end


//#####################################短信验证码######################################
//短信接口
static NSString * const kUserRequestSMSVerifyPath              = @"/code";

@implementation SYRequestEngine (outbox)

+ (void)requestVerifyCodeWithParams:(NSDictionary *)params callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kUserRequestSMSVerifyPath)
                       method:SYRequestMethodPost
                       params:params
                         body:nil
                     callback:callback];
}

+ (void)requestVerifyCodeWithPhone:(NSString *)phone callback:(AZNetworkResultBlock)callback
{
    NSDictionary *params = @{ @"mobilePhone" : phone,
                              @"key" : [phone stringFromMD5],
                              @"type" : @"sms",
                              };
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kUserRequestSMSVerifyPath)
                       method:SYRequestMethodPost
                       params:params
                         body:nil
                     callback:callback];
}

@end

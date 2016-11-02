//
//  SYRequestEngine+Ask.m
//  DaoDao
//
//  Created by hetao on 16/9/27.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "SYRequestEngine+Ask.h"

static NSString * const kAskPath                            = @"/ask";
static NSString * const kAskInfoPath                        = @"/ask/{id}";
static NSString * const kAskInterestPath                    = @"/ask/{id}?_function=interest"; // 感兴趣2->3
static NSString * const kAskDisinterestPath                 = @"/ask/{id}?_function=disinterest"; // 不感兴趣2->-6
static NSString * const kAskInvitePath                      = @"/ask/{id}?_function=invite"; // 发邀请函3->4
static NSString * const kAskAgreePath                       = @"/ask/{id}?_function=agree"; // 同意赴约4->5
static NSString * const kAskDisagreePath                    = @"/ask/{id}?_function=disagree"; // 不同意赴约4->-5
static NSString * const kRateAskPath                        = @"/ask/{id}?_function=rateAsk"; // 评价约局人6->7或8-9
static NSString * const kRateAnswerPath                     = @"/ask/{id}?_function=rateAnswer"; // 评价应局人6->8或7->9

@implementation SYRequestEngine (Ask)

// 我的约局列表
+ (void)requestMyAskListWithPageNumber:(NSInteger)page
                              callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kAskPath)
                                   method:SYRequestMethodGet
                                   params:@{kFunctionKey : @"listMyAsk",
                                            kPageNumberKey : @(page)}
                                     body:nil
                                 callback:callback];
}

// 我的应局列表
+ (void)requestMyAnswerListWithPageNumber:(NSInteger)page
                                 callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kAskPath)
                                   method:SYRequestMethodGet
                                   params:@{kFunctionKey : @"listMyAnswer",
                                            kPageNumberKey : @(page)}
                                     body:nil
                                 callback:callback];
}

// 首页棋子应局列表
+ (void)requestAnswerListWithChessId:(NSString *)cid
                          pageNumber:(NSInteger)page
                            callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kAskPath)
                                   method:SYRequestMethodGet
                                   params:@{kFunctionKey : @"listMyAnswer",
                                            @"chessId" : cid,
                                            kPageNumberKey : @(page)}
                                     body:nil
                                 callback:callback];
}

// 应局列表
+ (void)requestAnswerListWithAskId:(NSString *)aid
                          callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kAskPath)
                                   method:SYRequestMethodGet
                                   params:@{kFunctionKey : @"listMyAsk",
                                            @"id" : aid}
                                     body:nil
                                 callback:callback];
}

// 发布约局
+ (void)sendAskWithParams:(NSDictionary *)params callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kAskPath)
                                   method:SYRequestMethodPost
                                   params:params
                                     body:nil
                                 callback:callback];
}

// 获取约应局详情
+ (void)requestAskInfoWithId:(NSString *)aid callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kAskInfoPath)
                                   method:SYRequestMethodGet
                                   params:@{kIDKey : aid}
                                     body:nil
                                 callback:callback];
}


// 感兴趣约局
+ (void)interestAskWithId:(NSString *)aid callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kAskInterestPath)
                                   method:SYRequestMethodPut
                                   params:@{kIDKey : aid}
                                     body:nil
                                 callback:callback];

}

// 不感兴趣约局
+ (void)disinterestAskWithId:(NSString *)aid callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kAskDisinterestPath)
                                   method:SYRequestMethodPut
                                   params:@{kIDKey : aid}
                                     body:nil
                                 callback:callback];
}

// 发送邀请函
+ (void)inviteAnswerWithParams:(NSDictionary *)params callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kAskInvitePath)
                                   method:SYRequestMethodPut
                                   params:params
                                     body:nil
                                 callback:callback];
}

// 同意赴约
+ (void)agreeAskInviteWithId:(NSString *)aid callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kAskAgreePath)
                                   method:SYRequestMethodPut
                                   params:@{kIDKey : aid}
                                     body:nil
                                 callback:callback];
}

// 不同意赴约
+ (void)disagreeAskInviteWithId:(NSString *)aid callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kAskDisagreePath)
                                   method:SYRequestMethodPut
                                   params:@{kIDKey : aid}
                                     body:nil
                                 callback:callback];
}

// 评价约局人
+ (void)rateAskWithParams:(NSDictionary *)params callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kRateAskPath)
                                   method:SYRequestMethodPut
                                   params:params
                                     body:nil
                                 callback:callback];
}

// 评价应局人
+ (void)rateAnswerWithParams:(NSDictionary *)params callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kRateAnswerPath)
                                   method:SYRequestMethodPut
                                   params:params
                                     body:nil
                                 callback:callback];
}


@end

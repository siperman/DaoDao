//
//  SYRequestEngine+Ask.h
//  DaoDao
//
//  Created by hetao on 16/9/27.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "SYRequestEngine.h"

@interface SYRequestEngine (Ask)

// 我的约局列表
+ (void)requestMyAskListCallback:(AZNetworkResultBlock)callback;
// 我的应局列表
+ (void)requestMyAnswerListCallback:(AZNetworkResultBlock)callback;
// 首页棋子应局列表
+ (void)requestAnswerListWithChessId:(NSString *)cid
                          pageNumber:(NSInteger)page
                            callback:(AZNetworkResultBlock)callback;
// 发布约局
+ (void)sendAskWithParams:(NSDictionary *)params callback:(AZNetworkResultBlock)callback;
// 获取约应局详情
+ (void)requestAskInfoWithId:(NSString *)aid callback:(AZNetworkResultBlock)callback;


//###################################变更约局状态###################################
// 感兴趣约局
+ (void)interestAskWithId:(NSString *)aid callback:(AZNetworkResultBlock)callback;
// 不感兴趣约局
+ (void)disinterestAskWithId:(NSString *)aid callback:(AZNetworkResultBlock)callback;
// 发送邀请函
+ (void)inviteAnswerWithParams:(NSDictionary *)params callback:(AZNetworkResultBlock)callback;
// 同意赴约
+ (void)agreeAskInviteWithId:(NSString *)aid callback:(AZNetworkResultBlock)callback;
// 不同意赴约
+ (void)disagreeAskInviteWithId:(NSString *)aid callback:(AZNetworkResultBlock)callback;
// 评价约局人
+ (void)rateAskWithParams:(NSDictionary *)params callback:(AZNetworkResultBlock)callback;
// 评价应局人
+ (void)rateAnswerWithParams:(NSDictionary *)params callback:(AZNetworkResultBlock)callback;

@end

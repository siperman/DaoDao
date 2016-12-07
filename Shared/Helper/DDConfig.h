//
//  DDConfig.h
//  DaoDao
//
//  Created by hetao on 16/9/27.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDConfig : NSObject

// 评价标签女
+ (NSArray <NSDictionary*>*)femaleRate;
// 评价标签男
+ (NSArray <NSDictionary*>*)maleRate;
// 感兴趣的话题
+ (NSArray <NSDictionary*>*)topic;
// 哪方面的专家
+ (NSArray <NSDictionary*>*)expert;
// 工作
+ (NSArray <NSDictionary*>*)job;
// 领域
+ (NSArray <NSDictionary*>*)industry;
// 学院届别
+ (NSArray <NSDictionary*>*)majorGrade;

+ (void)saveConfigDict:(NSDictionary *)dict;

+ (NSDictionary *)configDict;
// 请求配置文件失败需要调用
+ (void)configServiceCall;

@end

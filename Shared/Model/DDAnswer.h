//
//  DDAnswer.h
//  DaoDao
//
//  Created by hetao on 16/9/21.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLModel+Addition.h"

@class DDRate, DDMeet;
// 应局
@interface DDAnswer : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *isFavorite;//是否收藏，是否感兴趣
@property (nonatomic, copy) NSString *cancelReason;//取消原因
@property (nonatomic, copy) NSString *conversionId;//会话id

@property (nonatomic, strong) DDUser *user;
@property (nonatomic, strong) DDRate *askRate;
@property (nonatomic, strong) DDRate *answerRate;
@property (nonatomic, strong) DDMeet *meet;

@end


// 评价
@interface DDRate : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *useful;//是否有收获
@property (nonatomic, strong) NSNumber *happy;//是否愉快
@property (nonatomic, copy) NSArray <NSString *>* impress;//对人整体印象

@end

// 约见
@interface DDMeet : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *time;//见面时间
@property (nonatomic, copy) NSString *city;//市
@property (nonatomic, copy) NSString *addr;//详细地址
@end

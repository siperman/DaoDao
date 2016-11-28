//
//  DDAsk.h
//  DaoDao
//
//  Created by hetao on 16/9/21.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLModel+Addition.h"
#import "DDAnswer.h"

typedef NS_ENUM(NSInteger, DDAskStatus) {
    DDAskPostSuccess = 0,
    DDAskWaitingHandOut,
    DDAskWaitingAnswerInterest,
    DDAskWaitingSendMeet,
    DDAskWaitingAgreeMeet,
    DDAskWaitingMeet,

    DDAskBothUnRate,
    DDAskAnswerRate, // 约局单方已评, 对应局人做出了评价
    DDAskAskerRate,  // 应局单方已评, 对约局人做出了评价
    DDAskBothRate,

    DDAskAnswerDisagreeMeet = -5,
    DDAskAnswerUninterested = -6,
};

// 约局
@interface DDAsk : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *aid;//id
@property (nonatomic, readonly) NSString *type;//谁发起
@property (nonatomic, readonly) BOOL isMyAsk;//是否我发起
@property (nonatomic, copy) NSString *demand;//需求
@property (nonatomic, copy) NSArray <NSString *>* industry;//行业
@property (nonatomic, copy) NSArray <NSString *>* job;//职务
@property (nonatomic, copy) NSArray <NSString *>* expert;//专家
@property (nonatomic, strong) NSNumber *answers;//派发数
@property (nonatomic, strong) NSNumber *favorites;//感兴趣数
@property (nonatomic, copy) NSString *cancelReason;//取消原因
@property (nonatomic, strong) NSNumber *status;//0:约局发布成功,1:等待派发应局人,2:等待应局人感兴趣,3:待约见,4:待赴约,5:待见面,6:双方未评,7:约局单方已评,8:应局单方已评,9:双方已评,-5:应局人拒绝赴约,-4:应局人取消应局,-3:超时未回应应局人,-1:约局已取消,-2:已失效, ,
@property (nonatomic, strong) NSNumber *createTime;

@property (nonatomic, strong) DDAnswer *answer;
@property (nonatomic, strong) DDUser *user;

- (UIImage *)statusImage;

@end



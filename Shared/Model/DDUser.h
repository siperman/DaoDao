//
//  DDUser.h
//  DaoDao
//
//  Created by hetao on 16/9/6.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLModel+Addition.h"

#define MajorGrade(major, grade) [NSString stringWithFormat:@"%@%@期", major, grade]

@class DDRateTag;
@interface DDUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *uid;//id
@property (nonatomic, copy) NSString *title;//显示名称
@property (nonatomic, copy) NSString *mobilePhone;//注册手机号
@property (nonatomic, copy) NSString *headUrl;//头像
@property (nonatomic, copy) NSString *nickName;//花名
@property (nonatomic, copy) NSString *realName;//姓名
@property (nonatomic, strong) NSNumber *gender;//0:男,1:女
@property (nonatomic, copy) NSString *major;//攻读方向
@property (nonatomic, strong) NSNumber *grade;//届别
@property (nonatomic, copy) NSArray <NSString *>* job;//职务
@property (nonatomic, copy) NSArray <NSString *>* industry;//所属行业
@property (nonatomic, strong) NSNumber *year;//从业时间
@property (nonatomic, copy) NSString *company;//企业名称
@property (nonatomic, copy) NSString *province;//企业所在省
@property (nonatomic, copy) NSString *city;//企业所在市
@property (nonatomic, copy) NSArray <NSString *>* expert;//哪方面专家/擅长领域
@property (nonatomic, copy) NSArray <NSString *>* topic;//感兴趣话题
@property (nonatomic, copy) NSArray <DDRateTag *>* tags;//评价标签
@property (nonatomic, strong) NSNumber *showMsgDetail;//通知显示消息详情开关
@property (nonatomic, copy) NSString *inviteCode;//邀请码
@property (nonatomic, strong) NSNumber *status;//-2:被管理员删除,-1:冻结,0:待生成验证码,1:已生成验证码,2:已注册

@property (nonatomic, strong) NSNumber *lastMeetTime;//最后一次见面时间
@property (nonatomic, strong) NSNumber *meetTimes;//见过次数
@property (nonatomic, strong) NSNumber *isMeeting;//是否正在约见
@property (nonatomic, strong) NSNumber *integrity;//完整率
@property (nonatomic, readonly) NSString *relation;//关系

- (UIImage *)genderImage;
@end

// 评价
@interface DDRateTag : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *tag;
@property (nonatomic, strong) NSNumber *count;
@end

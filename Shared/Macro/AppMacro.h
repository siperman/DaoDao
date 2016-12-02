// 
//  AppMacro 
//  Soouya 
//  
//  Created by hetao on 01/19/2015 
//  Copyright (c) 2014 hetao. All rights reserved. 
// 
#ifndef DaoDao_AppMacro_h
#define DaoDao_AppMacro_h

//输入文本验证
typedef NS_ENUM(NSUInteger, SYValidationType) {
    SYValidationTypeUsername, //用户名:长度大于2小于13
    SYValidationTypePassword, //密码:长度大于5小于21
    SYValidationTypePhone, //手机号验证
    SYValidationTypeNotEmpty, //文本不为空验证
    SYValidationTypeEqual, //相等验证
    SYValidationTypeNewSpec, //长度大于0小于21
    SYValidationTypeValid, //默认有效
};

//登录成功后的block
typedef void(^loginCallback)(void);
//常用block
typedef void(^SYVoidBlock)(void);
typedef BOOL(^SYBOOLBlock)(void);
typedef void(^SYEditBlock)(NSString *);

//接口字段名常量
static NSString * const kFunctionKey                              = @"_function";
static NSString * const kIDKey                                    = @"id";
static NSString * const kNicknameKey                              = @"nickName";
static NSString * const kRealnameKey                              = @"realName";
static NSString * const kPageNumberKey                            = @"pageNumber";
static NSString * const kHasNextPageKey                           = @"hasNextPage";
static NSString * const kPageKey                                  = @"page";
static NSString * const kResultKey                                = @"result";
static NSString * const kValueKey                                 = @"value";
static NSString * const kValuesKey                                = @"values";
static NSString * const kUserKey                                  = @"user";
static NSString * const kSuccessKey                               = @"success";
static NSString * const kMsgKey                                   = @"msg";
static NSString * const kTypeKey                                  = @"type";
static NSString * const kDemandKey                                = @"demand";
static NSString * const kObjKey                                   = @"obj";
static NSString * const kPhoneKey                                 = @"mobilePhone";
static NSString * const kCodeKey                                  = @"code";
static NSString * const kInviteCodeKey                            = @"inviteCode";
static NSString * const kJobKey                                   = @"job";
static NSString * const kIndustryKey                              = @"industry";
static NSString * const kYearKey                                  = @"year";
static NSString * const kExpertKey                                = @"expert";
static NSString * const kTopicKey                                 = @"topic";
static NSString * const kMajorKey                                 = @"major";
static NSString * const kGradeKey                                 = @"grade";
static NSString * const kHeadUrlKey                               = @"headUrl";
static NSString * const kUsernameKey                              = @"userName";
static NSString * const kJsessionidKey                            = @"jsessionid";
static NSString * const kCurrentDeviceToken                       = @"deviceToken";
static NSString * const kAddrKey                                  = @"addr";
static NSString * const kCityKey                                  = @"city";
static NSString * const kAreaKey                                  = @"area";
static NSString * const kProvinceKey                              = @"province";
static NSString * const kTelKey                                   = @"tel";
static NSString * const kTitleKey                                 = @"title";
static NSString * const kModelKey                                 = @"_model";
static NSString * const kLeaveMessageKey                          = @"leaveMessage";
static NSString * const kOldAskKey                                = @"oldAsk";
static NSString * const kNewAskKey                                = @"newAsk";


static NSString * const kKeywordKey                               = @"keyWord";
static NSString * const kCompositionKey                           = @"composition";
static NSString * const kTechnologyKey                            = @"typeTechnology";
static NSString * const kUsageKey                                 = @"usage";
static NSString * const kCreateTimeKey                            = @"createTime";

static NSString * const kKeyKey                                   = @"key";
static NSString * const kTagsKey                                  = @"tags";
static NSString * const kImgUrlKey                                = @"imgUrl";
static NSString * const kImgUrlsKey                               = @"imgUrls";
static NSString * const kCanUserDefineKey                         = @"userDefined";

static NSString * const kTagsIconKey                              = @"icon";
static NSString * const kTagsNameKey                              = @"name";
static NSString * const kTagsIDKey                                = @"id";
static NSString * const kTagsTypeKey                              = @"type";
static NSString * const kTagsValueKey                             = @"value";

static NSString * const kThumbnailResolution                      = @"@500w";
static NSString * const kMaxThumbnailResolution                   = @"@300w_300h";
static NSString * const kPictureQuality                           = @"_80Q";

//服务电话
OBJC_EXPORT NSString * kServiceCall;

//通用常量
static CGFloat kAnimationDuration                                 = 0.25;//动画时长
static CGFloat kCornerRadius                                      = 4.0; //圆角大小
static CGFloat kShadowRadius                                      = 2.0; //阴影大小
static CGFloat kBorderWidth                                       = 1.0; //边框宽度
static CGFloat kAvatarCropMaxRatio                                = 5.0; //头像裁剪时的最大缩放比例
static NSInteger kMaxSelectedFabricsCount                         = 9; //最多可选的面料数
static NSInteger kDefaultMargin                                   = 12; //默认边距
static NSInteger kDefaultPageSize                                 = 30; //默认分页加载的个数
static NSInteger kVerifyCodeWaitingDuration                       = 60; //验证码按钮enbale
static CGFloat kDefaultHideNoticeIntervel                         = 1.5; //
static NSTimeInterval kDefaultRequestTimeout                      = 15.0; //网络请求超时时间
static NSTimeInterval kDefaultRequestWithFileTimeout              = 60.0;

//提示wording
static NSString * const kEmptyUsernameNotice                      = @"请填写手机号";
static NSString * const kEmptyPasswordNotice                      = @"请填写密码";
static NSString * const kLoginSuccessNotice                       = @"登录成功";
static NSString * const kLogoutSuccessNotice                      = @"退出登录成功";
static NSString * const kPhoneInvalidNotice                       = @"请填写有效的手机号";
static NSString * const kUnregisterPhoneNotice                    = @"该手机号没有注册";
static NSString * const kEmptyAuthCodeNotice                      = @"请填写验证码";
static NSString * const kUsernameInvalidNotice                    = @"请填写3~12个字符用户名";
static NSString * const kRegisterSuccessNotice                    = @"注册成功";
static NSString * const kResetPasswordSuccessNotice               = @"更改密码成功";
static NSString * const kEmptyTelNotice                           = @"请填写电话";
static NSString * const kEmptyAddrNotice                          = @"请填写地址";
static NSString * const kGetLocationFailNotice                    = @"获取地理位置失败";
static NSString * const kEmptyProvinceNotice                      = @"请选择省、市、区";
static NSString * const kEmptyDetailAddrNotice                    = @"请填写详细地址";
static NSString * const kUploadAvatarSuccessNotice                = @"头像上传成功";
static NSString * const kUploadAvatarFailNotice                   = @"头像上传失败";


// Notification
static NSString * const kUserDidChangeLoggingStateNotification = @"kUserDidChangeLoggingStateNotification"; //用户已改变log状态
static NSString * const kLoginPhoneWriteBackNotification       = @"kLoginPhoneWriteBackNotification"; //登录手机号写回调
static NSString * const kUserDidLogoutNotification             = @"kUserDidLogoutNotification";
static NSString * const kNewIMMessageNotification              = @"kNewIMMessageNotification"; //新im消息
static NSString * const kUpdateUnreadCountNotification         = @"kUpdateUnreadCountNotification"; //更新未读消息
static NSString * const kUpdateUserInfoNotification            = @"kUpdateUserInfoNotification"; //更新用户信息
static NSString * const kShowWelcomeNotification               = @"kShowWelcomeNotification"; //欢迎界面
static NSString * const kPostAskSuccessNotification            = @"kPostAskSuccessNotification"; //发布约局成功
static NSString * const kUpdateAskInfoNotification             = @"kUpdateAskInfoNotification"; //更新约局信息
static NSString * const kUpdateIMAskInfoNotification             = @"kUpdateIMAskInfoNotification"; //更新IM约局信息
static NSString * const kClickEmptyViewNotification            = @"kClickEmptyViewNotification"; //点击空视图按钮
static NSString * const DDDateSettingChangedNotification       = @"DDDateSettingChangedNotification"; //时间制式更改

// Cache
static NSString * const kLastSysNotificationsCacheKey    = @"kLastSysNotificationsCacheKey"; //最后一条系统消息
static NSString * const ConversationListCacheKey         = @"LCCKConversationListViewModel"; //消息列表




#endif

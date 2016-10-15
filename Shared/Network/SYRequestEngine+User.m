//
//  SYRequestEngine+User.m
//  Soouya
//
//  Created by hetao on 16/5/18.
//  Copyright © 2016年 Soouya. All rights reserved.
//

#import "SYRequestEngine+User.h"
#import "SYPrefManager.h"
#import "NSString+MD5Addition.h"

//更新用户信息
static NSString * const kUserInfoPath                          = @"/user/{id}";
static NSString * const kCurrentUserInfoPath                   = @"/token/my";
static NSString * const kUserLoginPath                         = @"/token";
static NSString * const kUserUpdatePath                        = @"/user/my?_function=updateInfo";

@implementation SYRequestEngine (User)

+ (void)requestUserWithId:(NSString *)uid callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kUserInfoPath)
                                   method:SYRequestMethodGet
                                   params:@{kIDKey : uid}
                                     body:nil
                                 callback:callback];
}

+ (void)requestUserWithIds:(NSString *)uids callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kUserInfoPath)
                                   method:SYRequestMethodGet
                                   params:@{@"ids" : uids}
                                     body:nil
                                 callback:callback];
}

+ (void)updateUserInfo:(NSDictionary *)params avatar:(UIImage *)avatar callback:(AZNetworkResultBlock)callback
{
    if (avatar) {
        [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kUserUpdatePath)
                                       method:SYRequestMethodPut
                                       params:params
                                         body:^(id<AFMultipartFormData> formData) {
                                             if (avatar) {
                                                 NSString *timestamp = [NSString randomTimestamp];
                                                 NSData *imgData = UIImageJPEGRepresentation(avatar, 0.1);
                                                 [formData appendPartWithFileData:imgData
                                                                             name:@"file"
                                                                         fileName:[NSString stringWithFormat:@"%@.jpg", timestamp]
                                                                         mimeType:@"image/jpg"];
                                                 [formData appendPartWithFormData:[@"headUrl" dataUsingEncoding:NSUTF8StringEncoding]
                                                                             name:@"field"];
                                             }
                                         }
                                     callback:callback];

    } else {
        [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kUserUpdatePath)
                                       method:SYRequestMethodPut
                                       params:params
                                         body:nil
                                     callback:callback];

    }
}

+ (void)updateUser:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kCurrentUserInfoPath)
                                   method:SYRequestMethodGet
                                   params:nil
                                     body:nil
                                 callback:callback];
}

@end

//#####################################login/register#################################################################

#pragma mark --login/register

//登录用户接口
static NSString * const kUserRegisterPath                      = @"/user";
static NSString * const kUserLogoutPath                        = @"/token/my";

@implementation SYRequestEngine (Login)

+ (void)userLoginWithPhone:(NSString *)phone code:(NSString *)pwd callback:(AZNetworkResultBlock)callback
{
    NSDictionary *params = @{
                             kPhoneKey : phone,
                             kCodeKey : pwd,
                             };
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kUserLoginPath)
                                   method:SYRequestMethodPost
                                   params:params
                                     body:nil
                                 callback:callback];
}

+ (void)userLogout:(AZNetworkResultBlock)callback
{
    POST_NOTIFICATION(kUserDidLogoutNotification, nil);
    
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kUserLogoutPath)
                                   method:SYRequestMethodDelete
                                   params:nil
                                     body:nil
                                 callback:callback];
}

+ (void)registerNewUserWithParams:(NSDictionary *)params avatar:(UIImage *)avatar callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kUserRegisterPath)
                                   method:SYRequestMethodPost
                                   params:params
                                     body:^(id<AFMultipartFormData> formData) {
                                         if (avatar) {
                                             NSString *timestamp = [NSString randomTimestamp];
                                             NSData *imgData = UIImageJPEGRepresentation(avatar, 0.1);
                                             [formData appendPartWithFileData:imgData
                                                                         name:@"file"
                                                                     fileName:[NSString stringWithFormat:@"%@.jpg", timestamp]
                                                                     mimeType:@"image/jpg"];
                                             [formData appendPartWithFormData:[@"headUrl" dataUsingEncoding:NSUTF8StringEncoding]
                                                                         name:@"field"];
                                         }
                                     }
                                 callback:callback];
}

@end


//
//  SYNetworkManager.m
//  Soouya
//
//  Created by hetao on 16/7/5.
//  Copyright © 2016年 Soouya. All rights reserved.
//

#import "SYNetworkManager.h"
#import "SystemServices.h"

@implementation SYNetworkManager

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }

        return nil;
    }

    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];

    [task resume];

    return task;
}

+ (void)startRequestWithUrl:(NSString *)url
                     method:(SYRequestMethod)method
                     params:(NSDictionary *)params
                       body:(void (^)(id <AFMultipartFormData> formData))block
                   callback:(AZNetworkResultBlock)callback
{
    debugLog(@"url: %@", url);

    // 替换url中类似 {id} 参数
    NSInteger leftLoc = [url rangeOfString:@"{"].location;
    if (leftLoc != NSNotFound) {
        NSInteger rightLoc = [url rangeOfString:@"}"].location;
        NSString *key = [url substringWithRange:NSMakeRange(leftLoc + 1, rightLoc - leftLoc - 1)];
        NSAssert(params[key], @"NO KEY SAY JB!");
        url = [url stringByReplacingCharactersInRange:NSMakeRange(leftLoc, rightLoc - leftLoc + 1) withString:params[key]];

        NSMutableDictionary *mp = [params mutableCopy];
        [mp removeObjectForKey:key];
        params = mp;
    }

    SYNetworkManager *manager = [self manager];
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:(params ?: @{})];

    // 配置请求头部
    {
        // 设置 user-agent
        SystemServices *services = [SystemServices sharedServices];
        NSString *userAgent = [NSString stringWithFormat:@"DaoDao/%@ (%@; %@)", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"], services.systemDeviceTypeFormatted, services.systemsVersion];
        [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];

        // 设置请求必带参数
        [p setValue:[SYUtils unifiedUUID] forKey:@"_uuid"];
        [p setValue:[NSString stringWithFormat:@"%@%@", [SYUtils carrierName], [SYUtils networkType]] forKey:@"_net"];
    }

    // 发送请求
    {
        void (^success)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
            if (task.state == NSURLSessionTaskStateCompleted &&
                [responseObject isKindOfClass:[NSDictionary class]] &&
                ([[responseObject valueForKey:kSuccessKey] integerValue] == 1)) {
                if (callback) {
                    callback(YES, responseObject);
                }
            } else {
                if (callback) {
                    callback(NO, responseObject);
                }
            }
        };

        void (^failure)(NSURLSessionDataTask * __nullable task, NSError *error) = ^(NSURLSessionDataTask * __nullable task, NSError *error) {
            if (callback) {
                callback(NO, error);
            }
        };

        if (method == SYRequestMethodGet) {
            [manager.requestSerializer setTimeoutInterval:kDefaultRequestTimeout];
            [manager GET:url parameters:p progress:nil success:success failure:failure];
        } else if (method == SYRequestMethodPut) {
            if (block) {
                [manager.requestSerializer setTimeoutInterval:kDefaultRequestWithFileTimeout];
                [manager PUT:url parameters:p constructingBodyWithBlock:block progress:nil success:success failure:failure];
            } else {
                [manager.requestSerializer setTimeoutInterval:kDefaultRequestTimeout];
                [manager PUT:url parameters:p success:success failure:failure];
            }
        } else if (method == SYRequestMethodPost) {
            if (block) {
                [manager.requestSerializer setTimeoutInterval:kDefaultRequestWithFileTimeout];
                [manager POST:url parameters:p constructingBodyWithBlock:block progress:nil success:success failure:failure];
            } else {
                [manager.requestSerializer setTimeoutInterval:kDefaultRequestTimeout];
                [manager POST:url parameters:p progress:nil success:success failure:failure];
            }
        } else if (method == SYRequestMethodDelete) {
            [manager.requestSerializer setTimeoutInterval:kDefaultRequestTimeout];
            [manager DELETE:url parameters:p success:success failure:failure];
        }
    }
}

@end

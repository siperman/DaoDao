//
//  SYNetworkManager.h
//  Soouya
//
//  Created by hetao on 16/7/5.
//  Copyright © 2016年 Soouya. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

//请求方式
typedef NS_ENUM(NSUInteger, SYRequestMethod) {
    SYRequestMethodGet,
    SYRequestMethodPost,
    SYRequestMethodPut,
    SYRequestMethodDelete,
};

typedef void(^AZNetworkResultBlock)(BOOL success, id response);

@interface SYNetworkManager : AFHTTPSessionManager

+ (void)startRequestWithUrl:(NSString *)url
                     method:(SYRequestMethod)method
                     params:(NSDictionary *)params
                       body:(void (^)(id <AFMultipartFormData> formData))block
                   callback:(AZNetworkResultBlock)callback;

@end

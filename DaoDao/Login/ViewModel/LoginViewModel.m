//
//  LoginViewModel.m
//  DaoDao
//
//  Created by hetao on 16/9/19.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init
{
    self = [super init];
    [self initialBind];
    return self;
}

- (void)initialBind
{
    // 监听账号的属性值改变，把他们聚合成一个信号。
    _enableLoginSignal = [RACSignal combineLatest:@[RACObserve(self, phone),RACObserve(self, code)] reduce:^id(NSString *phone,NSString *code){

        return @(phone.length && code.length);
    }];
}

@end

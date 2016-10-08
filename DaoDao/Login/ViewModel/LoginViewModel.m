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

    // 处理登录业务逻辑
    _LoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {

        NSLog(@"点击了登录");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

            // 模仿网络延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [subscriber sendNext:@"登录成功"];

                // 数据传送完毕，必须调用完成，否则命令永远处于执行状态
                [subscriber sendCompleted];
            });

            return nil;
        }];
    }];

    // 监听登录产生的数据
    [_LoginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {

        if ([x isEqualToString:@"登录成功"]) {
            NSLog(@"登录成功");
        }
    }];

    // 监听登录状态
    [[_LoginCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x isEqualToNumber:@(YES)]) {
            
            // 正在登录ing...
            // 用蒙版提示
//            [MBProgressHUD showMessage:@"正在登录..."];

            
        }else
        {
            // 登录成功
            // 隐藏蒙版
//            [MBProgressHUD hideHUD];
        }
    }];
}

@end

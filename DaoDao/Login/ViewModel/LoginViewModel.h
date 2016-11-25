//
//  LoginViewModel.h
//  DaoDao
//
//  Created by hetao on 16/9/19.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *code;

// 是否允许登录的信号
@property (nonatomic, strong, readonly) RACSignal *enableLoginSignal;

@end

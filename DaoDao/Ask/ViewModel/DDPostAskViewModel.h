//
//  DDPostAskViewModel.h
//  DaoDao
//
//  Created by hetao on 2016/10/9.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDPostAskViewModel : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *demand;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *industry;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, strong) NSString *expert;

// 是否允许发布的信号
@property (nonatomic, strong, readonly) RACSignal *enablePostSignal;
@property (nonatomic, strong, readonly) RACCommand *postCommand;

@end

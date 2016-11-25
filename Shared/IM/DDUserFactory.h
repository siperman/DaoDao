//
//  DDUserFactory.h
//  DaoDao
//
//  Created by hetao on 2016/10/24.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCCKUser;
@interface DDUserFactory : NSObject

+ (LCCKUser *)getUserById:(NSString *)userId;
+ (void)cacheUser:(LCCKUser *)user;

@end

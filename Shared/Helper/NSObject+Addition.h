//
//  NSObject+Addition.h
//  Soouya
//
//  Created by hetao on 15/11/3.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Addition)

+ (NSString *)className;

- (NSString *)jsonString;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSObject (Notification)

- (void)subscribeNotication:(NSString *)name selector:(SEL)selector;

- (void)unsubscribeAllNotications;

- (void)unsubscribeNotication:(NSString *)name;

@end

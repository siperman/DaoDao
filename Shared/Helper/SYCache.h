//
//  SYCache.h
//  Soouya
//
//  Created by hetao on 15/8/20.
//  Copyright (c) 2015年 Soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYCache : NSObject

+ (instancetype)sharedInstance;

- (id)itemForKey:(NSString *)key;

- (void)saveItem:(id)item forKey:(NSString *)key;

@end

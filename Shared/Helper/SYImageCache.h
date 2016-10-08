//
//  SYImageCache.h
//  Soouya
//
//  Created by hetao on 12/21/15.
//  Copyright © 2015 Soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYImageCache : NSObject

+ (instancetype)sharedInstance;

- (void)setup;

- (void)imageForKey:(NSString *)key callback:(void (^)(UIImage *image))callback;

@end

//
//  SYImageCache.m
//  Soouya
//
//  Created by hetao on 12/21/15.
//  Copyright © 2015 Soouya. All rights reserved.
//

#import "SYImageCache.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageDownloader.h>

@implementation SYImageCache

+ (instancetype)sharedInstance
{
    static SYImageCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)setup
{
    [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [SDImageCache sharedImageCache].maxCacheAge = 60 * 60 * 24 * 7;      // cached for 7 days
    [SDImageCache sharedImageCache].maxCacheSize = 1024 * 1024 * 300;    // cached for 300M
    [SDImageCache sharedImageCache].maxMemoryCost = 1024 * 1024 * 50;    // max memory cache for 50M;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * __unused notification) {
        [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
        [[SDImageCache sharedImageCache] clearMemory];
    }];
}

- (void)imageForKey:(NSString *)key callback:(void (^)(UIImage *image))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(image);
            });
        };
    });
}

@end

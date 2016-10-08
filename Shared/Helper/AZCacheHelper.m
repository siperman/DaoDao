//
//  AZCacheHelper.m
//  Q.fm
//
//  Created by hetao on 7/24/14.
//  Copyright (c) 2014 hetao. All rights reserved.
//

#import "AZCacheHelper.h"
#define CACHE_DIR_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

static NSString * const CacheFileName = @"/default/com.hackemist.SDWebImageCache.default";

@implementation AZCacheHelper

+ (long double)cacheFileSize
{
    unsigned long long fileSizeOfBytes = 0;             // file's in bytes
    long double fileSizeOfMb = 0;                       // file's in MB
    NSString *fileName;
    NSString *filePath;
    // SDWebImageCache
    NSString *path = [CACHE_DIR_PATH stringByAppendingPathComponent:CacheFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
        while (fileName = [dirEnum nextObject]) {
            filePath = [path stringByAppendingPathComponent:fileName];
            fileSizeOfBytes += [[[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] objectForKey:NSFileSize] unsignedLongLongValue];
        }
    }
    
    fileSizeOfMb = fileSizeOfBytes / 1024.0 / 1024.0;
    
    return fileSizeOfMb;
}

+ (void)clearCache
{
    NSString *path = [CACHE_DIR_PATH stringByAppendingPathComponent:CacheFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

@end

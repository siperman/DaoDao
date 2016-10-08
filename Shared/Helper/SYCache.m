//
//  SYCache.m
//  Soouya
//
//  Created by hetao on 15/8/20.
//  Copyright (c) 2015年 Soouya. All rights reserved.
//

#import "SYCache.h"
#import "NSString+Path.h"
#import "SYPrefManager.h"

static NSString * const kVerisonKey = @"_v1";

@interface SYCache ()
@property (nonatomic, strong) NSOperationQueue *cacheQueue;
@end

@implementation SYCache

+ (instancetype)sharedInstance
{
    static SYCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.cacheQueue = [[NSOperationQueue alloc] init];
        instance.cacheQueue.name = @"DaoDao cache queue";
        instance.cacheQueue.maxConcurrentOperationCount = 1;
    });
    
    return instance;
}

- (id)itemForKey:(NSString *)key
{
    key = [key stringByAppendingString:kVerisonKey];
    NSString *path = [[NSString pathForFolder:AZFolderCaches] stringByAppendingPathComponent:key];

    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (void)saveItem:(id)item forKey:(NSString *)key
{
    key = [key stringByAppendingString:kVerisonKey];
    NSString *path = [[NSString pathForFolder:AZFolderCaches] stringByAppendingPathComponent:key];

    if (!item) {
        [[NSFileManager defaultManager] removeItemAtPath:[[NSString pathForFolder:AZFolderCaches] stringByAppendingPathComponent:key] error:nil];
    } else {
        NSOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            if (!item) {
                NSLog(@"shit");
            }
            [NSKeyedArchiver archiveRootObject:item toFile:path];
        }];
        
        [self.cacheQueue addOperation:op];
    }
}

// 更新版本时清楚接口缓存数据
- (void)clearCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dir = [NSString pathForFolder:AZFolderCaches];

    NSArray *contents = [fileManager contentsOfDirectoryAtPath:dir error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        NSString *path = [dir stringByAppendingPathComponent:filename];
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:path isDirectory:&isDir] && !isDir) {
            debugLog(@"file : %@", path);
            [fileManager removeItemAtPath:path error:NULL];
        } else {
            debugLog(@"dir  : %@", path);
        }
    }
}

@end

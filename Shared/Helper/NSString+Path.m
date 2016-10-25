//
//  NSString+Path.m
//  Falcon
//
//  Created by hetao on 8/12/14.
//  Copyright (c) 2014 hetao. All rights reserved.
//

#import "NSString+Path.h"

NSString * const kDocumentsPathKey = @"kDocumentsPathKey";
NSString * const kCachesPathKey = @"kCachesPathKey";
NSString * const kTmpPathKey = @"kTmpPathKey";
NSString * const kPathKey = @"kDocumentPathKey";
NSString * const kProgramsListPathKey = @"kProgramsListPathKey";
NSString * const kHadCachedProgramsListPathKey = @"kHadCachedProgramsListPathKey";
NSString * const kTempFolderPathKey = @"kTempFolderPathKey";
NSString * const kAudioPlayStatePathKey = @"kAudioPlayStatePathKey";

@implementation NSString (Path)

+ (BOOL)isExitFile:(NSString *)fileName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:fileName];
}

+ (NSString *)pathForFolderName:(NSString *)folderName
{
    return [NSHomeDirectory() stringByAppendingPathComponent:folderName];
}

+ (NSString *)documentsFolderPath
{
    return [self pathForFolder:AZFolderDocuments];
}

+ (NSString *)cachesFolderPath
{
    return [self pathForFolder:AZFolderCaches];
}

+ (NSString *)tempFolderPath
{
    return [self pathForFolder:AZFolderTmp];
}

+ (NSString *)pathForFolder:(AZFolderKey)folder {
    NSString *folderName = nil;
    switch (folder) {
        case AZFolderTmp:
            folderName = @"tmp";
            break;
        case AZFolderDocuments:
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths firstObject];
            return documentsDirectory;
        }
            break;
        case AZFolderCaches:
            folderName = @"Library/Caches";
            break;
        case AZFolderApplicationSupport:
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
            return [paths firstObject];
        }
        default:
            break;
    }
    
    return [NSHomeDirectory() stringByAppendingPathComponent:folderName];
}

+ (NSString *)pathForFolder:(AZFolderKey)folder fileName:(NSString *)fileName
{
    return [[self pathForFolder:folder] stringByAppendingPathComponent:fileName];
}

@end

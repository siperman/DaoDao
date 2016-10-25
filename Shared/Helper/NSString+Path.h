//
//  NSString+Path.h
//  Falcon
//
//  Created by hetao on 8/12/14.
//  Copyright (c) 2014 hetao. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kAZFolderDocumentsKey;
extern NSString * const kAZFolderCachesKey;
extern NSString * const kAZFolderTmpKey;

typedef NS_ENUM(NSUInteger, AZFolderKey) {
    AZFolderDocuments,
    AZFolderCaches,
    AZFolderTmp,
    AZFolderApplicationSupport,
};

typedef NS_ENUM(NSUInteger, AZFileKey) {
    AZFileProgramHadFinishedList,
    AZFileProgramsList,
    AZFileHadCachedProgramsList,
    AZFileAudioPlayState
};

@interface NSString (Path)

+ (BOOL)isExitFile:(NSString *)fileName;

+ (NSString *)pathForFolderName:(NSString *)folderName;

+ (NSString *)documentsFolderPath;

+ (NSString *)cachesFolderPath;

+ (NSString *)tempFolderPath;

+ (NSString *)pathForFolder:(AZFolderKey)folder;

+ (NSString *)pathForFolder:(AZFolderKey)folder fileName:(NSString *)fileName;

@end

//
//  SYCameraManager.h
//  Soouya
//
//  Created by hetao on 15/9/6.
//  Copyright (c) 2015年 Soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SYCameraManagerCallback)(NSArray<UIImage *> *photos);

typedef NS_ENUM(NSUInteger, SYCameraManagerPhotoSource) {
    SYCameraManagerPhotoSourceCamera,
    SYCameraManagerPhotoSourcePhotoLibrary,
};

@interface SYCameraManager : NSObject

+ (instancetype)sharedInstance;

- (void)getPhotoAndSupportMultiSelection:(BOOL)canMultiSelect
                             remainCount:(NSUInteger)remainCount
                                callback:(void(^)(NSArray *photos))callback;

- (void)getPhotoAndSupportMultiSelection:(BOOL)canMultiSelect
                          viewController:(UIViewController *)vc
                             remainCount:(NSUInteger)remainCount
                                callback:(void(^)(NSArray *photos))callback;

- (void)getPhotoWithType:(SYCameraManagerPhotoSource)type
                isAvatar:(BOOL)isAvatar
   supportMultiSelection:(BOOL)canMultiSelect
          viewController:(UIViewController *)vc
             remainCount:(NSUInteger)remainCount
                callback:(void(^)(NSArray *photos))callback;

- (void)getAvatarInViewController:(UIViewController *)vc callback:(void (^)(NSArray *))callback;

- (void)getPhotoByPickerWithSupportMultiSelection:(BOOL)canMultiSelect
                                         isAvatar:(BOOL)isAvatar
                                   viewController:(UIViewController *)vc
                                      remainCount:(NSUInteger)remainCount
                                         callback:(void(^)(NSArray<UIImage *> *photos))callback;

- (void)getPhotoForSearchViewController:(UIViewController *)vc callback:(SYCameraManagerCallback)callback;

@end

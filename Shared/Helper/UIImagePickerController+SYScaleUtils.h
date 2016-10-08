//
//  UIImagePickerController+SYScaleUtils.h
//  Soouya
//
//  Created by hetao on 1/19/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ORIGINAL_MAX_WIDTH 256.0f

@interface UIImagePickerController (SYScaleUtils)

+ (BOOL)isCameraAvailable;

+ (BOOL)isRearCameraAvailable;

+ (BOOL)isFrontCameraAvailable;

+ (BOOL)doesCameraSupportTakingPhotos;

+ (BOOL)isPhotoLibraryAvailable;

+ (BOOL)canUserPickVideosFromPhotoLibrary;

+ (BOOL)canUserPickPhotosFromPhotoLibrary;

+ (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;

+ (void)getPhotoWithType:(NSUInteger)type
                delegate:(id)delegate;
@end


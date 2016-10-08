//
//  UIImage+SYScale.h
//  Soouya
//
//  Created by hetao on 3/17/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ORIGINAL_MAX_WIDTH 256.0f
#define UPLOAD_MAX_WIDTH 1280.0f

@interface UIImage (SYScale)

- (UIImage *)imageByScalingToMaxSize;

- (UIImage *)imageByScalingAndCroppingForTargetSize:(CGSize)targetSize;

- (UIImage *)fixOrientation;

- (UIImage *)imageByScallingSearchingSize;

- (UIImage *)imageByScallingUploadSize;

- (NSData *)compressToUpload;

+ (UIImage *)compressImage:(UIImage *)image;

@end

@interface UIImage (Helpers)

+ (void)loadFromURL:(NSURL *)url callback:(void (^)(UIImage *image))callback;

@end
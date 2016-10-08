//
//  UIImage+SYScale.m
//  Soouya
//
//  Created by hetao on 3/17/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import "UIImage+SYScale.h"

@implementation UIImage (SYScale)

#pragma mark image scale utility

- (UIImage *)imageByScalingToMaxSize
{
    if (self.size.width < ORIGINAL_MAX_WIDTH || self.size.height < ORIGINAL_MAX_WIDTH) return self;
    
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (self.size.width < self.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = self.size.width * (ORIGINAL_MAX_WIDTH / self.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = self.size.height * (ORIGINAL_MAX_WIDTH / self.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForTargetSize:targetSize];
}

- (UIImage *)imageByScallingUploadSize
{
    debugLog(@"original %@", NSStringFromCGSize(self.size));
    
    if (self.size.width < UPLOAD_MAX_WIDTH && self.size.height < UPLOAD_MAX_WIDTH) return self;
    
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (self.size.width < self.size.height) {
        btHeight = UPLOAD_MAX_WIDTH;
        btWidth = self.size.width * (UPLOAD_MAX_WIDTH / self.size.height);
    } else {
        btWidth = UPLOAD_MAX_WIDTH;
        btHeight = self.size.height * (UPLOAD_MAX_WIDTH / self.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    
    debugLog(@"original %@ scal %@", NSStringFromCGSize(self.size), NSStringFromCGSize(targetSize));
    
    return [self imageByScalingAndCroppingForTargetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForTargetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    debugLog(@"orientation %@", @(self.imageOrientation));
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)imageByScallingSearchingSize
{
    if (self.size.width < ORIGINAL_MAX_WIDTH || self.size.height < ORIGINAL_MAX_WIDTH) return self;
    
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (self.size.width < self.size.height) {
        btHeight = self.size.height * (ORIGINAL_MAX_WIDTH / self.size.width);
        btWidth = ORIGINAL_MAX_WIDTH;
    } else {
        btWidth = self.size.width * (ORIGINAL_MAX_WIDTH / self.size.height);
        btHeight = ORIGINAL_MAX_WIDTH;
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    
    NSLog(@"original %@ scal %@", NSStringFromCGSize(self.size), NSStringFromCGSize(targetSize));
    
    return [self imageByScalingAndCroppingForTargetSize:targetSize];
}

- (NSData *)compressToUpload
{
    UIImage *scaled = [self imageByScallingUploadSize];
    NSData *result = UIImageJPEGRepresentation(scaled, 1);
    double size = result.length / 1024.0;
    
    if (size <= 200) {           // 200KB
        return result;
    } else if (size <= 500) {    // 500KB
        return UIImageJPEGRepresentation(scaled, 0.6);
    } else {
        return UIImageJPEGRepresentation(scaled, 0.4);
    }
}

+ (UIImage *)compressImage:(UIImage *)image
{
    UIImage *scaled = [image imageByScallingUploadSize];
    UIImage *result = nil;
    
    double size = UIImagePNGRepresentation(scaled).length / 1024.0;
    if (size <= 200) {           // 200KB
        result = scaled;
    } else if (size <= 500) {    // 500KB
        result = [UIImage imageWithData:UIImageJPEGRepresentation(scaled, 0.6)];
    } else {
        result = [UIImage imageWithData:UIImageJPEGRepresentation(scaled, 0.4)];
    }
    
    return result;
}

@end


@implementation UIImage (Helpers)

+ (void)loadFromURL:(NSURL*)url callback:(void (^)(UIImage *image))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageData];
            callback(image);
        });
    });
}

@end
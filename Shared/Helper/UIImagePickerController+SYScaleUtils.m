//
//  UIImagePickerController+SYScaleUtils.m
//  Soouya
//
//  Created by hetao on 1/19/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import "UIImagePickerController+SYScaleUtils.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DBCameraViewController.h"
#import "DBCameraContainerViewController.h"
#import "SYUtils.h"

@implementation UIImagePickerController (SYScaleUtils)

#pragma mark camera utility

+ (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL)canUserPickVideosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL)canUserPickPhotosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

+ (void)getPhotoWithType:(NSUInteger)type
                delegate:(id)delegate
{
    if (type == 0) {
        // 拍照
        if ([UIImagePickerController isCameraAvailable] && [UIImagePickerController doesCameraSupportTakingPhotos]) {
            UIViewController *vc = [SYUtils cameraViewControlllerWithDelegate:delegate];
            [APP_DELEGATE.window.rootViewController presentViewController:vc animated:YES completion:nil];
        }
    } else if (type == 1) {
        // 从相册中选取
        if ([UIImagePickerController isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            controller.delegate = delegate;
            
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            
            [APP_DELEGATE.window.rootViewController presentViewController:controller
                                                                 animated:YES
                                                               completion:nil];
        }
    }
}


@end

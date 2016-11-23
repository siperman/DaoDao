//
//  SYCameraManager.m
//  Soouya
//
//  Created by hetao on 15/9/6.
//  Copyright (c) 2015年 Soouya. All rights reserved.
//

#import "SYCameraManager.h"
#import "IBActionSheet.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SYUtils.h"
#import "CTAssetsPickerController+Addition.h"
#import "CTAssetsPickerController.h"
#import "UIImagePickerController+SYScaleUtils.h"
#import "DBCameraViewController.h"
#import "DBCameraContainerViewController.h"
#import "TOCropViewController.h"
#import "UIImage+SYScale.h"
#import "VPImageCropperViewController.h"

//#import "SYImagePickerViewController.h"
#import "SYStoryboardManager.h"

@interface SYCameraManager () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, DBCameraViewControllerDelegate, TOCropViewControllerDelegate, CTAssetsPickerControllerDelegate, VPImageCropperDelegate>

@property (nonatomic, copy) void(^callback)(NSArray *photos);
@property (nonatomic) BOOL canMutilSelect;
@property (nonatomic) BOOL isAvatar;
@property (nonatomic) NSUInteger remainCount;
@property (nonatomic, weak) UIViewController *vc;

@property (nonatomic) BOOL dismissWithPresentingViewController;

@end

@implementation SYCameraManager

+ (instancetype)sharedInstance
{
    static SYCameraManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    [instance clear];
    
    return instance;
}

- (void)clear
{
    self.callback = nil;
    self.isAvatar = NO;
    self.canMutilSelect = NO;
    self.dismissWithPresentingViewController = NO;
    self.remainCount = 0;
}

- (void)getPhotoWithType:(SYCameraManagerPhotoSource)type
                isAvatar:(BOOL)isAvatar
   supportMultiSelection:(BOOL)canMultiSelect
          viewController:(UIViewController *)vc
             remainCount:(NSUInteger)remainCount
                callback:(void(^)(NSArray *photos))callback
{
    self.isAvatar = isAvatar;
    self.canMutilSelect = canMultiSelect;
    self.remainCount = remainCount;
    self.callback = callback;
    self.vc = vc;
    
    // 拍照
    if (type == SYCameraManagerPhotoSourceCamera) {
        [SYUtils checkCameraUsageWithCallBack:^(BOOL canUse) {
            if (canUse) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getPhotoWithType:type];
                });
            }
        }];
    }
    // 相册
    else if (type == SYCameraManagerPhotoSourcePhotoLibrary) {
        [SYUtils checkPhotosAuthorization:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getPhotoWithType:type];
                });
            }
        }];
    }
}

- (void)getPhotoWithType:(NSUInteger)type
{
    if (type == 0) {
        // 拍照
        if ([UIImagePickerController isCameraAvailable] && [UIImagePickerController doesCameraSupportTakingPhotos]) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            
            DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
//            cameraContainer.fd_prefersNavigationBarHidden = YES;
            [cameraContainer setFullScreenMode];

            [self presentViewController:cameraContainer];
        }
    } else if (type == 1) {
        // 从相册中选取
        if (self.canMutilSelect) {
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.delegate = self;
            picker.assetsFilter = [ALAssetsFilter allPhotos]; // Only pick photos.
            
            [self presentViewController:picker];
        } else {
            if ([UIImagePickerController isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                controller.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
                controller.delegate = self;
                
                [self presentViewController:controller];
            }
        }
    }
}

- (void)presentViewController:(UIViewController *)vc
{
    [self.vc ?: APP_DELEGATE.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)getPhotoByPickerWithSupportMultiSelection:(BOOL)canMultiSelect
                                         isAvatar:(BOOL)isAvatar
                                   viewController:(UIViewController *)vc
                                      remainCount:(NSUInteger)remainCount
                                         callback:(void(^)(NSArray<UIImage *> *photos))callback
{
//    SYImagePickerViewController *picker = [[SYStoryboardManager manager].sharedSB instantiateViewControllerWithIdentifier:@"SYImagePickerViewController"];
//    picker.canMultiSelect = canMultiSelect;
//    picker.callback = callback;
//    picker.isAvatar = isAvatar;
//    picker.remainCount = remainCount;
//    picker.dismissWithPresentingViewController = self.dismissWithPresentingViewController;
//    
//    [vc ?: APP_DELEGATE.window.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:picker]
//                                                               animated:YES
//                                                             completion:nil];
}

- (void)getPhotoForSearchViewController:(UIViewController *)vc callback:(SYCameraManagerCallback)callback
{
    self.dismissWithPresentingViewController = YES;
    
    [self getPhotoByPickerWithSupportMultiSelection:NO isAvatar:NO viewController:vc remainCount:0 callback:callback];
}

#pragma mark - Photo

- (void)getPhotoAndSupportMultiSelection:(BOOL)canMultiSelect
                             remainCount:(NSUInteger)remainCount
                                callback:(void(^)(NSArray *photos))callback
{
    [self getPhotoAndSupportMultiSelection:canMultiSelect viewController:nil remainCount:remainCount callback:callback];
}

- (void)getPhotoAndSupportMultiSelection:(BOOL)canMultiSelect
                          viewController:(UIViewController *)vc
                             remainCount:(NSUInteger)remainCount
                                callback:(void(^)(NSArray *photos))callback
{
    
    
    IBActionSheet *choiceSheet = [[IBActionSheet alloc] initWithTitle:nil
                                                             callback:^(IBActionSheet *actionSheet, NSInteger buttonIndex) {
                                                                 [self getPhotoWithType:buttonIndex
                                                                               isAvatar:NO
                                                                  supportMultiSelection:canMultiSelect
                                                                         viewController:vc
                                                                            remainCount:remainCount
                                                                               callback:callback];
                                                                  }
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                               otherButtonTitlesArray:@[@"拍照", @"相册"]];
    [choiceSheet showInView:APP_DELEGATE.window];
}

#pragma mark - Avatar

- (void)getAvatarInViewController:(UIViewController *)vc callback:(void (^)(NSArray *))callback
{
    IBActionSheet *choiceSheet = [[IBActionSheet alloc] initWithTitle:nil
                                                             callback:^(IBActionSheet *actionSheet, NSInteger buttonIndex) {
                                                                 [self getPhotoWithType:buttonIndex
                                                                               isAvatar:YES
                                                                  supportMultiSelection:NO
                                                                         viewController:vc
                                                                            remainCount:0
                                                                               callback:callback];
                                                             }
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                               otherButtonTitlesArray:@[@"拍一张", @"从手机相册里选择"]];
    [choiceSheet showInView:APP_DELEGATE.window];
}

- (void)getOrSaveAvatarInViewController:(UIViewController *)vc callback:(void (^)(NSArray *))callback
{
    IBActionSheet *choiceSheet = [[IBActionSheet alloc] initWithTitle:nil
                                                             callback:^(IBActionSheet *actionSheet, NSInteger buttonIndex) {
                                                                 if (buttonIndex == 2) {
                                                                     callback(nil);
                                                                 } else {
                                                                     [self getPhotoWithType:buttonIndex
                                                                                   isAvatar:YES
                                                                      supportMultiSelection:NO
                                                                             viewController:vc
                                                                                remainCount:0
                                                                                   callback:callback];
                                                                 }
                                                             }
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                               otherButtonTitlesArray:@[@"拍一张", @"从手机相册里选择", @"保存图片"]];
    [choiceSheet showInView:APP_DELEGATE.window];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *portraitImg = info[@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
  
    if (self.isAvatar) {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, SCREEN_WIDTH, SCREEN_WIDTH) limitScaleRatio:kAvatarCropMaxRatio];
        imgCropperVC.delegate = self;
        
        [self presentViewController:imgCropperVC];
    } else {
        if (self.callback) {
            self.callback(@[portraitImg]);
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
}

#pragma mark - CTAssetsPickerControllerDelegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableArray *images = [NSMutableArray array];
        for (ALAsset *asset in assets) {
            UIImage *img = [SYUtils fullSizeImageForAssetRepresentation:asset.defaultRepresentation];
            
            [images addObject:[UIImage compressImage:img]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.callback) {
                self.callback(images);
            }
            
            [picker dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    return [picker showMaximumNotice:(picker.selectedAssets.count < self.remainCount)];
}

#pragma mark - DBCameraViewControllerDelegate

- (void)camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [cameraViewController dismissViewControllerAnimated:YES completion:^{
        if (self.isAvatar) {
            // present the cropper view controller
            VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, 100.0f, SCREEN_WIDTH, SCREEN_WIDTH) limitScaleRatio:kAvatarCropMaxRatio];
            imgCropperVC.delegate = self;
            
            [self presentViewController:imgCropperVC];
        } else {
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:[UIImage compressImage:image]];
            cropController.delegate = self;
            
            [self presentViewController:cropController];
        }
    }];
}

- (void)dismissCamera:(id)cameraViewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [cameraViewController restoreFullScreenMode];
    [cameraViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        if (self.callback) {
            self.callback(@[image]);
        }
    }];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        [self getPhotoWithType:0];
    }];
}

#pragma mark VPImageCropperDelegate

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        if (self.callback) {
            self.callback(@[editedImage]);
        }
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}


@end

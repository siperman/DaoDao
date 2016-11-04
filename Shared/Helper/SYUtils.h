//
//  SYUtils.h
//  Soouya
//
//  Created by hetao on 3/25/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "DBCameraViewController.h"
#import "DBCameraContainerViewController.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SYUtils : NSObject

+ (NSString *)dateFormString:(NSString *)dateString;

+ (NSString *)dateFormInterval:(NSTimeInterval)interval;

+ (NSString *)dateDetailFormInterval:(NSNumber *)interval;

+ (NSNumber *)timeIntervalFromDateString:(NSString *)dateString;

+ (NSString *)timestampFromInterval:(NSNumber *)interval;

+ (NSString *)timestampFromInterval:(NSNumber *)interval shortStyle:(BOOL)shortStyle;

+ (NSString *)IMTimestampFromInterval:(NSNumber *)interval;

+ (NSString *)networkType;

+ (NSString *)carrierName;

+ (void)checkCameraUsageWithCallBack:(void(^)(BOOL granted))callback;

+ (UIImage *)fullSizeImageForAssetRepresentation:(ALAssetRepresentation *)assetRepresentation;

+ (NSURL *)thumbnailURLFromOriginURL:(NSURL *)originURL;

+ (BOOL)isNegotiable:(NSString *)priceString;

+ (NSAttributedString *)attributedStringForInfo:(NSString *)info constraintWidth:(CGFloat)constraintWidth height:(CGFloat *)height; // use for info view

+ (long)currentTimestamp;

+ (NSString *)getCategoryName:(NSDictionary *)dict;

+ (NSString *)unifiedUUID;

+ (NSArray *)parseInterval:(NSString *)interval;

+ (BOOL)isRemoteNotificationOn;

+ (NSString *)getBlankCharsBy:(NSInteger)count;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SYUtils (AppDelegate)

+ (void)registerNotification;

+ (void)firUpdate;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SYUtils (Capture)

+ (UIViewController *)cameraViewControlllerWithDelegate:(id<DBCameraViewControllerDelegate>)delegate;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SYUtils (Recored)

+ (void)checkMicroPhoneUsageWithPermissionCallback:(void (^)(void))callback;

+ (void)checkPhotosAuthorization:(void (^)(BOOL granted))granted;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SYUtils (Glance)

+ (void)glanceImages:(NSArray *)array fromIndex:(NSInteger)idx srcImageViews:(NSArray *)srcImageViews;

+ (void)previewImages:(NSArray *)array fromIndex:(NSInteger)idx inViewController:(UIViewController *)viewController canDelete:(BOOL)canDelete;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SYUtils (Color)

+ (UIColor *)BBBBBBColor;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SYUtils (HUD)

+ (void)showWindowLevelNotice:(NSString *)notice;

@end

//
//  SYUtils.m
//  Soouya
//
//  Created by hetao on 3/25/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import "SYUtils.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <Photos/Photos.h>
#import "UIImagePickerController+SYScaleUtils.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <UserNotifications/UserNotifications.h>

#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"

#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "FSImageViewerViewController.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "KeychainItemWrapper.h"
#import "NSString+MD5Addition.h"
#import "UIDevice+IdentifierAddition.h"
#import "NSDate+DateSetting.h"

@implementation SYUtils

+ (NSString *)dateFormString:(NSString *)dateString
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:dateString];
    dateFormatter.dateFormat = @"M月d日";
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dateFormInterval:(NSTimeInterval)interval
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    dateFormatter.dateFormat = @"M月d日 HH:mm";

    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dateDetailFormInterval:(NSNumber *)interval
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[interval doubleValue] / 1000];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    return [dateFormatter stringFromDate:date];
}

+ (NSNumber *)timeIntervalFromDateString:(NSString *)dateString
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSTimeInterval interval = [date timeIntervalSince1970];
    return @(interval);
}

+ (NSString *)dateDetailSinceNowFormInterval:(NSNumber *)interval
{
    NSDate *future = [NSDate dateWithTimeIntervalSince1970:interval.doubleValue];
    NSInteger interval_ = [future timeIntervalSinceNow];

    NSInteger minute = interval_ % (60 * 60);
    interval_ -= minute;
    minute /= 60;
    NSInteger hour = interval_ % (60 * 60 * 24);
    interval_ -= hour;
    hour /= (60 * 60);
    NSInteger day = interval_ / (60 * 60 * 24);

    NSString *timeStr = [NSString stringWithFormat:@"%ld天%ld小时%ld分", day, hour, minute];

    return timeStr;
}

static NSDateFormatter *timestampFormatter = nil;

+ (NSString *)IMTimestampFromInterval:(NSNumber *)interval shortStyle:(BOOL)shortStyle
{
    NSString *_timestamp;

    time_t now, _createdAt;
    time(&now);
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];

    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    time_t midnightDistance = [[NSDate date] timeIntervalSinceDate:today];
    
    _createdAt = [interval longValue];
    int distance = (int)difftime(now, _createdAt);  // 秒
    if (distance < 0) distance = 0;
    NSString *minFormatter = [NSDate isDaySetting24Hours] ? @"H:mm" : @"a h:mm";
    
    if (distance < midnightDistance) {
        if (timestampFormatter == nil) {
            timestampFormatter = [[NSDateFormatter alloc] init];
        }
        [timestampFormatter setDateFormat:minFormatter];

        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_createdAt];
        _timestamp = [timestampFormatter stringFromDate:date];
    }
    else if (distance < midnightDistance + 60 * 60 * 24) {
        if (timestampFormatter == nil) {
            timestampFormatter = [[NSDateFormatter alloc] init];
        }
        if (shortStyle) {
            return @"昨天";
        } else {
            [timestampFormatter setDateFormat:[NSString stringWithFormat:@"昨天 %@", minFormatter]];
        }

        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_createdAt];
        _timestamp = [timestampFormatter stringFromDate:date];
    }
    else if (distance < midnightDistance + 60 * 60 * 24 * 7) {
        if (timestampFormatter == nil) {
            timestampFormatter = [[NSDateFormatter alloc] init];
        }
        if (shortStyle) {
            [timestampFormatter setDateFormat:@"cccc"];
        } else {
            [timestampFormatter setDateFormat:[NSString stringWithFormat:@"cccc %@", minFormatter]];
        }

        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_createdAt];
        _timestamp = [timestampFormatter stringFromDate:date];
    }
    else {
        if (timestampFormatter == nil) {
            timestampFormatter = [[NSDateFormatter alloc] init];
        }
        if (shortStyle) {
            [timestampFormatter setDateFormat:@"yy/M/d"];
        } else {
            [timestampFormatter setDateFormat:[NSString stringWithFormat:@"yy/M/d %@", minFormatter]];
        }

        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_createdAt];
        _timestamp = [timestampFormatter stringFromDate:date];
    }
    
    return _timestamp;
}

+ (long)currentTimestamp
{
    return (long)[[NSDate date] timeIntervalSince1970];
}

+ (NSString *)networkType
{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    NSString *type = @"";
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            type = @"无服务";
            break;
            
        case 1:
            type = @"2G";
            break;
            
        case 2:
            type = @"3G";
            break;
            
        case 3:
            type = @"4G";
            break;
            
        case 4:
            type = @"LTE";
            break;
            
        case 5:
            type = @"Wifi";
            break;

        default:
            break;
    }
    
    return type;
}

+ (NSString *)carrierName
{
    @try {
        // Get the Telephony Network Info
        CTTelephonyNetworkInfo *TelephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
        // Get the carrier
        CTCarrier *Carrier = [TelephonyInfo subscriberCellularProvider];
        TelephonyInfo = nil;
        // Get the carrier name
        NSString *CarrierName = [Carrier carrierName];
        
        // Check to make sure it's valid
        if (CarrierName == nil || CarrierName.length <= 0) {
            // Return unknown
            return @"";
        }
        // Return the name
        return CarrierName;

    } @catch (NSException *exception) {
        return @"";
    }
}

+ (void)checkCameraUsageWithCallBack:(void(^)(BOOL granted))callback
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        // do your logic
        callback(YES);
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // not determined?!
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){
                debugLog(@"Granted access to %@", mediaType);
                callback(YES);
            } else {
                callback(NO);
                debugLog(@"Not granted access to %@", mediaType);
            }
        }];
    } else {
        RIButtonItem *btnCancel = [RIButtonItem itemWithLabel:@"好"];
        
        NSString *title = @"无法访问相机或照片";
        NSString *msg = [NSString stringWithFormat:@"请到系统的隐私设置中，允许%@访问“相机”和“照片”", APPNAME];
        
        if (SystemVersion_floatValue >= 8.0) {
            RIButtonItem *btnSettings = [RIButtonItem itemWithLabel:@"设置" action:^{
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg cancelButtonItem:btnCancel otherButtonItems:btnSettings, nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg cancelButtonItem:btnCancel otherButtonItems:nil];
            [alert show];
        }
        
        callback(NO);
    }
}

// Reduce image memory size
+ (UIImage *)fullSizeImageForAssetRepresentation:(ALAssetRepresentation *)assetRepresentation
{
    UIImage *result = nil;
    NSData *data = nil;
    
    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t)*[assetRepresentation size]);
    memset(buffer, 0, [assetRepresentation size]);
    
    if (buffer != NULL) {
        NSError *error = nil;
        NSUInteger bytesRead = [assetRepresentation getBytes:buffer fromOffset:0 length:[assetRepresentation size] error:&error];
        data = [NSData dataWithBytes:buffer length:bytesRead];
        
        free(buffer);
        buffer = NULL;
    }
    
    if ([data length])
    {
        CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
        
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        
        [options setObject:(id)kCFBooleanTrue forKey:(id)kCGImageSourceShouldAllowFloat];
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, (__bridge CFDictionaryRef)options);
        
        if (imageRef) {
            result = [UIImage imageWithCGImage:imageRef
                                         scale:[assetRepresentation scale]
                                   orientation:(UIImageOrientation)[assetRepresentation orientation]];
            CGImageRelease(imageRef);
        }
        
        if (sourceRef)
            CFRelease(sourceRef);
    }
    
    return result;
}

+ (NSURL *)thumbnailURLFromOriginURL:(NSURL *)originURL
{
    if (originURL) {
        NSString *u = originURL.absoluteString;
        NSString *extension = [u pathExtension];
        if ([u rangeOfString:extension].location != NSNotFound) {
            NSString *thumbnailUrl = [u stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", extension]
                                                                  withString:[NSString stringWithFormat:@"_thumbnail.%@", extension]];
            return [NSURL URLWithString:thumbnailUrl];
        }
    }
    
    return originURL;
}

+ (BOOL)isNegotiable:(NSString *)priceString
{
    return ([priceString rangeOfString:@"面议"].location != NSNotFound);
}

+ (NSAttributedString *)attributedStringForInfo:(NSString *)info constraintWidth:(CGFloat)constraintWidth height:(CGFloat *)height
{
    if (info.length == 0) {
        if (height) {
            *height = 50.0;
        }
        
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *dict = @{
                           NSParagraphStyleAttributeName : paragraphStyle,
                           NSFontAttributeName : Font(14.0)
                           };
    NSAttributedString *attriStr = [[NSAttributedString alloc] initWithString:info attributes:dict];
    
    CGRect rect = [attriStr boundingRectWithSize:CGSizeMake(constraintWidth, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         context:nil];
    
    if (height) {
        *height = rect.size.height + 30.0;
    }
    
    return attriStr;
}

+ (NSString *)getCategoryName:(NSDictionary *)dict
{
    if (dict && [dict valueForKey:kTagsIDKey]) {
        NSString *tid = [dict valueForKey:kTagsIDKey];
        NSArray *names = [tid componentsSeparatedByString:@"_"];
        if (names.count >= 2) {
            return names[1];
        }
    }
    
    return nil;
}

+ (NSString *)unifiedUUID
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSArray *)parseInterval:(NSString *)interval
{
    if (interval.length < 3) {
        return nil;
    }
    
    NSMutableArray *results = [NSMutableArray array];
    
    NSString *leftIntervalSymbol = [interval substringToIndex:1];
    [results addObject:leftIntervalSymbol];
    
    NSString *content = [interval substringWithRange:NSMakeRange(1, interval.length - 2)];
    NSArray *numbers = [content componentsSeparatedByString:@","];
    [results addObjectsFromArray:numbers];
    
    NSString *rightIntervalSymbol = [interval substringWithRange:NSMakeRange(interval.length - 1, 1)];
    [results addObject:rightIntervalSymbol];
    
    return results;
}

+ (BOOL)isRemoteNotificationOn
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
        return ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone);
    } else {
        return ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone);
    }
}

+ (NSString *)getBlankCharsBy:(NSInteger)count{
    NSString *blank = @"";
    while (count > 0) {
        blank = [ blank stringByAppendingString:@" "];
        count --;
    }
    return blank;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation SYUtils (AppDelegate)

+ (void)registerNotification
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysVer >= 10.0) {
        [self registerPushForIOS10];
    } else {
        [self registerPushForIOS8];
    }
#else
    //iOS8之前注册push方法
    //注册Push服务，注册后才能收到推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#endif
}

+ (void)registerPushForIOS8
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"INVITE_CATEGORY";
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

+ (void)registerPushForIOS10
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = APP_DELEGATE;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"succeeded!");
        }
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

+ (void)firUpdate
{
#ifndef RELEASE
    NSString *bundleId = [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
    NSString *bundleIdUrlString = [NSString stringWithFormat:@"http://api.fir.im/apps/latest/%@?api_token=4dd2d5df6de4b3262d027c957b71e5e5&type=ios", bundleId];
    NSURL *requestURL = [NSURL URLWithString:bundleIdUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];

    [NSURLConnection sendAsynchronousRequest:request queue :[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            //do something
        }else {
            NSError *jsonError = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError && [object isKindOfClass:[NSDictionary class]]) {
                NSString *bundleVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
                NSString *version = object[@"version"];
                if ([bundleVersion isKindOfClass:[NSString class]] &&
                    [version isKindOfClass:[NSString class]] &&
                    version.integerValue > bundleVersion.integerValue) {
                    NSString *url = object[@"update_url"];
                    if (url && [url isKindOfClass:[NSString class]]) {
                        RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
                        RIButtonItem *download = [RIButtonItem itemWithLabel:@"下载" action:^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                        }];

                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新版本，请及时更新" message:nil cancelButtonItem:cancel otherButtonItems:download, nil];
                        [alert show];
                    }
                }
            }
        }
    }];
#endif
}


@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation SYUtils (Capture)

+ (UIViewController *)cameraViewControlllerWithDelegate:(id<DBCameraViewControllerDelegate>)delegate
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:delegate];
    [cameraContainer setFullScreenMode];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
    [nav setNavigationBarHidden:YES];
    
    return nav;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation SYUtils (Recored)

+ (void)checkMicroPhoneUsageWithPermissionCallback:(void (^)(void))callback
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted && callback) {
            callback();
        } else {
            RIButtonItem *btnCancel = [RIButtonItem itemWithLabel:@"好"];

            NSString *title = @"无法访问麦克风";
            NSString *msg = [NSString stringWithFormat:@"请到系统的隐私设置中，允许%@访问“麦克风”", APPNAME];
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            RIButtonItem *btnSettings = [RIButtonItem itemWithLabel:@"设置" action:^{
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg cancelButtonItem:btnCancel otherButtonItems:btnSettings, nil];
            [alert show];
#else
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg cancelButtonItem:btnCancel otherButtonItems:nil];
            [alert show];
#endif
        }
    }];
}

+ (void)checkPhotosAuthorization:(void (^)(BOOL granted))granted
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    void (^denied)(void) = ^{
        RIButtonItem *btnCancel = [RIButtonItem itemWithLabel:@"好"];
        
        NSString *title = @"无法访问照片";
        NSString *msg = [NSString stringWithFormat:@"请到系统的隐私设置中，允许%@访问“照片”", APPNAME];
        
        RIButtonItem *btnSettings = [RIButtonItem itemWithLabel:@"设置" action:^{
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg cancelButtonItem:btnCancel otherButtonItems:btnSettings, nil];
        [alert show];
    };
    
    void (^handler)(PHAuthorizationStatus) = ^(PHAuthorizationStatus status)
    {
        if (status == PHAuthorizationStatusAuthorized) {
            granted(YES);
        } else if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    granted(YES);
                } else {
                    denied();
                }
            }];
        } else {
            denied();
        }
    };
    handler([PHPhotoLibrary authorizationStatus]);
#else
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusAuthorized) {
        granted(YES);
    } else if (status == ALAuthorizationStatusNotDetermined) {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (*stop) {
                granted(YES);
                return;
            }
            *stop = TRUE;
        } failureBlock:^(NSError *error) {
            RIButtonItem *btnCancel = [RIButtonItem itemWithLabel:@"好"];
            
            NSString *title = @"无法访问照片";
            NSString *msg = [NSString stringWithFormat:@"请到系统的隐私设置中，允许%@访问“照片”", APPNAME];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg cancelButtonItem:btnCancel otherButtonItems:nil];
            [alert show];

            return;
        }];
    } else {
        RIButtonItem *btnCancel = [RIButtonItem itemWithLabel:@"好"];
        
        NSString *title = @"无法访问照片";
        NSString *msg = [NSString stringWithFormat:@"请到系统的隐私设置中，允许%@访问“照片”", APPNAME];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg cancelButtonItem:btnCancel otherButtonItems:nil];
        [alert show];
    }
#endif
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation SYUtils (Glance)

+ (void)glanceImages:(NSArray *)array fromIndex:(NSInteger)idx srcImageViews:(NSArray *)srcImageViews
{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:array.count];

    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = obj;
        
        if (srcImageViews) {
            photo.srcImageView = srcImageViews[idx];
        }
        
        [photos addObject:photo];
    }];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = idx;
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

+ (void)previewImages:(NSArray *)array fromIndex:(NSInteger)idx inViewController:(UIViewController *)viewController canDelete:(BOOL)canDelete
{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:array.count];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FSBasicImage *img = nil;
        if ([obj isKindOfClass:[UIImage class]]) {
            img = [[FSBasicImage alloc] initWithImage:obj];
            [photos addObject:img];
        } else if ([obj isKindOfClass:[NSURL class]]) {
            img = [[FSBasicImage alloc] initWithImageURL:obj];
            [photos addObject:img];
        } else if ([obj isKindOfClass:[NSString class]]) {
            img = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:RequestUrlFactory(obj)]];
            [photos addObject:img];
        }
    }];
    
    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:photos];
    FSImageViewerViewController *imgVC = [[FSImageViewerViewController alloc] initWithImageSource:photoSource imageIndex:idx];
    imgVC.deleteDisabled = !canDelete;
    imgVC.backgroundColorVisible = BlackColor;
    
    [[viewController navigationController] pushViewController:imgVC animated:YES];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation SYUtils (Color)

static UIColor *bbbbbbColor = nil;
+ (UIColor *)BBBBBBColor
{
    if (!bbbbbbColor) {
        bbbbbbColor = [UIColor colorFromHexRGB:@"BBBBBB" alpha:1];
    }
    
    return bbbbbbColor;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation SYUtils (HUD)

+ (void)showWindowLevelNotice:(NSString *)notice
{
    [MBProgressHUD hideAllHUDsForView:APP_DELEGATE.window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:YES];
    hud.labelText = notice;
    hud.mode = MBProgressHUDModeText;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (2) * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:APP_DELEGATE.window animated:YES];
    });
}

@end

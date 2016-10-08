//
//  CTAssetsPickerController+Addition.m
//  Soouya
//
//  Created by hetao on 15/6/21.
//  Copyright (c) 2015年 Soouya. All rights reserved.
//

#import "CTAssetsPickerController+Addition.h"

@implementation CTAssetsPickerController (Addition)

- (BOOL)showMaximumNotice
{
    return [self showMaximumNotice:(self.selectedAssets.count < kMaxSelectedFabricsCount)];
}

- (BOOL)showMaximumNotice:(BOOL)canSelect
{
    if (!canSelect) {
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
        dispatch_after(delay, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = [NSString stringWithFormat:@"最多只能添加%@张图片", @(kMaxSelectedFabricsCount)];
            hud.mode = MBProgressHUDModeText;
        });
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (kDefaultHideNoticeIntervel - 0.1) * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
    
    return canSelect;
}

- (BOOL)showMaximumNotice:(BOOL)canSelect count:(NSInteger)maxCount
{
    if (!canSelect) {
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
        dispatch_after(delay, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = [NSString stringWithFormat:@"最多只能添加%@张图片", @(maxCount)];
            hud.mode = MBProgressHUDModeText;
        });
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (kDefaultHideNoticeIntervel - 0.1) * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
    
    return canSelect;
}

@end

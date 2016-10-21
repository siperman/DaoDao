//
//  UIViewController+Addition.m
//  Soouya
//
//  Created by hetao on 15/6/8.
//  Copyright (c) 2015年 Soouya. All rights reserved.
//

#import "UIViewController+Addition.h"
#import "UIView+SYAddition.h"
#import "SYValidation.h"
#import "NSString+SYAddition.h"


#import "SYPrefManager.h"
#import "SYStoryboardManager.h"
//#import "SYWebViewController.h"

@implementation UIViewController (Addition)

- (BOOL)checkLogin
{
    if (([SYPrefManager objectForKey:kSessionCookiesKey] == nil) ||
        ![DDUserManager manager].isLogined ||
        ![DDUserManager manager].user) {
        
        UIViewController *loginNavVC = [[SYStoryboardManager manager].loginSB instantiateViewControllerWithIdentifier:@"DDLoginNav"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:loginNavVC animated:YES completion:^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            }];
        });
        
        return NO;
    }
    
    return ([SYPrefManager objectForKey:kSessionCookiesKey] != nil);
}

- (void)showRequestNotice:(id)response
{    
    if ([response isKindOfClass:[NSDictionary class]] && response[kMsgKey]) {
        if ([response[kSuccessKey] integerValue] != 10009) {
            [self showNotice:response[kMsgKey]];
        } else {
            // 10009 重新登录
            UIViewController *loginNavVC = [[SYStoryboardManager manager].loginSB instantiateViewControllerWithIdentifier:@"DDLoginNav"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentViewController:loginNavVC animated:YES completion:^{
                    [self.navigationController popToRootViewControllerAnimated:NO];
                }];
            });
        }
    } else {
        [self showNotice:@"您的网络不给力哦"];
    }
}

- (void)refreshTableView:(UITableView *)tableView withRefreshControl:(UIRefreshControl *)refreshControl
{
    [tableView setContentOffset:CGPointMake(0, -60.0) animated:YES];
    [refreshControl beginRefreshing];
}

- (void)refreshCollectionView:(UICollectionView *)collectionView withRefreshControl:(UIRefreshControl *)refreshControl
{
    [collectionView setContentOffset:CGPointMake(0, -60.0) animated:YES];
    [refreshControl beginRefreshing];
}

- (void)setBackButtonSelector: (SEL) back {
    if (self.navigationController && self.navigationItem) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [btn setImage:Image(@"icon_back") forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:back forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = btnBack;
    }
}

@end

@implementation UIViewController (Call)

- (void)makeCall:(NSString *)tel
{
    [self makeCall:tel title:tel];
}

- (void)makeCall:(NSString *)tel title:(NSString *)title
{
    [self.view makeCall:tel title:title];
}

@end

@implementation UIViewController (Validation)

- (BOOL)checkInput:(NSString *)input validateForType:(SYValidationType)type andErrorMsg:(NSString *)errorMsg
{
    // 检查乱码和 emoji 表情
    if ([input containsUTF8Errors] || [input stringContainsEmoji]) {
        [self showNotice:@"输入中不能包含特殊字符"];
        return NO;
    }
    
    if (![SYValidation isText:input validateForType:type]) {
        [self showNotice:errorMsg];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)checkInput:(NSString *)input andOtherInput:(NSString *)otherInput validateForType:(SYValidationType)type andErrorMsg:(NSString *)errorMsg
{
    if (![SYValidation isText:input andOtherInput:otherInput validateForType:type]) {
        [self showNotice:errorMsg];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)checkInput:(NSString *)input valueForType:(NSString *)type
{
    return [self checkInput:input valueForType:type showError:YES];
}

- (BOOL)checkInput:(NSString *)input valueForType:(NSString *)type showError:(BOOL)showError
{
    NSString *errMsg = [SYValidation errMsgByCheckValue:input match:type];
    if (!errMsg) {
        return YES;
    }
    
    if (showError) {
        [self showNotice:errMsg];
    }
    
    return NO;
}

@end

@implementation UIViewController (Chat)

//- (void)startConv:(AVIMConversation *)conversation withUser:(DDUser *)user defaultTitle:(NSString *)defaultTitle item:(NSDictionary *)item
//{
//    if ([self checkLogin]) {
//        [[CDChatManager manager].userDelegate cacheUser:user];
//        
//        SYChatRoomViewController *chatRoomVC = [[SYChatRoomViewController alloc] initWithConv:conversation];
//        DDUser *user = [DDUserManager manager].user;
//        NSMutableDictionary *dic = [item mutableCopy];
//        chatRoomVC.item = dic;
//        
//        if (defaultTitle.length > 0) {
//            chatRoomVC.defaultTitle = defaultTitle;
//        } else {
//            if ([user.type integerValue] == DDUserTypeStore) {
//                chatRoomVC.defaultTitle = user.company;
//            } else {
//                chatRoomVC.defaultTitle = user.nickname;
//            }
//        }
//        
//        [self.navigationController pushViewController:chatRoomVC animated:YES];
//    }
//}

@end

@implementation UIViewController (HUD)

- (void)showLoadingHUD
{
    [self.view endEditing:YES];
    
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        [((UIScrollView *)self.view) setScrollEnabled:NO];
    }
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
}

- (void)hideAllHUD
{
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        [((UIScrollView *)self.view) setScrollEnabled:YES];
    }
    
    dispatch_time_t delayHide = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(delayHide, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)showNotice:(NSString *)notice
{
    [self.view endEditing:YES];
    
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        [((UIScrollView *)self.view) setScrollEnabled:NO];
    }
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = (notice);
        hud.mode = MBProgressHUDModeText;
    });
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (kDefaultHideNoticeIntervel - 0.1) * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            [((UIScrollView *)self.view) setScrollEnabled:YES];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)showSuccessHUD
{
    [self.view endEditing:YES];

    if ([self.view isKindOfClass:[UIScrollView class]]) {
        [((UIScrollView *)self.view) setScrollEnabled:NO];
    }

    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.customView = [[UIImageView alloc] initWithImage:Image(@"Checkmark")];
        hud.mode = MBProgressHUDModeCustomView;
    });

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (kDefaultHideNoticeIntervel - 0.1) * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            [((UIScrollView *)self.view) setScrollEnabled:YES];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)showLoadingHUDImmediately
{
    [self.view endEditing:YES];
    
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        [((UIScrollView *)self.view) setScrollEnabled:NO];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

@end

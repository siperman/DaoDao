//
//  UIViewController+Addition.h
//  Soouya
//
//  Created by hetao on 15/6/8.
//  Copyright (c) 2015年 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Addition)

- (BOOL)checkLogin;

- (void)showRequestNotice:(id)response;

- (void)refreshTableView:(UITableView *)tableView withRefreshControl:(UIRefreshControl *)refreshControl;

- (void)refreshCollectionView:(UICollectionView *)collectionView withRefreshControl:(UIRefreshControl *)refreshControl;

- (void)setBackButtonSelector: (SEL)back;

@end

@interface UIViewController (Call)

- (void)makeCall:(NSString *)tel;

- (void)makeCall:(NSString *)tel title:(NSString *)title;

@end

@interface UIViewController (Validation)

- (BOOL)checkInput:(NSString *)input validateForType:(SYValidationType)type andErrorMsg:(NSString *)errorMsg;

- (BOOL)checkInput:(NSString *)input andOtherInput:(NSString *)otherInput validateForType:(SYValidationType)type andErrorMsg:(NSString *)errorMsg;

- (BOOL)checkInput:(NSString *)input valueForType:(NSString *)type;

- (BOOL)checkInput:(NSString *)input valueForType:(NSString *)type showError:(BOOL)showError;

@end

//@interface UIViewController (Chat)
//
//- (void)startConv:(AVIMConversation *)conversation withUser:(DDUser *)user defaultTitle:(NSString *)defaultTitle item:(NSDictionary *)item;
//
//@end

@interface UIViewController (HUD)

- (void)showLoadingHUD;

- (void)hideAllHUD;

- (void)showNotice:(NSString *)notice;

- (void)showLoadingHUDImmediately;

- (void)showSuccessHUD;

@end
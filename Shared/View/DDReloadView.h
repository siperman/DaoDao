//
//  DDReloadView.h
//  DaoDao
//
//  Created by hetao on 2016/10/8.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDReloadView : UIControl

@property (nonatomic, strong) void(^reloadBlock)();

+ (instancetype)showReloadViewOnView:(UIView *)view reloadAction:(void(^)())reload;

@end

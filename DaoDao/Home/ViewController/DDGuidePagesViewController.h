//
//  DDGuidePagesViewController.h
//  DaoDao
//
//  Created by hetao on 2016/11/29.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDGuidePagesProtocol <NSObject>
- (void)guideDone;
@end

@interface DDGuidePagesViewController : UIViewController
@property (nonatomic, strong) UIButton *btnEnter;
// 初始化引导页
- (void)initWithGuideImages:(NSArray *)images;
// 版本信息判断
+ (BOOL)isShow;
@property (nonatomic, assign) id<DDGuidePagesProtocol> delegate;
// 创建单利类
+ (instancetype)shareGuideVC;

@end

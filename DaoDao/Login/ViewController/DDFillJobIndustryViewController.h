//
//  DDFillJobIndustryViewController.h
//  DaoDao
//
//  Created by hetao on 16/9/28.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^fillBlock)(NSString *);
@interface DDFillJobIndustryViewController : UIViewController

@property (nonatomic) BOOL isFillJob;
@property (nonatomic, copy) fillBlock callback;
@property (nonatomic, copy) NSString *fillStr;

+ (instancetype)viewController;
@end

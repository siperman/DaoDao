//
//  DDChooseFavGoodViewController.h
//  DaoDao
//
//  Created by hetao on 16/9/21.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDChooseFavGoodViewController;
@protocol DDChooseFavGoodViewControllerProtocol <NSObject>

- (void)chooseFavGood:(DDChooseFavGoodViewController *)vc;

@end

@interface DDChooseFavGoodViewController : UIViewController

@property (nonatomic) BOOL isChooseFav;
@property (nonatomic, weak) id<DDChooseFavGoodViewControllerProtocol> delegete;
@property (nonatomic, strong) NSString *chooseValues;

+ (instancetype)FavVC;
+ (instancetype)GoodVC;

@end

//
//  DDCalendarViewController.h
//  DaoDao
//
//  Created by hetao on 16/9/23.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDChooseTimeProtocol <NSObject>

- (void)chooseTime:(NSTimeInterval)time;

@end

@interface DDCalendarViewController : UIViewController

@property (nonatomic, weak) id<DDChooseTimeProtocol> delegete;
@end

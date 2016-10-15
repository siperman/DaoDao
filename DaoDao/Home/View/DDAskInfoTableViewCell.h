//
//  DDAskInfoTableViewCell.h
//  DaoDao
//
//  Created by hetao on 16/9/30.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDAskInfoProtocol <NSObject>

- (void)interest:(DDAsk *)askInfo;
- (void)disinterest:(DDAsk *)askInfo;

@end

@interface DDAskInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) DDAsk *askInfo;
@property (nonatomic, weak) id<DDAskInfoProtocol> delegete;

+ (CGFloat)cellHeight;

@end

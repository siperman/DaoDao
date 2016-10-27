//
//  DDUserInfoTableViewCell.h
//  DaoDao
//
//  Created by hetao on 2016/10/26.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDUserInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) DDUser *user;
+ (CGFloat)cellHeight;
@end

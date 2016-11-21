//
//  DDBaseTableViewCell.h
//  DaoDao
//
//  Created by hetao on 2016/10/31.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

// 基类cell
@interface DDBaseTableViewCell : UITableViewCell

- (void)configureCellWithData:(id)data;
+ (CGFloat)cellHeight;

@end

//
//  GYZLocalCityCell.h
//  DaoDao
//
//  Created by hetao on 2016/11/28.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYZCity.h"
#import "GYZChooseCityDelegate.h"


@interface GYZLocalCityCell : UITableViewCell
@property (nonatomic,assign) id <GYZCityGroupCellDelegate> delegate;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  暂无数据
 */
@property (nonatomic, strong) UILabel *noDataLabel;
@end

//
//  DDDemandInfoTableViewCell.h
//  DaoDao
//
//  Created by hetao on 2016/10/27.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBaseTableViewCell.h"

@interface DDDemandInfoTableViewCell : DDBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labDemand;
@property (weak, nonatomic) IBOutlet UILabel *labDesc;

@end

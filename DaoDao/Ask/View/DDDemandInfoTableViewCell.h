//
//  DDDemandInfoTableViewCell.h
//  DaoDao
//
//  Created by hetao on 2016/10/27.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDDemandInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labDemand;
@property (weak, nonatomic) IBOutlet UILabel *labDesc;

- (void)configureCellWithData:(id)data;
@end

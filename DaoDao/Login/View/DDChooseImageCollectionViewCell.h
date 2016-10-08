//
//  DDChooseImageCollectionViewCell.h
//  DaoDao
//
//  Created by hetao on 16/9/14.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDChooseImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *labDesc;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageSelect;

- (void)choose:(BOOL)value;
+ (CGSize)cellSize;

@end

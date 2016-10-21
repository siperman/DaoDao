//
//  DDChooseImageCollectionViewCell.m
//  DaoDao
//
//  Created by hetao on 16/9/14.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDChooseImageCollectionViewCell.h"

@interface DDChooseImageCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@end

@implementation DDChooseImageCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.layer.cornerRadius = kCornerRadius;
    self.layer.masksToBounds = YES;
    self.backView.backgroundColor = MainColor;
}

- (void)choose:(BOOL)value
{
    self.imageSelect.image = value ? Image(@"icon_choiceSure") : Image(@"icon_choice");
    self.backView.hidden = !value;
}

+ (CGSize)cellSize
{
    CGFloat w = (SCREEN_WIDTH - 16.0) / 3;
    return CGSizeMake(w, w);
}
@end

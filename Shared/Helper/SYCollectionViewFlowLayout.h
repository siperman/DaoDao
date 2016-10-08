//
//  SYCollectionViewFlowLayout.h
//  Soouya
//
//  Created by hetao on 15/12/8.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  SYCollectionViewFlowLayout;

@protocol SYCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>
@optional
- (void)finishFlowLayout:(CGSize)contentSize;
@required
/**
 *  The delegate method set the collectionView will flow layout as the number columns in each section.
 *
 *  @param collectionView The effect collectionView
 *  @param layout         The SYCollectionViewFlowLayout inilization object.
 *  @param section        The section index
 *
 *  @return The number of columns in each section.
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView
                     layout:(SYCollectionViewFlowLayout *)layout
   numberOfColumnsInSection:(NSInteger)section;

@end


@interface SYCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<SYCollectionViewDelegateFlowLayout> delegate;
/**
 *  Defalut is NO, set it's YES the collectionView's header will sticky on the section top.
 */
@property (nonatomic) BOOL enableStickyHeaders;

@end
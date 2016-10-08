//
//  DDChessboardView.h
//  DaoDao
//
//  Created by hetao on 16/9/29.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDChessPiece.h"
#import "DDChess.h"

@interface DDChessboardView : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSArray <DDChess *>* chessArray;

+ (CGSize)boardSize;

@end

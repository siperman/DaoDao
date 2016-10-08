//
//  DDChessPiece.h
//  DaoDao
//
//  Created by hetao on 16/9/22.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDChess.h"

@interface DDChessPiece : UIControl

@property (nonatomic) BOOL isLighting;
@property (nonatomic, strong) DDChess *chess;

+ (instancetype)chessPiece:(DDChess *)chess;
- (void)lighting;
- (void)stopLighting;

@end

//
//  DDChessPiece.m
//  DaoDao
//
//  Created by hetao on 16/9/22.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDChessPiece.h"
#import "DDChessDetailViewController.h"

@interface DDChessPiece ()

@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) UIImageView *light1;
@property (nonatomic, strong) UIImageView *light2;
@property (nonatomic, strong) UIImageView *shandow;

@end
/*
 黑色棋子实现

 1.四张，阴影、黑色的圆，light2  light1
 2.light2 & 1 一起出现，2 用时 1s，1 用时 1.5
 3.light2 出现之后在消失，用时 1s，然后在用 1s 等待，等待完之后就循环
 4.light1 出现之后就消失，也是 1.5s，不用等待，正好赶上 2 然后直接循环
 5.阴影跟着 light1 动画 透明度从 1 变到 0.5
 */
@implementation DDChessPiece

#define BigChessRect CGRectMake(0, 0, 90, 90)
#define SmallChessRect CGRectMake(0, 0, 80, 80)
+ (instancetype)chessPiece:(DDChess *)chess
{
    DDChessPiece *cp = [[self alloc] initWithFrame:chess.isBig ? BigChessRect : SmallChessRect];
    cp.chess = chess;
    [cp setUpView];
    !chess.isLighting ?: [cp lighting];
    [cp addTarget:cp action:@selector(click) forControlEvents:UIControlEventTouchUpInside];

    return cp;
}

- (void)setUpView
{
    _shandow = [[UIImageView alloc] initWithFrame:self.bounds];
    _shandow.image = Image(@"shandow");
    [self addSubview:_shandow];

    CGRect rect = self.bounds;
    _lab = [[UILabel alloc] initWithFrame:CGRectInset(rect, 20, 20)];
    _lab.text = _chess.cid;
    _lab.font = NormalTextFont;
    _lab.textAlignment = NSTextAlignmentCenter;
    _lab.numberOfLines = 0;
    if (_chess.isWhite) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
        imgView.image = Image(@"chess-white");
        [self addSubview:imgView];

        _light1 = nil;

        _light2 = [[UIImageView alloc] initWithFrame:rect];
        _light2.image = Image(@"light-hei");
        [self addSubview:_light2];
        _lab.textColor = MainColor;
    } else {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
        imgView.image = Image(@"chess-black");
        [self addSubview:imgView];

        _light1 = [[UIImageView alloc] initWithFrame:rect];
        _light1.image = Image(@"light1");
        [self addSubview:_light1];

        _light2 = [[UIImageView alloc] initWithFrame:rect];
        _light2.image = Image(@"light2");
        [self addSubview:_light2];
        _lab.textColor = WhiteColor;
    }
    _light1.hidden = YES;
    _light2.hidden = YES;
    [self addSubview:_lab];
}

- (void)lighting
{
    _isLighting = YES;
    _light1.hidden = NO;
    _light2.hidden = NO;

    if (YES) {
        CAKeyframeAnimation *l1 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        l1.values = @[@0, @1, @0];
        l1.duration = 3.0;
        l1.repeatCount = CGFLOAT_MAX;

        [_light1.layer addAnimation:l1 forKey:@"opacity"];


        CAKeyframeAnimation *l2 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        l2.values = @[@0, @1, @0, @0];
        l2.duration = 3.0;
        l2.repeatCount = CGFLOAT_MAX;

        [_light2.layer addAnimation:l2 forKey:@"opacity"];


        CAKeyframeAnimation *shandow = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        shandow.values = @[@1, @.5, @1];
        shandow.duration = 3.0;
        shandow.repeatCount = CGFLOAT_MAX;

        [_shandow.layer addAnimation:shandow forKey:@"opacity"];
    }
}

- (void)stopLighting
{
    _isLighting = NO;
    _light1.hidden = YES;
    _light2.hidden = YES;

    [_light1.layer removeAllAnimations];
    [_light2.layer removeAllAnimations];
    [_shandow.layer removeAllAnimations];
}

- (void)click
{
    [self.viewController showNotice:_chess.cid];
    DDChessDetailViewController *vc = [DDChessDetailViewController viewController];
    vc.cid = self.chess.cid;
    [self.viewController.navigationController pushViewController:vc animated:YES];

    [MobClick event:Home_pieces_click];
}

@end

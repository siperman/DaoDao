//
//  DDChessboardView.m
//  DaoDao
//
//  Created by hetao on 16/9/29.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDChessboardView.h"
#import "DDChessPiece.h"

@interface DDChessboardView () <UIScrollViewDelegate>

@property (nonatomic) NSInteger totalPage;
@end


@implementation DDChessboardView

static const NSInteger pageChess = 7;
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.scrollView.delegate = self;
//    self.pageControl.hidden = YES;
}

- (void)refresh
{
    [[self.scrollView subviews] enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (_chessArray.count % pageChess == 0) {
        _totalPage = _chessArray.count / pageChess;
    } else {
        _totalPage = (_chessArray.count - _chessArray.count % pageChess) / pageChess + 1;
    }

    self.pageControl.numberOfPages = _totalPage;
    CGFloat width = SCREEN_WIDTH;
    self.scrollView.contentSize = CGSizeMake(width * _totalPage, pageChess * 5 / 4);
    for (NSInteger i = 0; i < _totalPage; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
        imageView.origin = CGPointMake(width * i, 0);
        [imageView setImage:Image(@"qipan_zhong")];

        [self.scrollView addSubview:imageView];
    }

    for (NSInteger i = 0; i < _chessArray.count; i++) {
        DDChessPiece *cp = [DDChessPiece chessPiece:_chessArray[i]];
        cp.center = [self pointAtIndex:i];

        [self.scrollView addSubview:cp];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {

    int page = _scrollView.contentOffset.x / 290; //通过滚动的偏移量来判断目前页面所对应的小白点

    _pageControl.currentPage = page;
}

- (IBAction)changePage:(UIPageControl *)sender
{
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * sender.currentPage, 0) animated:YES];
}


- (void)setChessArray:(NSArray<DDChess *> *)chessArray
{
    if (_chessArray != chessArray) {
        _chessArray = chessArray;
        [self refresh];
    }
}

- (CGPoint)pointAtIndex:(NSInteger)index
{
    NSInteger page = (index - index % pageChess) / pageChess;
    CGFloat width = SCREEN_WIDTH / 4;
    CGFloat x = page * SCREEN_WIDTH;
    switch (index % pageChess) {
        case 0:
            return CGPointMake(2 * width + x, 2 * width);
            break;
        case 1:
            return CGPointMake(2 * width + x, 1 * width);
            break;
        case 2:
            return CGPointMake(3 * width + x, 2 * width);
            break;
        case 3:
            return CGPointMake(1 * width + x, 3 * width);
            break;
        case 4:
            return CGPointMake(2 * width + x, 3 * width);
            break;
        case 5:
            return CGPointMake(2 * width + x, 4 * width);
            break;
        default:
            return CGPointMake(3 * width + x, 4 * width);
            break;
    }
}

+ (CGSize)boardSize
{
    CGFloat width = SCREEN_WIDTH;
    return CGSizeMake(width, 40 + 5 * width / 4);
}

@end

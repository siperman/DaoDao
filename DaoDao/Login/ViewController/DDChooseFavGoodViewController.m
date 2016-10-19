//
//  DDChooseFavGoodViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/21.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDChooseFavGoodViewController.h"
#import "DDChooseImageCollectionViewCell.h"
#import "DDConfig.h"
#import "ChooseImageViewModel.h"
#import "UIImage+ImageWithColor.h"

@interface DDChooseFavGoodViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (nonatomic, strong) NSArray <ChooseImageViewModel*> *data;
@property (nonatomic) NSUInteger selectCount;
@end

@implementation DDChooseFavGoodViewController

+ (instancetype)FavVC
{
    DDChooseFavGoodViewController *vc = [[SYStoryboardManager manager].loginSB instantiateViewControllerWithIdentifier:@"DDChooseFavGoodViewController"];
    vc.isChooseFav = YES;

    return vc;
}

+ (instancetype)GoodVC
{
    DDChooseFavGoodViewController *vc = [[SYStoryboardManager manager].loginSB instantiateViewControllerWithIdentifier:@"DDChooseFavGoodViewController"];
    vc.isChooseFav = NO;

    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = BackgroundColor;
    self.collectionView.backgroundColor = ClearColor;
    [self.collectionView registerNib:[DDChooseImageCollectionViewCell class]];
    self.flowLayout.itemSize = [DDChooseImageCollectionViewCell cellSize];
    self.flowLayout.minimumLineSpacing = 4.0;
    self.flowLayout.minimumInteritemSpacing = 4.0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(4, 4, 50, 4);

    if (self.isChooseFav) {
        self.labTitle.text = @"为了更精准的帮您找到靠谱的人，请至少选择3项";
        self.data = [ChooseImageViewModel parseFromDicts:[DDConfig topic]];
        self.title = @"感兴趣话题";
    } else {
        self.labTitle.text = @"为了更精准的帮您找到靠谱的人，请选择1~3项";
        self.data = [ChooseImageViewModel parseFromDicts:[DDConfig expert]];
        self.title = @"您是哪方面的专家";
    }
    [self.labTitle setFont:NormalTextFont];
    [self.labTitle setTextColor:MainColor];
    [self.btnNext setBackgroundImage:[UIImage imageWithColor:TextColor] forState:UIControlStateDisabled];
    self.btnNext.enabled = NO;
}

- (IBAction)next:(UIButton *)sender
{
    if ([self.delegete respondsToSelector:@selector(chooseFavGood:)]) {
        NSMutableString *str = [NSMutableString stringWithString:@""];
        for (ChooseImageViewModel *model in self.data) {
            if (model.selected) {
                [str appendFormat:@"%@,", model.name];
            }
        }
        !str.length ?: [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];

        self.chooseValues = str;
        [self.delegete chooseFavGood:self];
    }
}

#pragma mark UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.data count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    ChooseImageViewModel *model = [self.data objectAtIndex:row];

    DDChooseImageCollectionViewCell *cell = [self.collectionView dequeueCell:[DDChooseImageCollectionViewCell class] indexPath:indexPath];

    cell.labDesc.text = model.name;
    [cell choose:model.selected];
    [cell.imageView sy_setImageWithUrl:model.imgUrl];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    ChooseImageViewModel *model = [self.data objectAtIndex:row];

    model.selected = !model.selected;
    model.selected ? _selectCount++ : _selectCount--;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];

    if (self.isChooseFav) {
        self.btnNext.enabled = (_selectCount >= 3);
    } else {
        self.btnNext.enabled = (_selectCount > 0 && _selectCount <= 3);
    }
}

@end

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
#import "DDPostAskTableViewController.h"

#import <UINavigationController+FDFullscreenPopGesture.h>

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
        for (NSString *str in self.placeholderArray) {
            for (ChooseImageViewModel *model in self.data) {
                if ([str isEqualToString:model.name]) {
                    model.selected = YES;
                    _selectCount ++;
                    break;
                }
            }
        }

        self.title = @"感兴趣话题";
        [self.btnNext setTitle:@"开启道道"];
    } else {
        self.labTitle.text = @"为了更精准的帮您找到靠谱的人，请选择1~3项";
        self.data = [ChooseImageViewModel parseFromDicts:[DDConfig expert]];
        for (NSString *str in self.placeholderArray) {
            for (ChooseImageViewModel *model in self.data) {
                if ([str isEqualToString:model.name]) {
                    model.selected = YES;
                    _selectCount ++;
                    break;
                }
            }
        }

        if (self.navigationController.presentingViewController) {
            self.title = @"您是哪方面的专家";
        } else {
            BOOL isPostAsk = NO;
            NSArray *vcs = [self.navigationController viewControllers];
            for (UIViewController *vc in vcs) {
                if ([vc isKindOfClass:[DDPostAskTableViewController class]]) {
                    isPostAsk = YES;
                    break;
                }
            }
            self.title = isPostAsk ? @"选择专家" : @"擅长的领域";
        }
    }
    [self.labTitle setFont:NormalTextFont];
    [self.labTitle setTextColor:MainColor];
    [self.btnNext setBackgroundImage:[UIImage imageWithColor:TextColor] forState:UIControlStateDisabled];
    self.btnNext.enabled = NO;

    if (self.navigationController.presentingViewController) {
        [self.navigationItem setHidesBackButton:YES];
        self.fd_interactivePopDisabled = YES;
    } else {
        self.btnNext.hidden = YES;

        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(next:)];
        item.enabled = NO;
        self.navigationItem.rightBarButtonItem = item;
    }
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

    if (!model.selected &&
        !self.isChooseFav &&
        _selectCount == 3) {
        [self showNotice:@"最多可勾选3项喔！"];
        return;
    }

    model.selected = !model.selected;
    model.selected ? _selectCount++ : _selectCount--;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];

    if (self.isChooseFav) {
        self.btnNext.enabled = (_selectCount >= 3);
        self.navigationItem.rightBarButtonItem.enabled = self.btnNext.enabled;
    } else {
        self.btnNext.enabled = (_selectCount > 0 && _selectCount <= 3);
        self.navigationItem.rightBarButtonItem.enabled = self.btnNext.enabled;
    }
}

@end

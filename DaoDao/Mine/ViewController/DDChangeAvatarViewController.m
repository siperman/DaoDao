//
//  DDChangeAvatarViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/16.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDChangeAvatarViewController.h"
#import "SYCameraManager.h"

@interface DDChangeAvatarViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation DDChangeAvatarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"头像";
    self.view.backgroundColor = BlackColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:Image(@"icon_xuanxiang") style:UIBarButtonItemStylePlain target:self action:@selector(popMenu)];

    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)popMenu
{
    [[SYCameraManager sharedInstance] getOrSaveAvatarInViewController:self callback:^(NSArray *photos) {
        if (!photos) {
            if (self.imageView.image) {
                UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
                [self showNotice:@"保存成功"];
            }
        } else {
            [self.imageView setImage:photos.lastObject];
            [self uploadAvatar];
        }
    }];
}

- (void)uploadAvatar
{
    [self.navigationController showLoadingHUD];
    [SYRequestEngine updateUserInfo:nil avatar:self.imageView.image callback:^(BOOL success, id response) {
        [self.navigationController hideAllHUD];
        if (success) {
            DDUser *user = [DDUser fromDict:response[kObjKey]];
            [DDUserManager manager].user = user;
        } else {
            [self.navigationController showRequestNotice:response];
        }
    }];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView sy_setImageWithUrl:[DDUserManager manager].user.headUrl];
    }
    return _imageView;
}

@end

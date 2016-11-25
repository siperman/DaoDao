//
//  DDMainLoginViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/8.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDMainLoginViewController.h"
#import "SYPrefManager.h"

@interface DDMainLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end

@implementation DDMainLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.btnRegister actionStyle];
    [self.btnLogin actionTransparentStyle];
    if ([SYPrefManager boolForKey:kAgoLogined]) {
        [self.btnLogin sendActionsForControlEvents:UIControlEventTouchUpInside];
        [SYPrefManager setBool:NO forKey:kAgoLogined];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

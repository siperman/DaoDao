//
//  DDMainLoginViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/8.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDMainLoginViewController.h"

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end

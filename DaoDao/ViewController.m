//
//  ViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/2.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "ViewController.h"
#import "GYZChooseCityController.h"
#import "DDChessPiece.h"
#import "DDCalendarViewController.h"

@interface ViewController () <GYZChooseCityDelegate>

@property (nonatomic, strong) DDChessPiece *chess;
@property (weak, nonatomic) IBOutlet UIButton *chooseCityBtn;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"道道";


//    DDChessPiece *chess = [DDChessPiece bigBlackChess];

//    [self.view addSubview:chess];
//    chess.center = self.view.center;
//    _chess = chess;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkLogin];
}

- (IBAction)city:(UIButton *)sender
{
//    DDCalendarViewController *vc = [[DDCalendarViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    if (_chess.isLighting) {
        [_chess stopLighting];
    } else {
        [_chess lighting];
    }
//    [self showLoadingHUD];
//    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES ];

//    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
//    [cityPickerVC setDelegate:self];
//
//    //    cityPickerVC.locationCityID = @"1400010000";
//    //    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
//        cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
//
//    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
//
//    }];

}

#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    [_chooseCityBtn setTitle:city.cityName forState:UIControlStateNormal];
    [chooseCityController dismissViewControllerAnimated:YES completion:^{

    }];
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
    [chooseCityController dismissViewControllerAnimated:YES completion:^{

    }];
}


@end

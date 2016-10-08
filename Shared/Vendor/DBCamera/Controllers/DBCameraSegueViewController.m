//
//  DBCameraSegueViewController.hViewController
//  CropImage
//
//  Created by Daniele Bogo on 19/04/14.
//  Copyright (c) 2014 Daniele Bogo. All rights reserved.
//


/**
 *  Removed filters
 *
 */


#import "DBCameraSegueViewController.h"

@interface DBCameraSegueViewController ()
@end

@implementation DBCameraSegueViewController
@synthesize forceQuadCrop = _forceQuadCrop;
@synthesize useCameraSegue = _useCameraSegue;
@synthesize tintColor = _tintColor;
@synthesize selectedTintColor = _selectedTintColor;
@synthesize cameraSegueConfigureBlock = _cameraSegueConfigureBlock;

- (id) initWithImage:(UIImage *)image thumb:(UIImage *)thumb
{
    return nil;
}

- (void)createInterface
{
    
}

@end
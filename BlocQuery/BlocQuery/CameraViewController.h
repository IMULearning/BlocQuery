//
//  CameraViewController.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-21.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <DBCamera/DBCameraContainerViewController.h>

@class CameraViewController;

@protocol CameraViewControllerDelegate <NSObject>

- (void) cameraViewController:(CameraViewController *)controller didFinishWithImage:(UIImage *)image;

@end

@interface CameraViewController : DBCameraContainerViewController

@property (nonatomic, strong) id <CameraViewControllerDelegate> cameraDelegate;

@end

//
//  CameraViewController.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-21.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "CameraViewController.h"
#import <RSKImageCropViewController.h>

@interface CameraViewController () <DBCameraViewControllerDelegate, RSKImageCropViewControllerDelegate>

@end

@implementation CameraViewController

- (instancetype)init {
    self = [super initWithDelegate:self];
    if (self) {
        [self setFullScreenMode];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - DBCameraViewControllerDelegate

- (void)dismissCamera:(id)cameraViewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata {
    NSLog(@"Received!");
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    if (self.cameraDelegate) {
        [self.cameraDelegate cameraViewController:self didFinishWithImage:croppedImage];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

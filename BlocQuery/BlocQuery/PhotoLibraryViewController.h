//
//  PhotoLibraryViewController.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-21.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoLibraryViewController;

@protocol PhotoLibraryViewControllerDelegate <NSObject>

- (void) photoLibraryViewController:(PhotoLibraryViewController *)controller didFinishWithImage:(UIImage *)image;

@end

@interface PhotoLibraryViewController : UICollectionViewController

@property (nonatomic, weak) id <PhotoLibraryViewControllerDelegate> delegate;

@end

//
//  StockAvatarViewController.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-21.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StockAvatarViewController;

@protocol StockAvatarViewControllerDelegate <NSObject>

- (void) stockAvatarViewController:(StockAvatarViewController *)controller didSelectImage:(UIImage *)image;

@end

@interface StockAvatarViewController : UICollectionViewController

@property (nonatomic, weak) id <StockAvatarViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *stockPhotos;

@end

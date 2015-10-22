//
//  StockAvatarViewController.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-21.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "StockAvatarViewController.h"

@interface StockAvatarViewController ()

@end

static NSInteger imageViewTag = 1234;

@implementation StockAvatarViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat minWidth = 80;
    NSInteger divisor = width / minWidth;
    CGFloat cellSize = (width - (divisor - 1) * 1) / divisor;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(cellSize, cellSize);
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
}

#pragma mark - Collection data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stockPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:imageViewTag];
    [imageView setImage:self.stockPhotos[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = self.stockPhotos[indexPath.row];
    if (self.delegate) {
        [self.delegate stockAvatarViewController:self didSelectImage:image];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

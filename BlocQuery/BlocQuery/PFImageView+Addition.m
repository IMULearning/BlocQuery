//
//  PFImageView+Addition.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-21.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "PFImageView+Addition.h"

@implementation PFImageView (Addition)

- (void) clearFile {
    self.file = nil;
    self.image = [UIImage defaultAvatar];
}

@end

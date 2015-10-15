//
//  UIImage+Gravatar.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-15.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Gravatar)

+ (UIImage *) imageWithGravatarEmail:(NSString *)email size:(NSUInteger)size fallbackImage:(UIImage *)fallback;

@end

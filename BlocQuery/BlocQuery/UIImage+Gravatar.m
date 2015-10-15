//
//  UIImage+Gravatar.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-15.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "UIImage+Gravatar.h"
#import "NSString+Validator.h"
#import "NSString+Hash.h"

@implementation UIImage (Gravatar)

+ (UIImage *) imageWithGravatarEmail:(NSString *)email size:(NSUInteger)size fallbackImage:(UIImage *)fallback {
    NSAssert([email isValidEmailWithStrictFilter:NO], @"Must provide a valid email");
    
    NSString *gravatarUrl = [NSString stringWithFormat:@"https://s.gravatar.com/avatar/%@?s=%ld", [email MD5], size];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:gravatarUrl]];
    if (!imageData) {
        return fallback;
    }
    
    return [UIImage imageWithData:imageData];
}

@end

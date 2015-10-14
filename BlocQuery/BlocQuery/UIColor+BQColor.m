//
//  UIColor+BQColor.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "UIColor+BQColor.h"

@implementation UIColor (BQColor)

+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha {
    unsigned int hexInt = 0;

    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexInt];
    
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexInt & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexInt & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexInt & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

+ (UIColor *) alizarinRed {
    return [self colorwithHexString:@"#e74c3c" alpha:1.0];
}

+ (UIColor *) peterRiverBlue {
    return [self colorwithHexString:@"#3498db" alpha:1.0];
}

+ (UIColor *) emraldGreen {
    return [self colorwithHexString:@"#2ecc71" alpha:1.0];
}

+ (UIColor *) sunFlowerYellow {
    return [self colorwithHexString:@"#f1c40f" alpha:1.0];
}

+ (UIColor *) wisteriaPurple {
    return [self colorwithHexString:@"#8e44ad" alpha:1.0];
}

@end

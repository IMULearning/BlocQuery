//
//  UIColor+BQColor.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BQColor)

+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

/* #e74c3c */
+ (UIColor *) alizarinRed;

/* #3498db */
+ (UIColor *) peterRiverBlue;

/* #2ecc71 */
+ (UIColor *) emraldGreen;

/* #f1c40f */
+ (UIColor *) sunFlowerYellow;

/* #8e44ad */
+ (UIColor *) wisteriaPurple;

@end

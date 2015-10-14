//
//  NSString+Validator.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "NSString+Validator.h"

const NSString *EMAIL_REGEX_STRICT = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
const NSString *EMAIL_REGEX = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
const NSString *PASSWORD_REGEX = @"^(?=.*\\d).{8,16}$";

@implementation NSString (Validator)

- (BOOL) isValidEmailWithStrictFilter:(BOOL)shouldApplyStrictFilter {
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", shouldApplyStrictFilter ? EMAIL_REGEX_STRICT : EMAIL_REGEX];
    return [emailTest evaluateWithObject:self];
}

- (BOOL) isValidPassword {
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORD_REGEX];
    return [passwordTest evaluateWithObject:self];
}

@end

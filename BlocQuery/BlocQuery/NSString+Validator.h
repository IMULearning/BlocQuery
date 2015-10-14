//
//  NSString+Validator.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString *EMAIL_REGEX_STRICT;
extern const NSString *EMAIL_REGEX;
extern const NSString *PASSWORD_REGEX;

@interface NSString (Validator)

- (BOOL) isValidEmailWithStrictFilter:(BOOL)shouldApplyStrictFilter;

- (BOOL) isValidPassword;

@end

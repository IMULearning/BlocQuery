//
//  LoginFormValidator.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "LoginFormValidator.h"
#import "NSString+Validator.h"

@implementation LoginFormValidator

+ (id<FormValidator>)validator {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [LoginFormValidator new];
    });
    return instance;
}

- (BOOL)isFormValid:(NSDictionary *)form errors:(NSArray **)errors {
    NSString *email = form[@"email"];
    NSMutableArray *localErrors = [NSMutableArray array];
    BOOL isValid = YES;
    
    if (![email isValidEmailWithStrictFilter:NO]) {
        isValid = NO;
        [localErrors addObject:[self emailInvalidError]];
    }
    
    if (!isValid)
        *errors = localErrors;
    
    return isValid;
}

- (NSError *) emailInvalidError {
    return [NSError errorWithDomain:BQLoginFormaValidationErrorDomain
                               code:-1
                           userInfo:[NSError emailInvalidErrorUserInfo]];
}

@end

//
//  SignupFormValidator.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "SignupFormValidator.h"
#import "NSString+Validator.h"

@implementation SignupFormValidator

+ (id<FormValidator>)validator {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[SignupFormValidator alloc] init];
    });
    return instance;
}

- (BOOL)isFormValid:(NSDictionary *)form errors:(NSArray *__autoreleasing *)errors {
    NSString *email = form[@"email"];
    NSString *password = form[@"password"];
    NSString *firstName = form[@"firstName"];
    NSString *lastName = form[@"lastName"];
    NSMutableArray *localErrors = [NSMutableArray array];
    BOOL isValid = YES;
    
    if (![email isValidEmailWithStrictFilter:NO]) {
        isValid = NO;
        [localErrors addObject:[self emailInvalidError]];
    }
    
    if (![password isValidPassword]) {
        isValid = NO;
        [localErrors addObject:[self passwordInvalidError]];
    }
    
    if ([firstName length] == 0) {
        isValid = NO;
        [localErrors addObject:[self firstNameNullError]];
    }
    
    if ([lastName length] == 0) {
        isValid = NO;
        [localErrors addObject:[self lastNameNullError]];
    }
    
    if (!isValid)
        *errors = localErrors;
    
    return isValid;
}

- (NSError *) emailInvalidError {
    return [NSError errorWithDomain:BQSignupFormValidationErrorDomain
                               code:-1
                           userInfo:[NSError emailInvalidErrorUserInfo]];
}

- (NSError *) passwordInvalidError {
    return [NSError errorWithDomain:BQSignupFormValidationErrorDomain
                               code:-1
                           userInfo:[NSError passwordInvalidErrorUserInfo]];
}

- (NSError *) firstNameNullError {
    return [NSError errorWithDomain:BQSignupFormValidationErrorDomain
                               code:-1
                           userInfo:[NSError firstNameNullErrorUserInfo]];
}

- (NSError *) lastNameNullError {
    return [NSError errorWithDomain:BQSignupFormValidationErrorDomain
                               code:-1
                           userInfo:[NSError lastNameNullErrorUserInfo]];
}

@end

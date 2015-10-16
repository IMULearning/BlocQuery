//
//  SignupFormValidator.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "SignupFormValidator.h"
#import "NSString+Validator.h"
#import "ErrorHandler.h"

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
        [localErrors addObject:[NSError blocQueryErrorWithCode:BQError_InvalidEmail context:nil params:nil]];
    }
    
    if (![password isValidPassword]) {
        isValid = NO;
        [localErrors addObject:[NSError blocQueryErrorWithCode:BQError_InvalidPassword context:nil params:nil]];
    }
    
    if ([firstName length] == 0) {
        isValid = NO;
        [localErrors addObject:[NSError blocQueryErrorWithCode:BQError_InvalidFirstName context:nil params:nil]];
    }
    
    if ([lastName length] == 0) {
        isValid = NO;
        [localErrors addObject:[NSError blocQueryErrorWithCode:BQError_InvalidLastName context:nil params:nil]];
    }
    
    if (!isValid)
        *errors = localErrors;
    
    return isValid;
}

@end

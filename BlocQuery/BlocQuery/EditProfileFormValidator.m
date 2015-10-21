//
//  EditProfileFormValidator.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-21.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "EditProfileFormValidator.h"

@implementation EditProfileFormValidator

+ (id<FormValidator>)validator {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [EditProfileFormValidator new];
    });
    return instance;
}

- (BOOL)isFormValid:(NSDictionary *)form errors:(NSArray **)errors {
    NSString *firstName = form[@"firstName"];
    NSString *lastName = form[@"lastName"];
    NSMutableArray *localErrors = [NSMutableArray array];
    BOOL isValid = YES;
    
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

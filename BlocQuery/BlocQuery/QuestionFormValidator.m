//
//  QuestionFormValidator.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-15.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "QuestionFormValidator.h"

@implementation QuestionFormValidator

+ (id<FormValidator>)validator {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[QuestionFormValidator alloc] init];
    });
    return instance;
}

- (BOOL)isFormValid:(NSDictionary *)form errors:(NSArray *__autoreleasing *)errors {
    NSString *text = form[@"text"];
    NSMutableArray *localErrors = [NSMutableArray array];
    BOOL isValid = YES;
    
    if ([text length] < 20) {
        isValid = NO;
        [localErrors addObject:[self insufficientLengthError]];
    }
    
    if (!isValid)
        *errors = localErrors;
    
    return isValid;
}

- (NSError *) insufficientLengthError {
    return [NSError errorWithDomain:BQQuestionFormValidationErrorDomain
                               code:-1
                           userInfo:[NSError textInsufficientLengthUserInfo:20]];
}

@end

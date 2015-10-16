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
        [localErrors addObject:[NSError blocQueryErrorWithCode:BQError_InvalidText context:nil params:@{@"count": @20}]];
    }
    
    if (!isValid)
        *errors = localErrors;
    
    return isValid;
}

@end

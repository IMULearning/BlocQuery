//
//  NSError+BQError.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "NSError+BQError.h"

@implementation NSError (BQError)

+ (NSDictionary *) emailInvalidErrorUserInfo {
    return @{
             NSLocalizedDescriptionKey: NSLocalizedString(@"Email validation failed.", nil),
             NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Email does not pass regular expression test.", nil),
             NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please provide a valid email address.", nil)
             };
}

+ (NSDictionary *) passwordInvalidErrorUserInfo {
    return @{
             NSLocalizedDescriptionKey: NSLocalizedString(@"Password validation failed.", nil),
             NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Password does not pass regular expression test.", nil),
             NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please provide a password of 8 to 16 characters in length and contains at least one numeric character.", nil)
             };
}

+ (NSDictionary *) firstNameNullErrorUserInfo {
    return @{
             NSLocalizedDescriptionKey: NSLocalizedString(@"FirstName validation failed.", nil),
             NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"FirstName cannot be null.", nil),
             NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please tell us your first name.", nil)
             };
}

+ (NSDictionary *) lastNameNullErrorUserInfo {
    return @{
             NSLocalizedDescriptionKey: NSLocalizedString(@"LastName validation failed.", nil),
             NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"LastName cannot be null.", nil),
             NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please tell us your last name.", nil)
             };
}

+ (NSDictionary *) textInsufficientLengthUserInfo:(NSUInteger)expectedLength {
    NSString *recovery = [NSString stringWithFormat:@"Please provide a question of at least %ld characters.", expectedLength];
    return @{
             NSLocalizedDescriptionKey: NSLocalizedString(@"Text validation failed", nil),
             NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Insufficient length", nil),
             NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(recovery, nil)
             };
}

@end

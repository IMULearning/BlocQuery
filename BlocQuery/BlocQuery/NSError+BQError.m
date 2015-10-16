//
//  NSError+BQError.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "NSError+BQError.h"
#import "ErrorHandler.h"

@implementation NSError (BQError)

+ (NSDictionary *) defaultErrorUserInfo {
    return @{
             NSLocalizedDescriptionKey: NSLocalizedString(@"Something went wrong", nil),
             NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Something went wrong", nil),
             NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"We are so sorry! Something went wrong :(", nil)
             };
}

+ (NSError *)blocQueryErrorWithCode:(NSInteger)errorCode context:(NSString *)context params:(NSDictionary *)params {
    NSError *prototype = [NSError errorWithDomain:BQErrorDomain code:errorCode userInfo:@{}];
    return [self blocQueryErrorFromError:prototype withCode:errorCode context:context params:params];
}

+ (NSError *) blocQueryErrorFromError:(NSError *)error withCode:(NSInteger)errorCode context:(NSString *)context params:(NSDictionary *)params {
    NSDictionary *userInfo = [[ErrorHandler handler] resolveUserInfoForError:error inContext:context withParams:params];
    return [NSError errorWithDomain:BQErrorDomain code:errorCode userInfo:userInfo];
}

@end

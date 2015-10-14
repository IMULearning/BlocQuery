//
//  ParseErrorHandler.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "ParseErrorHandler.h"

@interface ParseErrorHandler ()

@property (nonatomic, strong) NSDictionary *mapping;

@end

@implementation ParseErrorHandler

+ (instancetype) handler {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[ParseErrorHandler alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *parseDict = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Parse"];
        _mapping = parseDict[@"ErrorMapping"];
    }
    return self;
}

- (NSDictionary *) handlesError:(NSError *)parseError inContext:(NSString *)context {
    NSDictionary *errorDict = self.mapping[[NSString stringWithFormat:@"%ld-%@", parseError.code, context ? context : @"*"]];
    if (errorDict) {
        return @{
                 NSLocalizedDescriptionKey: NSLocalizedString(errorDict[@"description"], nil),
                 NSLocalizedFailureReasonErrorKey: NSLocalizedString(errorDict[@"reason"], nil),
                 NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(errorDict[@"recovery"], nil)
                 };
    } else {
        return [self defaultErrorUserInfo];
    }
}

- (NSDictionary *) defaultErrorUserInfo {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"Something went wrong", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Something went wrong", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"We are so sorry! Something went wrong :(", nil)
                               };
    return userInfo;
}

@end

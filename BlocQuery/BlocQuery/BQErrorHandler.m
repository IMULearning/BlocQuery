//
//  BQErrorHandler.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-16.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "BQErrorHandler.h"
#import <GRMustache/GRMustache.h>

@interface BQErrorHandler ()

@property (nonatomic, strong) NSDictionary *mapping;

@end

@implementation BQErrorHandler

+ (instancetype)handler {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[BQErrorHandler alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Error" ofType:@"plist"];
        NSDictionary *errorDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
        _mapping = errorDictionary[BQErrorDomain];
    }
    return self;
}

- (BOOL)handlesDomain:(NSString *)errorDomain {
    return [errorDomain isEqualToString:BQErrorDomain];
}

- (NSDictionary *)resolveUserInfoForError:(NSError *)error inContext:(NSString *)context withParams:(NSDictionary *)params {
    NSDictionary *errorDict = self.mapping[[NSString stringWithFormat:@"%d:%@", error.code, context ? context : @"*"]];
    NSString *recovery = [GRMustacheTemplate renderObject:params fromString:NSLocalizedString(errorDict[@"recovery"], nil) error:nil];
    if (errorDict) {
        return @{
                 NSLocalizedDescriptionKey: NSLocalizedString(errorDict[@"description"], nil),
                 NSLocalizedFailureReasonErrorKey: NSLocalizedString(errorDict[@"reason"], nil),
                 NSLocalizedRecoverySuggestionErrorKey: recovery
                 };
    } else {
        return [NSError defaultErrorUserInfo];
    }
}

@end

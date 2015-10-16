//
//  ErrorHandler.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-16.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "ErrorHandler.h"
#import "BQErrorHandler.h"
#import "ParseErrorHandler.h"

@implementation ErrorHandler

+ (instancetype)handler {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[ErrorHandler alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _handlers = @[
                      [BQErrorHandler handler],
                      [ParseErrorHandler handler]
                      ];
    }
    return self;
}

- (BOOL)handlesDomain:(NSString *)errorDomain {
    return YES;
}

- (NSDictionary *)resolveUserInfoForError:(NSError *)error inContext:(NSString *)context withParams:(NSDictionary *)params {
    for (id <ErrorHandling> handler in self.handlers) {
        if ([handler handlesDomain:error.domain]) {
            return [handler resolveUserInfoForError:error inContext:context withParams:params];
        }
    }
    return [NSError defaultErrorUserInfo];
}

@end

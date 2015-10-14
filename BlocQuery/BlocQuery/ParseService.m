//
//  ParseService.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "ParseService.h"
#import "ParseErrorHandler.h"

@implementation ParseService

+ (instancetype) service {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [ParseService new];
    });
    return instance;
}

- (void) signupUserWithForm:(NSDictionary *)form
                      block:(void (^)(BOOL succeeded, NSError *error))callback {
    PFUser *user = [PFUser user];
    
    user.username = form[@"email"];
    user.password = form[@"password"];
    user.email = form[@"email"];
    user[@"firstName"] = form[@"firstName"];
    user[@"lastName"] = form[@"lastName"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (callback) {
            if (succeeded) {
                callback(succeeded, error);
            } else {
                NSDictionary *userInfo = [[ParseErrorHandler handler] handlesError:error inContext:nil];
                NSError *localizedError = [NSError errorWithDomain:BQParseRegisterErrorDomain
                                                              code:-1
                                                          userInfo:userInfo];
                callback(succeeded, localizedError);
            }
        }
    }];
}

- (void) loginUserWithForm:(NSDictionary *)form
                     block:(void (^)(PFUser *user, NSError *error))callback {
    [PFUser logInWithUsernameInBackground:form[@"email"]
                                 password:form[@"password"]
                                    block:^(PFUser * _Nullable user, NSError * _Nullable error){
                                        if (callback) {
                                            if (user) {
                                                callback(user, error);
                                            } else {
                                                NSDictionary *userInfo = [[ParseErrorHandler handler] handlesError:error inContext:@"login"];
                                                NSError *localizedError = [NSError errorWithDomain:BQParseLoginErrorDomain
                                                                                              code:-1
                                                                                          userInfo:userInfo];
                                                callback(user, localizedError);
                                            }
                                        }
    }];
}

@end

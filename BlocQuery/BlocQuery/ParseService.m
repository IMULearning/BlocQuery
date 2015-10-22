//
//  ParseService.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "ParseService.h"
#import "ErrorHandler.h"
#import "BQQuestion.h"
#import "BQAnswer.h"

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
                callback(succeeded, [NSError blocQueryErrorFromError:error withCode:BQError_SignupFailed context:nil params:nil]);
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
                                                callback(user, [NSError blocQueryErrorFromError:error withCode:BQError_LoginFailed context:@"login" params:nil]);
                                            }
                                        }
    }];
}

- (void) createQuestionWithForm:(NSDictionary *)form
                          block:(void (^)(BOOL succeeded, NSError *error))callback {
    BQQuestion *question = [BQQuestion objectWithClassName:NSStringFromClass([BQQuestion class])];
    question.author = [PFUser currentUser];
    question.text = form[@"text"];
    question.answers = [NSArray array];
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (callback) {
            if (succeeded) {
                callback(succeeded, error);
            } else {
                callback(succeeded, [NSError blocQueryErrorFromError:error withCode:BQError_CreateQuestionFailed context:nil params:nil]);
            }
        }
    }];
}

- (void) createAnswer:(NSDictionary *)answerForm toQuestion:(BQQuestion *)question block:(void (^)(BOOL succeeded, NSError *error))callback {
    BQAnswer *answer = [BQAnswer objectWithClassName:NSStringFromClass([BQAnswer class])];
    answer.author = [PFUser currentUser];
    answer.text = answerForm[@"text"];
    answer.upVoters = [NSArray array];
    question.answers = [question.answers arrayByAddingObject:answer];
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (callback) {
            if (succeeded) {
                callback(succeeded, error);
            } else {
                callback(succeeded, [NSError blocQueryErrorFromError:error withCode:BQError_CreateAnswerFailed context:nil params:nil]);
            }
        }
    }];
}

- (void) updateUser:(PFUser *)user withForm:(NSDictionary *)form block:(void (^)(BOOL succeeded, NSError *error))callback {
    if (form[@"firstName"])
        user[@"firstName"] = form[@"firstName"];
    if (form[@"lastName"])
        user[@"lastName"] = form[@"lastName"];
    if (form[@"bio"])
        user[@"bio"] = form[@"bio"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (callback) {
            if (succeeded) {
                callback(succeeded, error);
                [[NSNotificationCenter defaultCenter] postNotificationName:BQUserUpdatedNotification object:nil userInfo:@{@"user": user}];
            } else {
                callback(succeeded, [NSError blocQueryErrorFromError:error withCode:BQError_UpdateUserFailed context:nil params:nil]);
            }
        }
    }];
}

- (void) updateUser:(PFUser *)user avatar:(NSData *)data block:(void (^)(BOOL succeeded, NSError *error))callback {
    user[@"photo"] = (data == nil) ? nil : [PFFile fileWithData:data];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (callback) {
            if (succeeded) {
                callback(succeeded, error);
                [[NSNotificationCenter defaultCenter] postNotificationName:BQUserAvatarUpdatedNotification object:nil userInfo:@{@"user": user}];
            } else {
                callback(succeeded, [NSError blocQueryErrorFromError:error withCode:BQError_UpdateAvatarFailed context:nil params:nil]);
            }
        }
    }];
}

@end

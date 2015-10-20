//
//  ParseService.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQQuestion.h"

@interface ParseService : NSObject

+ (instancetype) service;

- (void) signupUserWithForm:(NSDictionary *)form
                      block:(void (^)(BOOL succeeded, NSError *error))callback;

- (void) loginUserWithForm:(NSDictionary *)form
                     block:(void (^)(PFUser *user, NSError *error))callback;

- (void) createQuestionWithForm:(NSDictionary *)form
                          block:(void (^)(BOOL succeeded, NSError *error))callback;

- (void) createAnswer:(NSDictionary *)answerForm toQuestion:(BQQuestion *)question block:(void (^)(BOOL succeeded, NSError *error))callback;

@end

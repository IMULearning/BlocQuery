//
//  NSError+BQError.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (BQError)

+ (NSDictionary *) defaultErrorUserInfo;

+ (NSError *) blocQueryErrorWithCode:(NSInteger)errorCode
                             context:(NSString *)context
                              params:(NSDictionary *)params;

+ (NSError *) blocQueryErrorFromError:(NSError *)error
                             withCode:(NSInteger)errorCode
                              context:(NSString *)context
                               params:(NSDictionary *)params;

@end

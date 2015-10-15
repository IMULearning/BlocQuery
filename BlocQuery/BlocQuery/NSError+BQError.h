//
//  NSError+BQError.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (BQError)

+ (NSDictionary *) emailInvalidErrorUserInfo;

+ (NSDictionary *) passwordInvalidErrorUserInfo;

+ (NSDictionary *) firstNameNullErrorUserInfo;

+ (NSDictionary *) lastNameNullErrorUserInfo;

+ (NSDictionary *) textInsufficientLengthUserInfo:(NSUInteger)expectedLength;

@end

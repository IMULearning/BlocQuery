//
//  ParseErrorHandler.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseErrorHandler : NSObject

+ (instancetype) handler;

- (NSDictionary *) handlesError:(NSError *)parseError inContext:(NSString *)context;

@end

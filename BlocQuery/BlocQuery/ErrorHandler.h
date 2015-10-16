//
//  ErrorHandler.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-16.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorHandling.h"

@interface ErrorHandler : NSObject <ErrorHandling>

@property (nonatomic, strong, readonly) NSArray *handlers;

@end

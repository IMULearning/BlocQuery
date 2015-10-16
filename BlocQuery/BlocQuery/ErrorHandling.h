//
//  ErrorHandling.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-16.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ErrorHandling <NSObject>

+ (instancetype) handler;

- (NSDictionary *) resolveUserInfoForError:(NSError *)error inContext:(NSString *)context withParams:(NSDictionary *)params;

- (BOOL) handlesDomain:(NSString *)errorDomain;

@end

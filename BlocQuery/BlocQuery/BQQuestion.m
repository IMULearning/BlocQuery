//
//  BQQuestion.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-14.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "BQQuestion.h"
#import <Parse/PFObject+Subclass.h>

@implementation BQQuestion

@dynamic author;
@dynamic text;
@dynamic answers;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([BQQuestion class]);
}

@end

//
//  BQAnswer.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-14.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "BQAnswer.h"
#import <Parse/PFObject+Subclass.h>

@implementation BQAnswer

@dynamic question;
@dynamic author;
@dynamic text;
@dynamic upVoters;
@dynamic upvoteCount;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"BQAnswer";
}

@end

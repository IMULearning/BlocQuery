//
//  BQAnswer.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-14.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <Parse/Parse.h>

@interface BQAnswer : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray<PFUser *> *upVoters;

@end

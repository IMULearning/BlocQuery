//
//  BQAnswer.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-14.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <Parse/Parse.h>

@class BQQuestion;

@interface BQAnswer : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) BQQuestion *question;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray<PFUser *> *upVoters;
@property (nonatomic, assign) NSInteger upvoteCount;

@end

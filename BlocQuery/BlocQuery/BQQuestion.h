//
//  BQQuestion.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-14.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <Parse/Parse.h>
#import "BQAnswer.h"

@interface BQQuestion : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray<BQAnswer *> *answers;

@end

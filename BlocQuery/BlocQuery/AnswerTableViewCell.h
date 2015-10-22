//
//  AnswerTableViewCell.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-20.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQAnswer.h"
#import <ParseUI.h>

@class AnswerTableViewCell;

@protocol AnswerTableViewCellUpvoteProtocal <NSObject>

- (void)cell:(AnswerTableViewCell *)cell didFinishUpvote:(BOOL)vote withAnswer:(BQAnswer *)answer;

@end

@interface AnswerTableViewCell : PFTableViewCell

@property (nonatomic, strong) BQAnswer *answer;
@property (nonatomic, weak) id <AnswerTableViewCellUpvoteProtocal> upvoteDelegate;

@end

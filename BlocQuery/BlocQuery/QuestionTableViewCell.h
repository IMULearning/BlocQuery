//
//  QuestionTableViewCell.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-15.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFTableViewCell.h>
#import "BQQuestion.h"

@interface QuestionTableViewCell : PFTableViewCell

@property (nonatomic, strong) BQQuestion *question;

@end

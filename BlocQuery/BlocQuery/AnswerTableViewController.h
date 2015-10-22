//
//  AnswerTableViewController.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-22.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import "BQQuestion.h"

@interface AnswerTableViewController : PFQueryTableViewController

@property (nonatomic, strong) BQQuestion *question;

@end

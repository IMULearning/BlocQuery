//
//  AnswerTableViewController.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-22.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "AnswerTableViewController.h"
#import "AnswerTableViewCell.h"

@interface AnswerTableViewController () <AnswerTableViewCellUpvoteProtocal>

@end

@implementation AnswerTableViewController

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.loadingViewEnabled = YES;
        self.paginationEnabled = NO;
        self.pullToRefreshEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert(self.question != nil, @"Question must be set.");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSuccessfullyCreateAnswer:)
                                                 name:BQQuestionNewAnswerNotification object:nil];
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - Table

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([BQAnswer class])];
    [query whereKey:@"question" equalTo:self.question];
    [query orderByDescending:@"upvoteCount"];
    return query;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"answerCell" forIndexPath:indexPath];
    cell.answer = (BQAnswer *) object;
    cell.upvoteDelegate = self;
    return cell;
}

#pragma mark -
#pragma mark - AnswerTableViewCellUpvoteProtocal

- (void)cell:(AnswerTableViewCell *)cell didFinishUpvote:(BOOL)vote withAnswer:(BQAnswer *)answer {
    NSIndexPath *currentIndexPath = [self.tableView indexPathForCell:cell];
    NSInteger cursorRow = currentIndexPath.row;
    
    if (vote) {
        while (cursorRow > 0) {
            BQAnswer *cursorAnswer = (BQAnswer *)[self objectAtIndexPath:[NSIndexPath indexPathForRow:cursorRow - 1 inSection:0]];
            if (cursorAnswer.upvoteCount > answer.upvoteCount)
                break;
            cursorRow--;
        }
    } else {
        while (cursorRow < self.question.answers.count - 1) {
            BQAnswer *cursorAnswer = (BQAnswer *)[self objectAtIndexPath:[NSIndexPath indexPathForRow:cursorRow + 1 inSection:0]];
            if (cursorAnswer.upvoteCount < answer.upvoteCount)
                break;
            cursorRow++;
        }
    }
    
    NSMutableArray *_shadowObjects = [[super objects] mutableCopy];
    BQAnswer *answerToSwap = [_shadowObjects objectAtIndex:currentIndexPath.row];
    [_shadowObjects removeObject:answerToSwap];
    [_shadowObjects insertObject:answerToSwap atIndex:cursorRow];
    [self setValue:_shadowObjects forKey:@"_mutableObjects"];
    
    NSIndexPath *newIndexpath = [NSIndexPath indexPathForRow:cursorRow inSection:0];

    [self.tableView moveRowAtIndexPath:currentIndexPath toIndexPath:newIndexpath];
    [self.tableView scrollToRowAtIndexPath:newIndexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark -
#pragma mark - Notification

- (void)didSuccessfullyCreateAnswer:(NSNotification *)notification {
    if ((BQQuestion *)notification.userInfo[@"question"] == self.question) {
        [self loadObjects];
    }
}

@end

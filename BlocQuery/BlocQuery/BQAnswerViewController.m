//
//  BQAnswerViewController.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-20.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "BQAnswerViewController.h"
#import "AnswerTableViewCell.h"
#import "ComposeAnswerViewController.h"
#import "ProfileViewController.h"
#import <FAKFontAwesome.h>
#import <MBProgressHUD.h>
#import "AnswerTableViewController.h"

@interface BQAnswerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerCountLabel;

@property (weak, nonatomic) IBOutlet UIView *answerTableView;
@property (nonatomic, strong) AnswerTableViewController *answerTableVC;

@end

@implementation BQAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSAssert(self.question != nil, @"Question must be set.");
    
    [self setupUI];
    [self setupTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSuccessfullyCreateAnswer:) name:BQQuestionNewAnswerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentProfile:) name:BQPresentUserProfileNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void) setupUI {
    [self setupExitButton];
    self.questionLabel.text = self.question.text;
    self.answerCountLabel.text = [self answerCountLabelText];
}

- (void) setupExitButton {
    FAKFontAwesome *font = [FAKFontAwesome removeIconWithSize:20];
    [font addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
    [self.exitButton setAttributedTitle:[font attributedString] forState:UIControlStateNormal];
}

#pragma mark - Table view

- (void) setupTableView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Answer" bundle:nil];
    self.answerTableVC = [storyboard instantiateViewControllerWithIdentifier:@"AnswerTableViewController"];
    self.answerTableVC.question = self.question;
    [self addChildViewController:self.answerTableVC];
    [self.answerTableView addSubview:self.answerTableVC.view];
    self.answerTableVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.answerTableView.frame), CGRectGetHeight(self.answerTableView.frame));
    [self.answerTableVC didMoveToParentViewController:self];
}

#pragma mark - AnswerTableViewCellUpvoteProtocal

//- (void)cell:(AnswerTableViewCell *)cell didFinishUpvote:(BOOL)vote withAnswer:(BQAnswer *)answer {
//    NSIndexPath *currentIndexPath = [self.answersTableView indexPathForCell:cell];
//    NSInteger cursorRow = currentIndexPath.row;
//    
//    if (vote) {
//        
//        while (cursorRow > 0) {
//            if ([[self.question fetchIfNeeded].answers[cursorRow - 1] fetchIfNeeded].upVoters.count > answer.upVoters.count)
//                break;
//            cursorRow--;
//        }
//    } else {
//        while (cursorRow < self.question.answers.count - 1) {
//            if ([[self.question fetchIfNeeded].answers[cursorRow + 1] fetchIfNeeded].upVoters.count <= answer.upVoters.count)
//                break;
//            cursorRow++;
//        }
//    }
//    
////    NSMutableArray *answerArray = [self.objects mutableCopy];
////    BQAnswer *answerToSwap = [answerArray objectAtIndex:currentIndexPath.row];
////    [answerArray removeObject:answerToSwap];
////    [answerArray insertObject:answerToSwap atIndex:cursorRow];
////    self.objects = answerArray;
////    
////    [self.answersTableView moveRowAtIndexPath:currentIndexPath toIndexPath:[NSIndexPath indexPathForRow:cursorRow inSection:0]];
//}

#pragma mark - Button targets

- (IBAction)exitButtonFired:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)answerButtonFired:(id)sender {
}

#pragma mark - Misc

- (NSString *) authorShortName {
    PFUser *author = [self.question.author fetchIfNeeded];
    NSString *initial = [(NSString *)author[@"lastName"] substringToIndex:1];
    NSString *asks = NSLocalizedString(@"asks...", nil);
    return [NSString stringWithFormat:@"%@ %@ %@", author[@"firstName"], initial, asks];
}

- (NSString *) answerCountLabelText {
    if (self.question.answers.count == 0) {
        return NSLocalizedString(@"No answer yet", nil);
    } else if (self.question.answers.count == 1) {
        return NSLocalizedString(@"1 answer", nil);
    } else {
        return [[NSString stringWithFormat:@"%ld ", self.question.answers.count] stringByAppendingString:NSLocalizedString(@"answer", nil)];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"composeAnswer"]) {
        UINavigationController *navVC = [segue destinationViewController];
        ComposeAnswerViewController *composeVC = (ComposeAnswerViewController *)navVC.viewControllers[0];
        composeVC.question = self.question;
    }
}

- (void) presentProfile:(NSNotification *)notification {
    PFUser *user = notification.userInfo[@"user"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    UINavigationController *navVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    ProfileViewController *profileVC = navVC.viewControllers[0];
    profileVC.user = user;
    
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - ComposeAnswerViewController Notification

- (void)didSuccessfullyCreateAnswer:(NSNotification *)notification {
    if ((BQQuestion *)notification.userInfo[@"question"] == self.question) {
        [self displayCreatedHud];
        self.answerCountLabel.text = [self answerCountLabelText];
    }
}

- (void) displayCreatedHud {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelFont = [UIFont defaultAppFontWithSize:30];
    hud.labelText = NSLocalizedString(@"Created", nil);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

@end

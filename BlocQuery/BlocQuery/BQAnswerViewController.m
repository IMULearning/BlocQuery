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
#import <FAKFontAwesome.h>
#import <MBProgressHUD.h>

@interface BQAnswerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *answersTableView;

@end

@implementation BQAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSAssert(self.question != nil, @"Question must be set.");
    
    [self setupUI];
    [self setupTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSuccessfullyCreateAnswer:) name:BQQuestionNewAnswerNotification object:nil];
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
    self.answersTableView.delegate = self;
    self.answersTableView.dataSource = self;
    self.answersTableView.estimatedRowHeight = 100.0;
    self.answersTableView.rowHeight = UITableViewAutomaticDimension;
    self.answersTableView.tableFooterView = [UIView new];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"answerCell" forIndexPath:indexPath];
    cell.answer = self.question.answers[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.question.answers.count;
}

#pragma mark - Button targets

- (IBAction)exitButtonFired:(id)sender {
    [self dismissViewControllerAnimated:self completion:nil];
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

#pragma mark - ComposeAnswerViewController Notification

- (void)didSuccessfullyCreateAnswer:(NSNotification *)notification {
    if ((BQQuestion *)notification.userInfo[@"question"] == self.question) {
        [self displayCreatedHud];
        [self.answersTableView reloadData];
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

//
//  BQQuestionViewController.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-15.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "BQQuestionViewController.h"
#import "BQQuestion.h"
#import "QuestionTableViewCell.h"
#import "BQAnswerViewController.h"
#import "ProfileViewController.h"
#import <FontAwesomeKit/FAKFontAwesome.h>

@interface BQQuestionViewController ()

@end

@implementation BQQuestionViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parseClassName = NSStringFromClass([BQQuestion class]);
        self.loadingViewEnabled = YES;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 10;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newQuestionCreated:) name:BQQuestionCreatedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentProfile:) name:BQPresentUserProfileNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    self.navigationController.tabBarItem.title = NSLocalizedString(@"Home", nil);
    self.navigationController.tabBarItem.image = [[FAKFontAwesome homeIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self blocQueryTitleView]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self askQuestionIconButton]];
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)newQuestionCreated:(NSNotification *)notification {
    [self loadObjects];
}

#pragma mark - UI

- (UIView *) blocQueryTitleView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:view.frame];
    titleLabel.text = NSLocalizedString(@"BlocQuery", nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 1;
    [view addSubview:titleLabel];
    return view;
}

- (UIButton *) askQuestionIconButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    FAKFontAwesome *icon = [FAKFontAwesome commentOIconWithSize:25];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [button setAttributedTitle:[icon attributedString] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(askQuestionButtonFired:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Button target

- (void) askQuestionButtonFired:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Question" bundle:nil];
    UIViewController *queryVC = [storyboard instantiateViewControllerWithIdentifier:@"AskViewController"];
    [queryVC setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:queryVC animated:YES completion:nil];
}


#pragma mark - Table view datasource

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    cell.question = (BQQuestion *) object;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAnswer"]) {
        BQQuestion *question = (BQQuestion *)[self objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        if (question) {
            BQAnswerViewController *answerVC = [segue destinationViewController];
            answerVC.question = question;
        }
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

@end

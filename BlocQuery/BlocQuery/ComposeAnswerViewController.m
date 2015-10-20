//
//  ComposeAnswerViewController.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-20.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "ComposeAnswerViewController.h"
#import "AnswerFormValidator.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ComposeAnswerViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *answerTextView;

@end

@implementation ComposeAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

- (MBProgressHUD *) progressHud {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelFont = [UIFont defaultAppFontWithSize:30];
    hud.labelText = NSLocalizedString(@"Answering...", nil);
    return hud;
}

- (UIAlertController *) alertControllerWithErrors:(NSArray *)errors {
    NSAssert(errors.count > 0, @"Alert view can only be presented while there's a positive count of errors");
    NSArray *errorMessages = Underscore.arrayMap(errors, ^NSString* (id each){
        if (errors.count > 1) {
            return [NSString stringWithFormat:@"\u2022 %@", [((NSError *)each) userInfo][NSLocalizedRecoverySuggestionErrorKey]];
        } else {
            return [((NSError *)each) userInfo][NSLocalizedRecoverySuggestionErrorKey];
        }
    });
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                                                     message:[errorMessages componentsJoinedByString:@"\n"]
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [alertVC dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    [alertVC addAction:okAction];
    
    return alertVC;
}


#pragma mark - Button targets

- (IBAction)cancelButtonFired:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)answerButtonFired:(id)sender {
    [self.answerTextView resignFirstResponder];
    
    NSDictionary *answerForm = @{@"text": self.answerTextView.text};
    NSArray *errors = nil;
    if ([[AnswerFormValidator validator] isFormValid:answerForm errors:&errors]) {
        MBProgressHUD *hud = [self progressHud];
        [hud showAnimated:YES whileExecutingBlock:^{
            [[ParseService service] createAnswer:answerForm toQuestion:self.question block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:BQQuestionNewAnswerNotification object:nil userInfo:@{@"question": self.question}];
                    
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                } else {
                    UIAlertController *errorAlertVC = [self alertControllerWithErrors:@[error]];
                    [self presentViewController:errorAlertVC animated:YES completion:nil];
                }
            }];
        }];
    } else {
        UIAlertController *errorAlertVC = [self alertControllerWithErrors:errors];
        [self presentViewController:errorAlertVC animated:YES completion:nil];
    }
}

#pragma mark - Keyboard

- (void) keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [[[notification userInfo] objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIEdgeInsets insets = self.answerTextView.contentInset;
    insets.bottom = keyboardFrame.size.height - self.topLayoutGuide.length;
    [self.answerTextView setContentInset: insets];
    [self.answerTextView setScrollIndicatorInsets: insets];
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets insets = self.answerTextView.contentInset;
    insets.bottom = 0;
    [self.answerTextView setContentInset: insets];
    [self.answerTextView setScrollIndicatorInsets: insets];
}

@end

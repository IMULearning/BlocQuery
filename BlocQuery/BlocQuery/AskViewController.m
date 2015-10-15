//
//  AskViewController.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-15.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "AskViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "QuestionFormValidator.h"

@interface AskViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postBarButton;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;

@end

@implementation AskViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        self.questionTextView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self titleLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.questionTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UI

- (UILabel *) titleLabel {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    title.text = NSLocalizedString(@"Query", nil);
    title.font = [UIFont defaultAppBoldFontWithSize:20];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 1;
    return title;
}

- (MBProgressHUD *) progressHud {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelFont = [UIFont defaultAppFontWithSize:30];
    hud.labelText = NSLocalizedString(@"Submitting...", nil);
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

#pragma mark - Keyboard

- (void) keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [[[notification userInfo] objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIEdgeInsets insets = self.questionTextView.contentInset;
    insets.bottom = keyboardFrame.size.height;
    [self.questionTextView setContentInset: insets];
    [self.questionTextView setScrollIndicatorInsets: insets];
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets insets = self.questionTextView.contentInset;
    insets.bottom = 0;
    [self.questionTextView setContentInset: insets];
    [self.questionTextView setScrollIndicatorInsets: insets];
}

#pragma mark - Button targets

- (IBAction)cancelButtonFired:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postButtonFired:(id)sender {
    [self.questionTextView resignFirstResponder];
    
    NSDictionary *questionForm = @{@"text": self.questionTextView.text};
    NSArray *errors = nil;
    if ([[QuestionFormValidator validator] isFormValid:questionForm errors:&errors]) {
        MBProgressHUD *hud = [self progressHud];
        [hud showAnimated:YES whileExecutingBlock:^{
            [[ParseService service] createQuestionWithForm:questionForm block:^(BOOL succeeded, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    if (succeeded) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:BQQuestionCreatedNotification object:nil];
                        }];
                    } else {
                        UIAlertController *errorAlertVC = [self alertControllerWithErrors:@[error]];
                        [self presentViewController:errorAlertVC animated:YES completion:nil];
                    }
                });
            }];
        }];
    } else {
        UIAlertController *errorAlertVC = [self alertControllerWithErrors:errors];
        [self presentViewController:errorAlertVC animated:YES completion:nil];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  LoginFormController.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "LoginFormController.h"
#import "LoginFormValidator.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LoginFormController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginFormController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.emailTextField becomeFirstResponder];
}

#pragma mark - Button targets

- (IBAction)cancelBarButtonFired:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneBarButtonFired:(id)sender {
    NSDictionary *loginForm = @{
                                @"email": self.emailTextField.text,
                                @"password": self.passwordTextField.text
                                };
    NSArray *errors = nil;
    if ([[LoginFormValidator validator] isFormValid:loginForm errors:&errors]) {
        MBProgressHUD *hud = [self progressHud];
        [hud showAnimated:YES whileExecutingBlock:^{
            [[ParseService service] loginUserWithForm:loginForm
                                                block:^(PFUser *user, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    if (user) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:BQUserLoggedInNotification object:nil];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UI

- (MBProgressHUD *) progressHud {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelFont = [UIFont defaultAppFontWithSize:30];
    hud.labelText = NSLocalizedString(@"Logging in...", nil);
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

@end

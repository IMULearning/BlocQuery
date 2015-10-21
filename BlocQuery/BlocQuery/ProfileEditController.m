//
//  ProfileEditController.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-21.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "ProfileEditController.h"
#import "UIImage+Gravatar.h"
#import "EditProfileFormValidator.h"
#import "EditBioController.h"
#import <FAKFontAwesome.h>
#import <MBProgressHUD.h>

@interface ProfileEditController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

@end

@implementation ProfileEditController

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userUpdated:) name:BQUserUpdatedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAssert(self.user != nil, @"User must be set.");
    
    [self customizeBackButton];
    [self updateAvatarImage];
    [self updateNamesInput];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

- (void) updateNamesInput {
    self.firstNameTextField.text = self.user[@"firstName"];
    self.lastNameTextField.text = self.user[@"lastName"];
}

- (void) customizeBackButton {
    FAKFontAwesome *back = [FAKFontAwesome chevronLeftIconWithSize:25];
    [back addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[back imageWithSize:CGSizeMake(50, 50)]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonFired:)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -16;
    self.navigationItem.leftBarButtonItems = @[spacer, backButton];
}

- (void) updateAvatarImage {
    UIImage *fallback = [[FAKFontAwesome userIconWithSize:42] imageWithSize:CGSizeMake(42, 42)];
    self.avatarImageView.image = [UIImage imageWithGravatarEmail:self.user.email size:42 fallbackImage:fallback];
}

- (MBProgressHUD *) progressHud {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelFont = [UIFont defaultAppFontWithSize:30];
    hud.labelText = NSLocalizedString(@"Saving...", nil);
    return hud;
}

- (MBProgressHUD *) savedHud {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelFont = [UIFont defaultAppFontWithSize:30];
    hud.labelText = NSLocalizedString(@"Saved", nil);
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

- (void)backButtonFired:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editPhotoFired:(id)sender {
}

- (IBAction)editBioFired:(id)sender {
    
}

- (IBAction)saveFired:(id)sender {
    NSDictionary *form = @{
                           @"firstName": self.firstNameTextField.text,
                           @"lastName": self.lastNameTextField.text
                           };
    NSArray *errors = nil;
    
    if ([[EditProfileFormValidator validator] isFormValid:form errors:&errors]) {
        MBProgressHUD *hud = [self progressHud];
        [hud showAnimated:YES whileExecutingBlock:^{
            [[ParseService service] updateUser:self.user withForm:form block:^(BOOL succeeded, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    if (!succeeded) {
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

#pragma mark - Notification

- (void)userUpdated: (NSNotification *)notification {
    PFUser *updatedUser = notification.userInfo[@"user"];
    if ([updatedUser.email isEqualToString:self.user.email]) {
        [self.user fetch];
        [self updateAvatarImage];
        [self updateNamesInput];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editBio"]) {
        UINavigationController *navVC = segue.destinationViewController;
        EditBioController *editBioVC = navVC.viewControllers[0];
        editBioVC.user = self.user;
    }
}

@end

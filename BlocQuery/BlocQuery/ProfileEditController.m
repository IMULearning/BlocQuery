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
#import "NSString+Hash.h"
#import <ParseUI.h>

@interface ProfileEditController ()

@property (weak, nonatomic) IBOutlet PFImageView *avatarImageView;
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
    self.avatarImageView.file = self.user[@"photo"];
    [self.avatarImageView loadInBackground];
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
    [self presentAvatarSelectionMenu];
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

#pragma mark - Avatar selection

- (void) presentAvatarSelectionMenu {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:NSLocalizedString(@"Choose from the following options", nil)
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [alertController dismissViewControllerAnimated:YES completion:nil];
                                                         }];
    [alertController addAction:cancelAction];
    
    // Take a photo action
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhotoIsSelected];
        }];
        [alertController addAction:takePhotoAction];
    }
    
    // Choose from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Choose from Library", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self chooseFromLibraryIsSelected];
        }];
        [alertController addAction:photoLibraryAction];
    }
    
    // Choose Stock
    UIAlertAction *stockAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Choose from Stock", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseFromStockIsSelected];
    }];
    [alertController addAction:stockAction];
    
    // Use gravatar photo
    UIAlertAction *gravatarAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Use Gravatar", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MBProgressHUD *hud = [self progressHud];
        [hud showAnimated:YES whileExecutingBlock:^{
            [self useGravatarIsSelected];
        }];
    }];
    [alertController addAction:gravatarAction];
    
    // Remove
    if (!self.user[@"photo"]) {
        UIAlertAction *removeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Remove Photo", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self removePhotoIsSelected];
        }];
        [alertController addAction:removeAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) takePhotoIsSelected {
    
}

- (void) chooseFromLibraryIsSelected {
    
}

- (void) chooseFromStockIsSelected {
    
}

- (void) useGravatarIsSelected {
    NSString *gravatarUrl = [NSString stringWithFormat:@"https://s.gravatar.com/avatar/%@?s=%uld&d=404", [self.user.email MD5], 80];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:gravatarUrl]];
    if (!imageData) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSError *error = [NSError blocQueryErrorWithCode:BQError_NoGravatar context:nil params:nil];
        UIAlertController *alertController = [self alertControllerWithErrors:@[error]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [[ParseService service] updateUser:self.user avatar:imageData block:^(BOOL succeeded, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (!succeeded) {
                UIAlertController *alertController = [self alertControllerWithErrors:@[error]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }
}

- (void) removePhotoIsSelected {
    
}

@end

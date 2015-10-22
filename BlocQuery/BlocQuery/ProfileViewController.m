//
//  ProfileViewController.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-21.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImage+Gravatar.h"
#import "ProfileEditController.h"
#import <ParseUI/ParseUI.h>
#import <FAKFontAwesome.h>
#import "PFImageView+Addition.h"

@interface ProfileViewController ()

@property (nonatomic, strong) UIBarButtonItem *exitButton;
@property (nonatomic, strong) UILabel *firstNameTitleLabel;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalBioLabel;
@property (weak, nonatomic) IBOutlet PFImageView *avatarImage;

@end

@implementation ProfileViewController

- (void)awakeFromNib {
    self.navigationController.tabBarItem.title = NSLocalizedString(@"Profile", nil);
    self.navigationController.tabBarItem.image = [[FAKFontAwesome userIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userUpdated:) name:BQUserUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAvatarUpdated:) name:BQUserAvatarUpdatedNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.height / 2;
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.borderWidth = 0;
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void) updateUI {
    [self updateFirstnameTitleLabel];
    [self updateEditButton];
    [self updateAvartarImage];
    [self updateNameLabel];
    [self updateBioLabel];
    if (self.navigationController.tabBarController == nil) {
        [self updateExitButton];
    }
}

- (void) updateExitButton {
    if (!self.exitButton) {
        FAKFontAwesome *exit = [FAKFontAwesome removeIconWithSize:25];
        [exit addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [button setAttributedTitle:[exit attributedString] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(exitButtonFired:) forControlEvents:UIControlEventTouchUpInside];
        self.exitButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -16;
    self.navigationItem.leftBarButtonItems = @[spacer, self.exitButton];
}

- (void) updateFirstnameTitleLabel {
    if (!self.firstNameTitleLabel) {
        self.firstNameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        self.firstNameTitleLabel.textColor = [UIColor whiteColor];
        self.firstNameTitleLabel.font = [UIFont defaultAppBoldFontWithSize:20];
        self.firstNameTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.firstNameTitleLabel.numberOfLines = 1;
    }
    self.firstNameTitleLabel.text = self.user[@"firstName"];
    self.navigationItem.titleView = self.firstNameTitleLabel;
}

- (void) updateEditButton {
    if ([self.user.email isEqualToString:[PFUser currentUser].email]) {
        if (!self.editButton) {
            FAKFontAwesome *pencil = [FAKFontAwesome pencilSquareOIconWithSize:25];
            [pencil addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [button setAttributedTitle:[pencil attributedString] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(editButtonFired:) forControlEvents:UIControlEventTouchUpInside];
            self.editButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spacer.width = -16;
        self.navigationItem.rightBarButtonItems = @[spacer, self.editButton];
    } else {
        self.navigationItem.rightBarButtonItems = @[];
    }
}

- (void) updateAvartarImage {
    id photo = self.user[@"photo"];
    if ([photo isKindOfClass:[PFFile class]]) {
        self.avatarImage.file = photo;
    } else {
        [self.avatarImage clearFile];
    }

    [self.avatarImage loadInBackground];
}

- (void) updateNameLabel {
    NSString *name = [NSString stringWithFormat:@"%@ %@", self.user[@"firstName"], self.user[@"lastName"]];
    self.nameLabel.text = name;
}

- (void) updateBioLabel {
    if ([self.user[@"bio"] length] > 0) {
        self.personalBioLabel.text = self.user[@"bio"];
    } else {
        self.personalBioLabel.text = NSLocalizedString(@"This user has not written any personal bio yet.", nil);
    }
}

#pragma mark - Button targets

- (void) editButtonFired:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    ProfileEditController *editVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileEditController"];
    editVC.user = self.user;
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void) exitButtonFired:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - User

- (PFUser *)user {
    return _user != nil ? _user : [PFUser currentUser];
}

#pragma mark - Notification

- (void) userUpdated:(NSNotification *)notification {
    PFUser *user = notification.userInfo[@"user"];
    if ([user.email isEqualToString:self.user.email]) {
        [self.user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            [self updateUI];
        }];
    }
}

- (void) userAvatarUpdated:(NSNotification *)notification {
    PFUser *user = notification.userInfo[@"user"];
    if ([user.email isEqualToString:self.user.email]) {
        [self.user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            [self updateAvartarImage];
        }];
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

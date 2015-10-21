//
//  ProfileViewController.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-21.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImage+Gravatar.h"
#import <FAKFontAwesome.h>

@interface ProfileViewController ()

@property (nonatomic, strong) UIBarButtonItem *exitButton;
@property (nonatomic, strong) UILabel *firstNameTitleLabel;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalBioLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@end

@implementation ProfileViewController

- (void)awakeFromNib {
    self.navigationController.tabBarItem.title = NSLocalizedString(@"Profile", nil);
    self.navigationController.tabBarItem.image = [[FAKFontAwesome userIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
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
    NSString *email = self.user.email;
    UIImage *fallback = [[FAKFontAwesome userIconWithSize:60] imageWithSize:CGSizeMake(80, 80)];
    self.avatarImage.image = [UIImage imageWithGravatarEmail:email size:80 fallbackImage:fallback];
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
    
}

- (void) exitButtonFired:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - User

- (PFUser *)user {
    return _user != nil ? _user : [PFUser currentUser];
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

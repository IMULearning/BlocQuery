//
//  EditBioController.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-21.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "EditBioController.h"

@interface EditBioController ()

@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@end

@implementation EditBioController

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert(self.user != nil, @"User must be set.");
    self.bioTextView.text = self.user[@"bio"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.bioTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Button targets

- (IBAction)cancelButtonFired:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonFired:(id)sender {
    [self.bioTextView resignFirstResponder];
    
    NSDictionary *form = @{@"bio": self.bioTextView.text};
    [[ParseService service] updateUser:self.user withForm:form block:^(BOOL succeeded, NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - Keyboard

- (void) keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [[[notification userInfo] objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIEdgeInsets insets = self.bioTextView.contentInset;
    insets.bottom = keyboardFrame.size.height - self.topLayoutGuide.length;
    [self.bioTextView setContentInset: insets];
    [self.bioTextView setScrollIndicatorInsets: insets];
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets insets = self.bioTextView.contentInset;
    insets.bottom = 0;
    [self.bioTextView setContentInset: insets];
    [self.bioTextView setScrollIndicatorInsets: insets];
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

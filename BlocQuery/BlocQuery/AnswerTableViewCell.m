//
//  AnswerTableViewCell.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-20.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "AnswerTableViewCell.h"
#import "UIImage+Gravatar.h"
#import <FAKFontAwesome.h>
#import "ProfileViewController.h"
#import <ParseUI.h>
#import "PFImageView+Addition.h"
#import "UIColor+BQColor.h"

@interface AnswerTableViewCell () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet PFImageView *authorImage;
@property (weak, nonatomic) IBOutlet UILabel *upvoteCountLabel;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (assign) BOOL upvoted;

@end

@implementation AnswerTableViewCell

- (void)awakeFromNib {
    [self makeCircleAuthorImageView];
    
    self.authorImage.userInteractionEnabled = YES;
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAvartar)];
    self.tapGesture.numberOfTapsRequired = 1;
    [self.authorImage addGestureRecognizer:self.tapGesture];
    self.tapGesture.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void) updateUI {
    self.answerLabel.text = _answer.text;
    [self updateAuthorAvatar];
    [self updateUpvoteCountLabel];
    [self updateVoteButtonToVoted:self.upvoted];
}

- (void) makeCircleAuthorImageView {
    self.authorImage.layer.cornerRadius = self.authorImage.frame.size.height / 2;
    self.authorImage.layer.masksToBounds = YES;
    self.authorImage.layer.borderWidth = 0;
}

- (void) updateAuthorAvatar {
    id photo = [self.answer.author fetchIfNeeded][@"photo"];
    if ([photo isKindOfClass:[PFFile class]]) {
        self.authorImage.file = photo;
    } else {
        [self.authorImage clearFile];
    }
    
    [self.authorImage loadInBackground];
}

- (void) updateUpvoteCountLabel {
    NSString *text = nil;
    if (self.answer.upVoters.count == 0) {
        text = NSLocalizedString(@"No upvote yet", nil);
    } else if (self.answer.upVoters.count == 1) {
        text = NSLocalizedString(@"1 upvote", nil);
    } else {
        text = [[NSString stringWithFormat:@"%ld ", self.answer.upVoters.count] stringByAppendingString:NSLocalizedString(@"upvotes", nil)];
    }
    self.upvoteCountLabel.text = text;
}

- (void) updateVoteButtonToVoted:(BOOL) voted {
    FAKFontAwesome *icon = [FAKFontAwesome thumbsOUpIconWithSize:20];
    [icon addAttribute:NSForegroundColorAttributeName
                 value:voted ? [UIColor alizarinRed] : [UIColor peterRiverBlue]];
    [self.voteButton setAttributedTitle:[icon attributedString] forState:UIControlStateNormal];
}

#pragma mark - Answer

- (void)setAnswer:(BQAnswer *)answer {
    _answer = [answer fetchIfNeeded];
    if (_answer) {
        self.upvoted = [self didIUpvote];
        [self updateUI];
    }
}

- (BOOL) didIUpvote {
    for (PFUser *upVoter in self.answer.upVoters) {
        if ([[upVoter fetchIfNeeded].email isEqualToString:[PFUser currentUser].email])
            return YES;
    }
    return NO;
}

#pragma mark - Gesture

- (void) didTapAvartar {
    [[NSNotificationCenter defaultCenter] postNotificationName:BQPresentUserProfileNotification object:nil userInfo:@{@"user": self.answer.author}];
}

#pragma mark - Button target

- (IBAction)voteButtonTapped:(id)sender {
    self.upvoted = !self.upvoted;
    [self updateVoteButtonToVoted:self.upvoted];
    
    [[ParseService service] vote:self.upvoted forAnswer:self.answer block:^(BOOL succeeded, NSError *error) {
        [self.answer fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.upvoted = [self didIUpvote];
                [self updateVoteButtonToVoted:self.upvoted];
                [self updateUpvoteCountLabel];
                
                if (self.upvoteDelegate) {
                    [self.upvoteDelegate cell:self didFinishUpvote:self.upvoted withAnswer:self.answer];
                }
            });
        }];
    }];
}


@end

//
//  QuestionTableViewCell.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-15.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "QuestionTableViewCell.h"
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "UIImage+Gravatar.h"
#import "ProfileViewController.h"
#import <ParseUI.h>
#import "PFImageView+Addition.h"

@interface QuestionTableViewCell () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerCountLabel;
@property (weak, nonatomic) IBOutlet PFImageView *avartarImage;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation QuestionTableViewCell

- (void)awakeFromNib {
    [self makeCircleAvartarImageView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:96]];

    self.avartarImage.userInteractionEnabled = YES;
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAvartar)];
    self.tapGesture.numberOfTapsRequired = 1;
    [self.avartarImage addGestureRecognizer:self.tapGesture];
    self.tapGesture.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewAnswerNotification:) name:BQQuestionNewAnswerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAvatarUpdated:) name:BQUserAvatarUpdatedNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void) makeCircleAvartarImageView {
    self.avartarImage.layer.cornerRadius = self.avartarImage.frame.size.height / 2;
    self.avartarImage.layer.masksToBounds = YES;
    self.avartarImage.layer.borderWidth = 0;
}

- (void) updateAnswerCountLabelWithCount:(NSUInteger)count {
    NSString *text = nil;
    if (count == 0) {
        text = NSLocalizedString(@"No Answer", nil);
    } else if (count == 1) {
        text = [[NSString stringWithFormat:@"%ld ", count] stringByAppendingString:NSLocalizedString(@"Answer", nil)];
    } else {
        text = [[NSString stringWithFormat:@"%ld ", count] stringByAppendingString:NSLocalizedString(@"Answers", nil)];
    }
    self.answerCountLabel.text = text;
}

- (void) updateAvatar {
    [self.question.author fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            id photo = object[@"photo"];
            if ([photo isKindOfClass:[PFFile class]]) {
                self.avartarImage.file = photo;
            } else {
                [self.avartarImage clearFile];
            }
            
            [self.avartarImage loadInBackground];
        }
    }];
}

- (void)userAvatarUpdated:(NSNotification *)notification {
    PFUser *user = notification.userInfo[@"user"];
    if ([user.email isEqualToString:self.question.author.email]) {
        [self.question.author fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            [self updateAvatar];
        }];
    }
}

#pragma mark - Question

- (void)setQuestion:(BQQuestion *)question {
    _question = question;
    if (_question) {
        self.questionLabel.text = _question.text;
        [self updateAnswerCountLabelWithCount:_question.answers.count];
        [self updateAvatar];
    }
}

- (void)didReceiveNewAnswerNotification:(NSNotification *)notification {
    if ((BQQuestion *)notification.userInfo[@"question"] == self.question) {
        [self updateAnswerCountLabelWithCount:self.question.answers.count];
    }
}

#pragma mark - Gesture

- (void) didTapAvartar {
    [[NSNotificationCenter defaultCenter] postNotificationName:BQPresentUserProfileNotification object:nil userInfo:@{@"user": self.question.author}];
}

@end

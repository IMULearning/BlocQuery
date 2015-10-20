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

@interface QuestionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avartarImage;


@end

@implementation QuestionTableViewCell

- (void)awakeFromNib {
    [self makeCircleAvartarImageView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:96]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewAnswerNotification:) name:BQQuestionNewAnswerNotification object:nil];
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

- (void) setAuthorAvartarWithEmail:(NSString *)authorEmail {
    UIImage *fallback = [[FAKFontAwesome userIconWithSize:60] imageWithSize:CGSizeMake(80, 80)];
    UIImage *gravatar = [UIImage imageWithGravatarEmail:authorEmail size:80 fallbackImage:fallback];
    [self.avartarImage setImage:gravatar];
}

#pragma mark - Question

- (void)setQuestion:(BQQuestion *)question {
    _question = question;
    if (_question) {
        self.questionLabel.text = _question.text;
        [self updateAnswerCountLabelWithCount:_question.answers.count];
        [self setAuthorAvartarWithEmail:[_question.author fetchIfNeeded].email];
    }
}

- (void)didReceiveNewAnswerNotification:(NSNotification *)notification {
    if ((BQQuestion *)notification.userInfo[@"question"] == self.question) {
        [self updateAnswerCountLabelWithCount:self.question.answers.count];
    }
}

@end

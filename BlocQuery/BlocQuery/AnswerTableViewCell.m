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

@interface AnswerTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorImage;
@property (weak, nonatomic) IBOutlet UILabel *upvoteCountLabel;

@end

@implementation AnswerTableViewCell

- (void)awakeFromNib {
    [self makeCircleAuthorImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - UI

- (void) makeCircleAuthorImageView {
    self.authorImage.layer.cornerRadius = self.authorImage.frame.size.height / 2;
    self.authorImage.layer.masksToBounds = YES;
    self.authorImage.layer.borderWidth = 0;
}

- (void) updateAuthorImageWithEmail:(NSString *)authorEmail {
    UIImage *fallback = [[FAKFontAwesome userIconWithSize:35] imageWithSize:CGSizeMake(35, 35)];
    UIImage *gravatar = [UIImage imageWithGravatarEmail:authorEmail size:35 fallbackImage:fallback];
    [self.authorImage setImage:gravatar];
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

#pragma mark - Answer

- (void)setAnswer:(BQAnswer *)answer {
    _answer = [answer fetchIfNeeded];
    if (_answer) {
        self.answerLabel.text = _answer.text;
        [self updateAuthorImageWithEmail:[_answer.author fetchIfNeeded].email];
        [self updateUpvoteCountLabel];
    }
}

@end

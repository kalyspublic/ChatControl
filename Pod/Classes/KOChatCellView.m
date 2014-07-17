//
//  KOChatCellView.m
//  Pods
//
//  Created by Kalys Osmonov on 7/13/14.
//
//

#import "KOChatCellView.h"
#import <QuartzCore/QuartzCore.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <EDHexColor/UIColor+EDHexColor.h>

#define koGreenBubbleColor @"def4c4"
#define koBlueBubbleColor @"c4eaf5"
#define koWhiteBubbleColor @"ffffff"
#define koManyLikesCount 10

@interface KOChatCellView ()

@property (nonatomic, weak) IBOutlet UIView *bubbleView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bubbleViewTop;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *timeLabelRight;
@property (nonatomic, weak) IBOutlet UITextView *messageTextView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *messageTextViewBottom;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *bookmarkImageView;

@property (nonatomic, weak) IBOutlet UIView *likesFrame;
@property (nonatomic, weak) IBOutlet UILabel *likesCountLabel;

@property (nonatomic, weak) IBOutlet UIView *dislikesFrame;
@property (nonatomic, weak) IBOutlet UILabel *dislikesCountLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *dislikesFrameLeft;

@property (nonatomic, weak) IBOutlet UIImageView *spanIconImageView;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, weak) IBOutlet UIImageView *successfulImageView;


@end

@implementation KOChatCellView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) configureCell {
    
    self.spinner.transform = CGAffineTransformMakeScale(0.6, 0.6);
    self.bubbleView.layer.cornerRadius = 8;
    
    [RACObserve(self, entry) subscribeNext:^(id<KOChatEntryDelegate> entry) {
        self.usernameLabel.text = [entry username];
        self.timeLabel.text = [entry time];
        self.dateLabel.text = [entry date];
        
        self.avatarImageView.image = nil;
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:[entry avatarPath]]];
        self.avatarImageView.layer.cornerRadius = 17;
        self.avatarImageView.layer.masksToBounds = YES;
        
        self.messageTextView.text = [entry text];
        self.messageTextView.textContainer.lineFragmentPadding = 0;
        self.messageTextView.textContainerInset = UIEdgeInsetsZero;
        
        if ([entry isBookmarked]) {
            self.bookmarkImageView.hidden = NO;
            self.timeLabelRight.constant = 27;
        } else {
            self.bookmarkImageView.hidden = YES;
            self.timeLabelRight.constant = 9;
        }
        
        if ([[entry likesCount] integerValue] != 0 || [[entry dislikesCount] integerValue] != 0) {
            self.messageTextViewBottom.constant = 20.0;
            self.dislikesFrameLeft.constant = 85.0;
            
            if ([[entry likesCount] integerValue] != 0) {
                self.likesFrame.hidden = NO;
                self.likesCountLabel.text = [[entry likesCount] stringValue];
            } else {
                self.likesFrame.hidden = YES;
            }
            
            if ([[entry dislikesCount] integerValue] != 0) {
                self.dislikesFrame.hidden = NO;
                self.dislikesCountLabel.text = [[entry dislikesCount] stringValue];
                
                if ([[entry likesCount] integerValue] == 0) {
                    self.dislikesFrameLeft.constant = 46.0;
                }
            } else {
                self.dislikesFrame.hidden = YES;
            }
        } else {
            self.messageTextViewBottom.constant = 6.0;
            self.likesFrame.hidden = YES;
            self.dislikesFrame.hidden = YES;
        }
        
        [RACObserve(entry, sendingStatus) subscribeNext:^(NSNumber *sendingStatus) {
            if ([sendingStatus integerValue] == koMessageStatusSending) {
                NSLog(@"sending");
                self.timeLabelRight.constant = 27;
                [self.spinner startAnimating];
            } else if ([sendingStatus integerValue] == koMessageStatusError) {
                NSLog(@"error");
                [self.spinner stopAnimating];
            } else if ([sendingStatus integerValue] == koMessageStatusSuccessful) {
                self.timeLabelRight.constant = 27;
                [self.spinner stopAnimating];
                self.successfulImageView.hidden = NO;
            }
        }];
        
        if ([entry isSpamed]) {
            self.bubbleView.alpha = 0.3;
            self.spanIconImageView.hidden = NO;
        } else {
            self.bubbleView.alpha = 1;
            self.spanIconImageView.hidden = YES;
        }
        
        if ([entry isOutgoing]) {
            self.bubbleView.backgroundColor = [UIColor colorWithHexString:koGreenBubbleColor];
        } else {
            if ([[entry likesCount] integerValue] >= koManyLikesCount) {
                self.bubbleView.backgroundColor = [UIColor colorWithHexString:koBlueBubbleColor];
            } else {
                self.bubbleView.backgroundColor = [UIColor colorWithHexString:koWhiteBubbleColor];
            }
        }
        
        self.dateLabel.hidden = ![entry showDate];
        if ([entry showDate]) {
            self.bubbleViewTop.constant = 20;
        } else {
            self.bubbleViewTop.constant = 4;
        }
    }];
}

@end
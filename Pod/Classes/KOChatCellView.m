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
    if (!self.bubbleColor) {
        self.bubbleColor = [UIColor clearColor];
    }
    
    RAC(self.bubbleView, backgroundColor) = RACObserve(self, bubbleColor);
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
            self.dislikesFrameLeft.constant = 80.0;
            
            if ([[entry likesCount] integerValue] != 0) {
                self.likesFrame.hidden = NO;
                self.likesCountLabel.text = [[entry likesCount] stringValue];
            }
            
            if ([[entry dislikesCount] integerValue] != 0) {
                self.dislikesFrame.hidden = NO;
                self.dislikesCountLabel.text = [[entry dislikesCount] stringValue];
                
                if ([[entry likesCount] integerValue] == 0) {
                    self.dislikesFrameLeft.constant = 46.0;
                }
            }
        } else {
            self.messageTextViewBottom.constant = 6.0;
            self.likesFrame.hidden = YES;
            self.dislikesFrame.hidden = YES;
        }
        
        if ([entry isSpamed]) {
            self.bubbleView.alpha = 0.3;
        }
    }];
    
    RAC(self.dateLabel, hidden) = [RACObserve(self, isDateVisible) map:^id(id value) {
        return @(![value boolValue]);
    }];
    
    RAC(self.bubbleViewTop, constant) = [RACObserve(self, isDateVisible) map:^id(id value) {
        if ([value boolValue]) {
            return @20;
        } else {
            return @4;
        }
    }];
}

@end
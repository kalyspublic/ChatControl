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
@property (nonatomic, weak) IBOutlet UITextView *messageTextView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

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
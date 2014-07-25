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
#import <libextobjc/EXTScope.h>

#define koGreenBubbleColor @"def4c4"
#define koBlueBubbleColor @"c4eaf5"
#define koWhiteBubbleColor @"ffffff"
#define koManyLikesCount 10

@interface KOChatCellView ()

@property (nonatomic, weak) IBOutlet UIView *bubbleView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bubbleViewTop;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bubbleViewRight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bubbleViewBottom;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bubbleViewLeft;

@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *timeLabelRight;
@property (nonatomic, weak) IBOutlet UITextView *messageTextView;
@property (nonatomic, weak) IBOutlet UIImageView *messageImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewBottom;
@property (nonatomic, weak) IBOutlet UIImageView *playButtonImageView;
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

@property (nonatomic, weak) IBOutlet UIView *errorWhiteOverlay;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *errorWhiteOverlayTop;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *errorWhiteOverlayRight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *errorWhiteOverlayBottom;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *errorWhiteOverlayLeft;

@property (nonatomic, weak) IBOutlet UIImageView *tailGreenImageView;
@property (nonatomic, weak) IBOutlet UIImageView *tailLeftImaveView;

@end

@implementation KOChatCellView

- (void) prepareForReuse {
    [super prepareForReuse];
    self.isDateVisible = NO;
    self.isOutgoing = NO;
    self.errorWhiteOverlay.hidden = YES;
    [self.spinner stopAnimating];
    self.tailGreenImageView.image = [UIImage imageNamed:@"tail_green"];
}

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
    
    @weakify(self);
    self.spinner.transform = CGAffineTransformMakeScale(0.6, 0.6);
    self.bubbleView.layer.cornerRadius = 8;
    self.errorWhiteOverlay.layer.cornerRadius = 8;
    RAC(self.errorWhiteOverlayTop, constant) = RACObserve(self.bubbleViewTop, constant);
    RAC(self.errorWhiteOverlayBottom, constant) = RACObserve(self.bubbleViewBottom, constant);
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorOverlayTap:)];
    [self.errorWhiteOverlay addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *avatarTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)];
    [self.avatarImageView addGestureRecognizer:avatarTapRecognizer];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    [[RACObserve(self, entry) ignore:nil] subscribeNext:^(id<KOChatEntryProtocol> entry) {
        @strongify(self);
        // default values
        self.timeLabelRight.constant = 9;
        self.successfulImageView.hidden = YES;
        self.playButtonImageView.hidden = YES;
        
        self.usernameLabel.text = [entry username];
        self.timeLabel.text = [entry time];
        self.dateLabel.text = [entry date];
        
        self.avatarImageView.image = nil;
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:[entry avatarPath]]];
        self.avatarImageView.layer.cornerRadius = 17;
        self.avatarImageView.layer.masksToBounds = YES;
        
        if ([entry type] == koChatEntryTypeText) {
            self.messageImageView.hidden = YES;
            self.messageTextView.hidden = NO;
            self.messageTextView.text = [entry text];
            self.messageTextView.textContainer.lineFragmentPadding = 0;
            self.messageTextView.textContainerInset = UIEdgeInsetsZero;
        } else if ([entry type] == koChatEntryTypePhoto || [entry type] == koChatEntryTypeVideo) {
            self.messageImageView.hidden = NO;
            self.messageTextView.hidden = YES;
            [self.messageImageView setImageWithURL:[NSURL URLWithString:[entry thumbnailURL]]];
            
            if ([entry type] == koChatEntryTypeVideo) {
                self.playButtonImageView.hidden = NO;
            }
            
            for (UIGestureRecognizer *recognizer in self.messageImageView.gestureRecognizers) {
                [self.messageImageView removeGestureRecognizer:recognizer];
            }
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
            [self.messageImageView addGestureRecognizer:tapRecognizer];
        }
        
        if ([entry isBookmarked]) {
            self.bookmarkImageView.hidden = NO;
            self.timeLabelRight.constant = 27;
        } else {
            self.bookmarkImageView.hidden = YES;
        }
        
        if ([entry likesCount] != 0 || [entry dislikesCount] != 0) {
            self.contentViewBottom.constant = 20.0;
            self.dislikesFrameLeft.constant = 85.0;
            
            if ([entry likesCount] != 0) {
                self.likesFrame.hidden = NO;
                self.likesCountLabel.text = [[NSNumber numberWithInteger: [entry likesCount]] stringValue];
            } else {
                self.likesFrame.hidden = YES;
            }
            
            if ([entry dislikesCount] != 0) {
                self.dislikesFrame.hidden = NO;
                self.dislikesCountLabel.text = [[NSNumber numberWithInteger: [entry dislikesCount]] stringValue];
                
                if ([entry likesCount] == 0) {
                    self.dislikesFrameLeft.constant = 46.0;
                }
            } else {
                self.dislikesFrame.hidden = YES;
            }
        } else {
            self.contentViewBottom.constant = 6.0;
            self.likesFrame.hidden = YES;
            self.dislikesFrame.hidden = YES;
        }
        
        if ([entry isSpamed]) {
            self.bubbleView.alpha = 0.3;
            self.tailLeftImaveView.alpha = 0.3;
            self.tailGreenImageView.alpha = 0.3;
            self.spanIconImageView.hidden = NO;
        } else {
            self.bubbleView.alpha = 1;
            self.tailLeftImaveView.alpha = 1;
            self.tailGreenImageView.alpha = 1;
            self.spanIconImageView.hidden = YES;
        }
        

        if ([entry likesCount] >= koManyLikesCount) {
            self.bubbleView.backgroundColor = [UIColor colorWithHexString:koBlueBubbleColor];
            self.tailLeftImaveView.image = [UIImage imageNamed:@"tail_blue"];
        } else {
            self.bubbleView.backgroundColor = [UIColor colorWithHexString:koWhiteBubbleColor];
            self.tailLeftImaveView.image = [UIImage imageNamed:@"tail_white"];
        }
    }];
    
    [[RACSignal combineLatest:@[[RACObserve(self, entry) ignore:nil], RACObserve(self, isOutgoing)]] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        id<KOChatEntryProtocol> entry = tuple.first;
        id isOutgoing = tuple.second;
        
        if ([isOutgoing boolValue]) {
            [self setMessageStatus:[entry sendingStatus]];
            @weakify(self);
            [[RACObserve(entry, sendingStatus) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id sendingStatusObj) {
                @strongify(self);
                KOMessageStatus sendingStatus = [sendingStatusObj integerValue];
                [self setMessageStatus:sendingStatus];
            }];
        }
    }];
    
    RAC(self.bubbleViewTop, constant) = [RACObserve(self, isDateVisible) map:^id(id isDateVisible) {
        return [isDateVisible boolValue] ? @(20) : @(4);
    }];
    
    RAC(self.dateLabel, hidden) = [RACObserve(self, isDateVisible) map:^id(id isDateVisible) {
        return @(![isDateVisible boolValue]);
    }];
    
    [RACObserve(self, isOutgoing) subscribeNext:^(id isOutgoing) {
        @strongify(self);
        if ([isOutgoing boolValue]) {
            self.bubbleView.backgroundColor = [UIColor colorWithHexString:koGreenBubbleColor];
            self.tailGreenImageView.hidden = NO;
            self.tailLeftImaveView.hidden = YES;
        } else {
            self.tailGreenImageView.hidden = YES;
            self.tailLeftImaveView.hidden = NO;
        }
    }];
}

- (void) avatarTap:(id) sender {
    [self.delegate koChatCellView:self avatarTap:self.entry sender:sender];
}

- (void) didLongPress:(id) sender {
    [self.delegate koChatCellView:self didLongPress:self.entry sender:sender];
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender {
    return [self.delegate koChatCellView:self canPerformAction:action withSender:sender];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void) setMessageStatus:(KOMessageStatus) sendingStatus {
    if (sendingStatus == koMessageStatusSending) {
        self.timeLabelRight.constant = 27;
        [self.spinner startAnimating];
    } else if (sendingStatus == koMessageStatusError) {
        [self.spinner stopAnimating];
        self.errorWhiteOverlay.hidden = NO;
        self.tailGreenImageView.image = [UIImage imageNamed:@"tail_whiteError"];
    } else if (sendingStatus == koMessageStatusSuccessful) {
        self.timeLabelRight.constant = 27;
        [self.spinner stopAnimating];
        self.successfulImageView.hidden = NO;
    } else {
        [self.spinner stopAnimating];
        self.successfulImageView.hidden = YES;
        self.errorWhiteOverlay.hidden = YES;
        self.tailGreenImageView.image = [UIImage imageNamed:@"tail_green"];
        self.timeLabelRight.constant = 9;
    }
}

/* media image tap recognizer */
- (void) imageTapped:(id) sender {
    [self.delegate koChatCellView:self photoTap:self.entry sender:sender];
}


- (void) errorOverlayTap:(id)sender {
    if ([self.entry sendingStatus] == koMessageStatusError) {
        [self.delegate koChatCellView:self errorCellTap:self.entry sender:sender];
    }
}

//  @[likeItem, dislikeItem, saveItem, deleteSaveItem, spamItem, unspamItem, replyItem];
- (void) likeAction:(id) sender {
    [self.delegate koChatCellView:self likeItem:sender];
}

- (void) dislikeAction:(id) sender {
    [self.delegate koChatCellView:self dislikeItem:sender];
}

- (void) saveAction:(id) sender {
    [self.delegate koChatCellView:self saveItem:sender];
}

- (void) spamAction:(id) sender {
    [self.delegate koChatCellView:self spamItem:sender];
}

- (void) unspamAction:(id) sender {
    [self.delegate koChatCellView:self unspamItem:sender];
}

- (void) replyAction:(id) sender {
    [self.delegate koChatCellView:self replyItem:sender];
}

- (void) copy:(id)sender {
    [self.delegate koChatCellView:self copyItem:sender];
}

- (void) deleteSaveAction:(id)sender {
    [self.delegate koChatCellView:self deleteSaveItem:sender];
}

@end
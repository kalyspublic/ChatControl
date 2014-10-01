//
//  KOChatCellView.m
//  Pods
//
//  Created by Kalys Osmonov on 7/13/14.
//
//

#import "KOChatCellView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <EDHexColor/UIColor+EDHexColor.h>
#import <libextobjc/EXTScope.h>
#import <UIImage-Resize/UIImage+Resize.h>
#import "KOTextAttachment.h"
#import "KOChatEntryDelegate.h"

#define koGreenBubbleImage @"bubbleGreen"
#define koBlueBubbleImage @"bubbleBlue"
#define koWhiteBubblImage @"bubbleWhite"

#define koOutgoingTimeColor @"a2b092"
#define koDefaultTimeColor @"B0B0B0"
#define koManyLikesCount 10

static void *ProgressObserverContext = &ProgressObserverContext;

@interface KOChatCellView ()

@property (nonatomic, weak) IBOutlet UIView *bubbleView;
@property (nonatomic, weak) IBOutlet UIImageView *bubbleImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bubbleViewTop;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bubbleViewRight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bubbleViewBottom;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bubbleViewLeft;

@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *timeLabelRight;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewBottom;
@property (nonatomic, weak) IBOutlet KOChatElementsView *elementsView;

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
//    [self.spinner stopAnimating];
    self.tailGreenImageView.image = [UIImage imageNamed:@"tail_green"];
    self.usernameLabel.text = @"";
    [self.avatarImageView setImage:nil];
    self.bubbleViewTop.constant = 4.0;
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
    self.elementsView.elementsViewDelegate = self;
    @weakify(self);
//    self.spinner.transform = CGAffineTransformMakeScale(0.6, 0.6);
//    self.bubbleView.layer.cornerRadius = 8;
//    self.errorWhiteOverlay.layer.cornerRadius = 8;
    self.bubbleView.backgroundColor = [UIColor clearColor];
    self.bubbleViewTop.constant = 4.0;
    RAC(self.errorWhiteOverlayTop, constant) = RACObserve(self.bubbleViewTop, constant);
    RAC(self.errorWhiteOverlayBottom, constant) = RACObserve(self.bubbleViewBottom, constant);
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorOverlayTap:)];
    [self.errorWhiteOverlay addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *avatarTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)];
    [self.avatarImageView addGestureRecognizer:avatarTapRecognizer];
    
    UITapGestureRecognizer *usernameTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usernameTap:)];
    [self.usernameLabel addGestureRecognizer:usernameTapRecognizer];
    
    UITapGestureRecognizer *bubbleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleTap:)];
    [self.bubbleView addGestureRecognizer:bubbleTapRecognizer];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    [[RACObserve(self, entry) ignore:nil] subscribeNext:^(id<KOChatEntryProtocol> entry) {
        @strongify(self);
        // default values
        self.timeLabelRight.constant = 9;
        self.successfulImageView.hidden = YES;
        
        self.usernameLabel.text = [entry username];
        self.timeLabel.text = [entry time];
        self.dateLabel.text = [entry date];
        
        self.avatarImageView.image = nil;
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:[entry avatarPath]]];
        self.avatarImageView.layer.cornerRadius = 17;
        self.avatarImageView.layer.masksToBounds = YES;
        
        self.elementsView.elements = [entry content];
        
        if ([entry isBookmarked]) {
            self.bookmarkImageView.hidden = NO;
            self.timeLabelRight.constant = 27;
        } else {
            self.bookmarkImageView.hidden = YES;
        }
        
        if ([entry likesCount] != 0 || [entry dislikesCount] != 0) {
            self.contentViewBottom.constant = 22.0;
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
        self.avatarImageView.userInteractionEnabled = ![entry isSpamed];
        self.usernameLabel.userInteractionEnabled = ![entry isSpamed];

        if (self.isOutgoing) {
            [self setMessageStatus:[entry sendingStatus]];
        } else {
            if ([entry likesCount] >= koManyLikesCount) {
                [self setBubble:koBlueBubbleImage];
                self.tailLeftImaveView.image = [UIImage imageNamed:@"tail_blue"];
            } else {
                [self setBubble:koWhiteBubblImage];
                self.tailLeftImaveView.image = [UIImage imageNamed:@"tail_white"];
            }
        }
    }];
    
    RAC(self.bubbleViewTop, constant) = [RACObserve(self, isDateVisible) map:^id(id isDateVisible) {
        return [isDateVisible boolValue] ? @(18) : @(4);
    }];
    
    RAC(self.dateLabel, hidden) = [RACObserve(self, isDateVisible) map:^id(id isDateVisible) {
        return @(![isDateVisible boolValue]);
    }];
    
    [RACObserve(self, isOutgoing) subscribeNext:^(id isOutgoing) {
        @strongify(self);
        if ([isOutgoing boolValue]) {
            [self setBubble:koGreenBubbleImage];
            self.tailGreenImageView.hidden = NO;
            self.tailLeftImaveView.hidden = YES;
            self.timeLabel.textColor = [UIColor colorWithHexString:koOutgoingTimeColor];
        } else {
            self.timeLabel.textColor = [UIColor colorWithHexString:koDefaultTimeColor];
            self.tailGreenImageView.hidden = YES;
            self.tailLeftImaveView.hidden = NO;
        }
    }];
}

- (void) avatarTap:(id) sender {
    [self.delegate koChatCellView:self avatarTap:self.entry sender:sender];
}

- (void) usernameTap:(id) sender {
    [self.delegate koChatCellView:self usernameTap:self.entry sender:sender];
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

- (void) setBubble:(NSString *) bubbleType {
    UIImage *image = [UIImage imageNamed:bubbleType];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
    self.bubbleImageView.image = [image resizableImageWithCapInsets:edgeInsets];
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
        if ([self.spinner isAnimating]) {
            [self.spinner stopAnimating];
        }
        self.timeLabelRight.constant = 27;
        self.successfulImageView.hidden = NO;
    } else {
        [self.spinner stopAnimating];
        self.successfulImageView.hidden = YES;
        self.errorWhiteOverlay.hidden = YES;
        self.tailGreenImageView.image = [UIImage imageNamed:@"tail_green"];
        self.timeLabelRight.constant = 9;
    }
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

- (void) bubbleTap:(id) sender {
    [self.delegate koChatCellView:self expandOrCollapseSpammedMessage:self.entry];
}

- (RACSignal *) koChatElementsView:(KOChatElementsView *)koChatElementsView didTapOnElement:(id<KOChatElementProtocol>)element cacheURL:(NSURL *)cacheURL sender:(id)sender {
    return [[self.delegate koChatCellView:self mediaTapOnElement:element model:self.entry sender:sender] takeUntil:self.rac_prepareForReuseSignal];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    @weakify(self);
    if (context == ProgressObserverContext)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            @strongify(self);
            NSProgress *progress = object;
            [self.elementsView updateProgressBarForElement:progress.userInfo[@"imageView"] progress:@(progress.fractionCompleted)];
        }];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

- (void) setAvatarByURL:(NSString *)avatarPath {
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:avatarPath]];
}

- (void) mediaDownloadFinishedFor:(id<KOChatElementProtocol>)element newImageURL:(NSURL *)imageURL {
    [self.elementsView updateElementMedia:element url:imageURL];
}

- (NSURL *) thumbnailURL:(NSURL *)sourceURL {
    return [self.delegate koChatCellViewThumbnailURLFromCacheFor:sourceURL];
}

@end
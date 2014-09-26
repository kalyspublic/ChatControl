//
//  KOElementImageView.m
//  Pods
//
//  Created by Kalys Osmonov on 9/26/14.
//
//

#import "KOElementImageView.h"
#import "KOChatElementsView.h"

@interface KOElementImageView ()

@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UIView *downloadView;

@end

@implementation KOElementImageView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if ([self.element type] == koChatEntryTypeVideo) {
            [self showDownloadButton];
        }
    }
    return self;
}

- (void) showDownloadButton {
    self.playImageView.hidden = YES;
    self.downloadView.hidden = NO;
}

- (void) showProgressBar {
    
}

- (void) showPlayButton {
    
}

@end

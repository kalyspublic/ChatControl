//
//  KOElementImageView.m
//  Pods
//
//  Created by Kalys Osmonov on 9/26/14.
//
//

#import "KOElementImageView.h"
#import "KOChatEntryDelegate.h"
#import "KOChatElementsView.h"
#import <BKECircularProgressView/BKECircularProgressView.h>

@interface KOElementImageView ()

@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UIView *downloadView;
@property (nonatomic, strong) BKECircularProgressView *progressBar;

@end

@implementation KOElementImageView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self initPlayButton];
//        [self initDowloadView];
//        [self initProgressBar];
    }
    return self;
}

- (void) showDownloadButton {
    if (!self.downloadView) {
        [self initDowloadView];
    }
    NSLog(@"download button");
    self.playImageView.hidden = YES;
    self.downloadView.hidden = NO;
    self.progressBar.hidden = YES;
}

- (void) showProgressBar {
    NSLog(@"progress bar");
    if (!self.progressBar) {
        [self initProgressBar];
    }
    self.playImageView.hidden = YES;
    self.downloadView.hidden = YES;
    self.progressBar.hidden = NO;
}

- (void) showPlayButton {
    if (!self.playImageView) {
        [self initPlayButton];
    }
    NSLog(@"play button");
    self.playImageView.hidden = NO;
    self.downloadView.hidden = YES;
    self.progressBar.hidden = YES;
}

- (void) setProgress:(NSNumber *)progress {
    self.progressBar.progress = [progress floatValue];
}

- (void) initPlayButton {
    self.playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnPlay"]];
    [self addSubview:self.playImageView];
    self.playImageView.center = CGPointMake(koMediaElementWidth/2.0, koMediaElementHeight/2.0);
    self.playImageView.hidden = YES;
}

- (void) initDowloadView {
    self.downloadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    self.downloadView.backgroundColor = [UIColor redColor];
    [self addSubview:self.downloadView];
    self.downloadView.center = CGPointMake(koMediaElementWidth/2.0, koMediaElementHeight/2.0);
    self.downloadView.hidden = YES;
}

- (void) initProgressBar {
    self.progressBar = [[BKECircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self addSubview:self.progressBar];
    self.progressBar.center = CGPointMake(koMediaElementWidth/2.0, koMediaElementHeight/2.0);
    self.progressBar.hidden = YES;
    self.progressBar.progress = 0.0;
}

@end

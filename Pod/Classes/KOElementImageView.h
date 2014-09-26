//
//  KOElementImageView.h
//  Pods
//
//  Created by Kalys Osmonov on 9/26/14.
//
//

#import <UIKit/UIKit.h>
#import "KOChatEntryDelegate.h"

@interface KOElementImageView : UIImageView

@property (nonatomic, strong) id<KOChatElementProtocol> element;
@property (nonatomic, strong) NSURL *cacheURL;

- (void) showDownloadButton;
- (void) showProgressBar;
- (void) showPlayButton;

@end

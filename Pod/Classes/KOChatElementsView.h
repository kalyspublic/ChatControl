//
//  KOChatElementsView.h
//  Pods
//
//  Created by Kalys Osmonov on 8/7/14.
//
//

#import <UIKit/UIKit.h>

#define koMediaElementWidth 247.0
#define koMediaElementHeight 138.0
#define koMediaElementBottomPadding 10.0
#define koContentWidthLandscape 490.0
#define koContentWidthPortrait 245.0

@protocol KOChatElementProtocol;
@class KOChatElementsView;

@protocol KOChatElementsViewDelegate <NSObject>

- (void) koChatElementsView:(KOChatElementsView *)koChatElementsView didTapOnElement:(id<KOChatElementProtocol>)element cacheURL:(NSURL *)cacheURL sender:(id)sender;

- (NSURL *) thumbnailURL:(NSURL *)sourceURL;

@end

@interface KOChatElementsView : UIScrollView

@property (nonatomic, weak) id<KOChatElementsViewDelegate> elementsViewDelegate;
@property (nonatomic, strong) NSArray *elements;

- (void) updateProgressBarForElement:(id<KOChatElementProtocol>)element progress:(NSNumber *)progress;
- (void) updateElementMedia:(id<KOChatElementProtocol>)element url:(NSURL *)cacheURL;

@end

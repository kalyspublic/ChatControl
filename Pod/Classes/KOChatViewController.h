//
//  KOChatViewController.h
//  Pods
//
//  Created by Kalys Osmonov on 7/10/14.
//
//

#import <UIKit/UIKit.h>
#import "KOChatTableViewHeader.h"
#import "KOChatTableViewFooter.h"
#import "KOChatEntryDelegate.h"

@class KOChatViewController;

@protocol KOChatViewControllerDelegate <NSObject>

- (void) koChatViewController:(KOChatViewController *)koChatViewController loadMoreDidTap:(id) sender;
- (void) koChatViewController:(KOChatViewController *)koChatViewController joinDidTap:(id) sender;
- (void) koChatViewController:(KOChatViewController *)koChatViewController cameraButtonTouched:(id) sender textField:(UITextView *)textField;
- (void) koChatViewController:(KOChatViewController *)koChatViewController sendButtonTouched:(id) sender textViewElements:(NSArray *)elements;

@end

@interface KOChatViewController : UIViewController<KOChatTableViewHeaderDelegate, KOChatTableViewFooterDelegate, UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) id<KOChatViewControllerDelegate> delegate;

- (void) showLoadMore;
- (void) hideLoadMore;

- (void) showJoin;
- (void) hideJoin;

- (void) showInput;
- (void) hideInput;
- (void) focusInput;

- (void) finishSending;
- (void) updateTextFieldFrameWithDelay;
- (void) updateTextFieldFrame;

- (void) appendImageElementToTextView:(id<KOChatElementProtocol>)element withThumbnail:(UIImage *)image;
@end

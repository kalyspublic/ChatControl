//
//  KOChatViewController.h
//  Pods
//
//  Created by Kalys Osmonov on 7/10/14.
//
//

#import <UIKit/UIKit.h>
#import "KOKeyboardAccessoryViewDelegate.h"
#import "KOChatTableViewHeader.h"
#import "KOChatTableViewFooter.h"

@class KOChatViewController;

@protocol KOChatViewControllerDelegate <NSObject>

- (void) koChatViewController:(KOChatViewController *)koChatViewController loadMoreDidTap:(id) sender;
- (void) koChatViewController:(KOChatViewController *)koChatViewController joinDidTap:(id) sender;

@end

@interface KOChatViewController : UIViewController<KOChatTableViewHeaderDelegate, KOChatTableViewFooterDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) id<KOKeyboardAccessoryViewDelegate> messageFormDelegate;
@property (nonatomic, weak) id<KOChatViewControllerDelegate> delegate;

- (void) showLoadMore;
- (void) hideLoadMore;

- (void) showJoin;
- (void) hideJoin;
@end

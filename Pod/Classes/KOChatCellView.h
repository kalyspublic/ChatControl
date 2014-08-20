//
//  KOChatCellView.h
//  Pods
//
//  Created by Kalys Osmonov on 7/13/14.
//
//

#import <UIKit/UIKit.h>
#import "KOChatEntryDelegate.h"
#import "KOChatElementsView.h"

@class KOChatCellView;

@protocol  KOChatCellViewDelegate <NSObject>

- (void) koChatCellView:(KOChatCellView *)cell mediaTapOnElement:(id<KOChatElementProtocol>)element model:(id<KOChatEntryProtocol>)model sender:(id)sender;
- (void) koChatCellView:(KOChatCellView *)cell errorCellTap:(id<KOChatEntryProtocol>)model sender:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell didLongPress:(id<KOChatEntryProtocol>)model sender:(id)sender;
- (BOOL) koChatCellView:(KOChatCellView *)cell canPerformAction:(SEL)action withSender:(id)sender;
- (void) koChatCellView:(KOChatCellView *)cell avatarTap:(id<KOChatEntryProtocol>)model sender:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell usernameTap:(id<KOChatEntryProtocol>)model sender:(id) sender;

- (void) koChatCellView:(KOChatCellView *)cell likeItem:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell dislikeItem:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell saveItem:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell deleteSaveItem:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell spamItem:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell unspamItem:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell replyItem:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell copyItem:(id) sender;

@end

@interface KOChatCellView : UITableViewCell<KOChatElementsViewDelegate>

@property (nonatomic, strong) id<KOChatEntryProtocol> entry;
@property (nonatomic, weak) id<KOChatCellViewDelegate> delegate;
@property (nonatomic, assign) BOOL isDateVisible;
@property (nonatomic, assign) BOOL isOutgoing;

- (void) likeAction:(id) sender;
- (void) dislikeAction:(id) sender;
- (void) saveAction:(id) sender;
- (void) spamAction:(id) sender;
- (void) unspamAction:(id) sender;
- (void) replyAction:(id) sender;
- (void) deleteSaveAction:(id) sender;
- (void) copy:(id)sender;

@end

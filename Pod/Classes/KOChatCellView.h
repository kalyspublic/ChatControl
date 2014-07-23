//
//  KOChatCellView.h
//  Pods
//
//  Created by Kalys Osmonov on 7/13/14.
//
//

#import <UIKit/UIKit.h>
#import "KOChatEntryDelegate.h"

@class KOChatCellView;

@protocol  KOChatCellViewDelegate <NSObject>

- (void) koChatCellView:(KOChatCellView *)cell photoTap:(id<KOChatEntryProtocol>)model sender:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell errorCellTap:(id<KOChatEntryProtocol>)model sender:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell didLongPress:(id<KOChatEntryProtocol>)model sender:(id)sender;
- (BOOL) koChatCellView:(KOChatCellView *)cell canPerformAction:(SEL)action withSender:(id)sender;

- (void) koChatCellView:(KOChatCellView *)cell likeItem:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell dislikeItem:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell saveItem:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell deleteSaveItem:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell spamItem:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell unspamItem:(id) sender;
- (void) koChatCellView:(KOChatCellView *)cell replyItem:(id) sender;

@end

@interface KOChatCellView : UITableViewCell

@property (nonatomic, strong) id<KOChatEntryProtocol> entry;
@property (nonatomic, weak) id<KOChatCellViewDelegate> delegate;
@property (nonatomic, assign) BOOL isDateVisible;
@property (nonatomic, assign) BOOL isOutgoing;

- (void) likeItem:(id) sender;
- (void) dislikeItem:(id) sender;
- (void) saveItem:(id) sender;
- (void) deleteSaveItem:(id) sender;
- (void) spamItem:(id) sender;
- (void) unspamItem:(id) sender;
- (void) replyItem:(id) sender;

@end

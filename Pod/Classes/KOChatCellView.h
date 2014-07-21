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

@end

@interface KOChatCellView : UITableViewCell<KOChatEntryStatusDelegate>

@property (nonatomic, strong) id<KOChatEntryProtocol> entry;
@property (nonatomic, weak) id<KOChatCellViewDelegate> delegate;

@end

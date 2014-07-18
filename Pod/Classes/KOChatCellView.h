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

- (void) koChatCellView:(KOChatCellView *)cell photoTap:(id<KOChatEntryDelegate>)model sender:(id) sender;

@end

@interface KOChatCellView : UITableViewCell

@property (nonatomic, strong) id<KOChatEntryDelegate> entry;
@property (nonatomic, weak) id<KOChatCellViewDelegate> delegate;

@end

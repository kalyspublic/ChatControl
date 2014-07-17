//
//  KOChatTableViewHeader.h
//  Pods
//
//  Created by Kalys Osmonov on 7/17/14.
//
//

#import <UIKit/UIKit.h>

@class KOChatTableViewHeader;

@protocol KOChatTableViewHeaderDelegate <NSObject>

- (void) koChatTableViewHeader:(KOChatTableViewHeader *)koChatTableViewHeader loadMoreDidTap:(id) sender;

@end

@interface KOChatTableViewHeader : UIView

@property (nonatomic, weak) id<KOChatTableViewHeaderDelegate> delegate;

@end

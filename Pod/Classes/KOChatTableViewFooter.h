//
//  KOChatTableViewFooter.h
//  Pods
//
//  Created by Kalys Osmonov on 7/18/14.
//
//

#import <UIKit/UIKit.h>

@class KOChatTableViewFooter;

@protocol KOChatTableViewFooterDelegate <NSObject>

- (void) koChatTableViewFooter:(KOChatTableViewFooter *)koChatTableViewFooter joinDidTap:(id) sender;

@end

@interface KOChatTableViewFooter : UIView

@property (nonatomic, weak) id<KOChatTableViewFooterDelegate> delegate;


@end

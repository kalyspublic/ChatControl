//
//  KOChatCellView.h
//  Pods
//
//  Created by Kalys Osmonov on 7/13/14.
//
//

#import <UIKit/UIKit.h>
#import "KOChatEntryDelegate.h"

@interface KOChatCellView : UITableViewCell

@property (nonatomic, strong) id<KOChatEntryDelegate> entry;
@property (nonatomic, strong) UIColor *bubbleColor;
@property (nonatomic, assign) BOOL isDateVisible;

@end

//
//  KOImageView.h
//  Pods
//
//  Created by Kalys Osmonov on 8/7/14.
//
//

#import <UIKit/UIKit.h>
#import "KOChatEntryDelegate.h"

@interface KOImageView : UIImageView

@property (nonatomic, strong) id<KOChatElementProtocol> element;

@end

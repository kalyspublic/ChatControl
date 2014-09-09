//
//  KOChatControlHelper.h
//  Pods
//
//  Created by Kalys Osmonov on 7/17/14.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "KOChatEntryDelegate.h"

@interface KOChatControlHelper : NSObject

+ (CGFloat) cellHeight:(id<KOChatEntryProtocol>) entry dateVisible:(BOOL)dateVisible spamExpanded:(BOOL) spamExpanded;

@end

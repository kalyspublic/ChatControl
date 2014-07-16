//
//  KOChatEntryDelegate.h
//  Pods
//
//  Created by Kalys Osmonov on 7/13/14.
//
//

#import <Foundation/Foundation.h>

@protocol KOChatEntryDelegate <NSObject>

@required

@property (readonly) NSString *text;
@property (readonly) NSString *username;
@property (readonly) NSString *avatarPath;
@property (readonly) NSString *time;
@property (readonly) NSString *date;
@property (readonly) BOOL isOutgoing;
@property (readonly) BOOL isBookmarked;
@property (readonly) BOOL isLiked;
@property (readonly) BOOL isReported;
@property (readonly) BOOL isSpamed;
@property (readonly) NSString *sendingStatus;
@property (readonly) NSNumber *likesCount;
@property (readonly) NSNumber *dislikesCount;

@end

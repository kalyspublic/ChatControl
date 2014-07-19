//
//  KOChatEntryDelegate.h
//  Pods
//
//  Created by Kalys Osmonov on 7/13/14.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    koChatEntryTypeText = 1,
    koChatEntryTypePhoto = 2,
    koChatEntryTypeVideo = 3
} KOChatEntryType;

typedef enum {
    koMessageStatusSending = 1,
    koMessageStatusSuccessful = 2,
    koMessageStatusError = 3
} KOMessageStatus;

@protocol KOChatEntryProtocol <NSObject>

@required

@property (readonly) KOChatEntryType type;
@property (readonly) BOOL showDate;
@property (readonly) NSString *text;
@property (readonly) NSString *thumbnailURL;
@property (readonly) NSString *username;
@property (readonly) NSString *avatarPath;
@property (readonly) NSString *time;
@property (readonly) NSString *date;
@property (readonly) BOOL isOutgoing;
@property (readonly) BOOL isBookmarked;
@property (readonly) BOOL isLiked;
@property (readonly) BOOL isReported;
@property (readonly) BOOL isSpamed;
@property (readonly) KOMessageStatus sendingStatus;
@property (readonly) NSNumber *likesCount;
@property (readonly) NSNumber *dislikesCount;

@end

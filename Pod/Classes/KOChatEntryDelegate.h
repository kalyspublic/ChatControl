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

@protocol KOChatEntryStatusDelegate <NSObject>

- (void) statusUpdate:(KOMessageStatus) status;

@end

@protocol KOChatEntryProtocol <NSObject>

@required

@property (nonatomic, readonly) KOChatEntryType type;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSString *thumbnailURL;
@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *avatarPath;
@property (nonatomic, readonly) NSString *time;
@property (nonatomic, readonly) NSString *date;
@property (nonatomic, readonly) BOOL isOutgoing;
@property (nonatomic, readonly) BOOL isBookmarked;
@property (nonatomic, readonly) BOOL isLiked;
@property (nonatomic, readonly) BOOL isReported;
@property (nonatomic, readonly) BOOL isSpamed;
@property (nonatomic, readonly) KOMessageStatus sendingStatus;
@property (nonatomic, readonly) NSInteger likesCount;
@property (nonatomic, readonly) NSInteger dislikesCount;

@end

//
//  KOChatEntry.h
//  ChatControl
//
//  Created by Kalys Osmonov on 7/13/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChatControl/KOChatEntryDelegate.h>

@interface KOChatEntry : NSObject<KOChatEntryProtocol>

@property (assign) KOChatEntryType type;
@property (strong) NSString *text;
@property (strong) NSString *username;
@property (strong) NSString *avatarPath;
@property (strong) NSString *date;
@property (strong) NSString *time;
@property (assign) BOOL isOutgoing;
@property (assign) BOOL isBookmarked;
@property (assign) BOOL isLiked;
@property (assign) BOOL isReported;
@property (assign) BOOL isSpamed;
@property (assign, nonatomic) KOMessageStatus sendingStatus;
@property (assign) NSInteger likesCount;
@property (assign) NSInteger dislikesCount;
@property (strong) NSString *thumbnailURL;
@property (assign) BOOL showDate;

@property (nonatomic, weak) id<KOChatEntryStatusDelegate> statusDelegate;

@end
//
//  KOChatEntry.h
//  ChatControl
//
//  Created by Kalys Osmonov on 7/13/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChatControl/KOChatEntryDelegate.h>

@interface MYChatEntry : NSObject<KOChatEntryProtocol>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *avatarPath;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) BOOL isOutgoing;
@property (nonatomic, assign) BOOL isBookmarked;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, assign) BOOL isReported;
@property (nonatomic, assign) BOOL isSpamed;
@property (nonatomic, assign, nonatomic) KOMessageStatus sendingStatus;
@property (nonatomic, assign) NSInteger likesCount;
@property (nonatomic, assign) NSInteger dislikesCount;
@property (nonatomic, strong) NSArray *content;

@end
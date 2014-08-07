//
//  MYChatEntryElement.h
//  ChatControl
//
//  Created by Kalys Osmonov on 8/6/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChatControl/KOChatEntryDelegate.h>

@interface MYChatEntryElement : NSObject<KOChatElementProtocol>

+ (instancetype) elementWithText:(NSString *)text;
+ (instancetype) elementWithImageURL:(NSString *)imageURL andThumbnailURL:(NSString *)thumbnailURL;
+ (instancetype) elementWithVideoURL:(NSString *)videoURL andThumbnailURL:(NSString *)thumbnailURL;

@property (nonatomic, assign) KOChatEntryType type;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *videoURL;

@end

//
//  MYChatEntryElement.m
//  ChatControl
//
//  Created by Kalys Osmonov on 8/6/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import "MYChatEntryElement.h"

@implementation MYChatEntryElement

+ (instancetype) elementWithText:(NSString *)text {
    MYChatEntryElement *element = [MYChatEntryElement new];
    
    if (element) {
        element.type = koChatEntryTypeText;
        element.text = text;
    }
    return element;
}

+ (instancetype) elementWithImageURL:(NSString *)imageURL andThumbnailURL:(NSString *)thumbnailURL {
    MYChatEntryElement *element = [MYChatEntryElement new];
    
    if (element) {
        element.type = koChatEntryTypePhoto;
        element.imageURL = imageURL;
        element.thumbnailURL = thumbnailURL;
    }
    return element;
}

+ (instancetype) elementWithVideoURL:(NSString *)videoURL andThumbnailURL:(NSString *)thumbnailURL {
    MYChatEntryElement *element = [MYChatEntryElement new];
    
    if (element) {
        element.type = koChatEntryTypeVideo;
        element.videoURL = videoURL;
        element.thumbnailURL = thumbnailURL;
    }
    return element;
}

@end

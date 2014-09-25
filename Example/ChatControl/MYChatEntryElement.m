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
        element.udid = @"ololo";
    }
    return element;
}

+ (instancetype) elementWithImageURL:(NSString *)imageURL andThumbnailURL:(NSString *)thumbnailURL {
    MYChatEntryElement *element = [MYChatEntryElement new];
    
    if (element) {
        element.type = koChatEntryTypePhoto;
        element.sourceURL = [NSURL URLWithString:imageURL];
        element.thumbnailURL = [NSURL URLWithString:thumbnailURL];
        element.udid = @"ololo";
    }
    return element;
}

+ (instancetype) elementWithVideoURL:(NSString *)videoURL andThumbnailURL:(NSString *)thumbnailURL {
    MYChatEntryElement *element = [MYChatEntryElement new];
    
    if (element) {
        element.type = koChatEntryTypeVideo;
        element.sourceURL = [NSURL URLWithString:videoURL];
        element.thumbnailURL = [NSURL URLWithString:thumbnailURL];
        element.udid = @"ololo";
    }
    return element;
}

@end

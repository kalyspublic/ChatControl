//
//  KOChatEntryElement.m
//  Pods
//
//  Created by Kalys Osmonov on 8/7/14.
//
//

#import "KOChatEntryElement.h"

@implementation KOChatEntryElement

+ (instancetype) elementWithText:(NSString *)text {
    KOChatEntryElement *element = [KOChatEntryElement new];
    if (element) {
        element.type = koChatEntryTypeText;
        element.text = text;
    }
    return element;
}

@end

//
//  KOChatEntryElement.h
//  Pods
//
//  Created by Kalys Osmonov on 8/7/14.
//
//

#import <Foundation/Foundation.h>
#import "KOChatEntryDelegate.h"

@interface KOChatEntryElement : NSObject<KOChatElementProtocol>

+ (instancetype) elementWithText:(NSString *)text;

@property (nonatomic, assign) KOChatEntryType type;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) NSURL *sourceURL;
@property (nonatomic, strong) NSString *udid;

@end

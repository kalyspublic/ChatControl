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
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *videoURL;

@end

//
//  KOChatEntry.m
//  ChatControl
//
//  Created by Kalys Osmonov on 7/13/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import "KOChatEntry.h"

@implementation KOChatEntry

@synthesize sendingStatus = _sendingStatus;

- (void) setSendingStatus:(KOMessageStatus)sendingStatus {
    if (self.statusDelegate) {
        [self.statusDelegate statusUpdate:sendingStatus];
    }
    _sendingStatus = sendingStatus;
}

@end

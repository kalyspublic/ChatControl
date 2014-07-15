//
//  ChatDataSource.h
//  ChatControl
//
//  Created by Kalys Osmonov on 7/13/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChatControl/KOChatTableDelegate.h>

@interface ChatDataSource : NSObject<KOChatTableDelegate>

@property (nonatomic, strong) NSArray *entries;

@end

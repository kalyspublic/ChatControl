//
//  MYChatDataSource.h
//  ChatControl
//
//  Created by Kalys Osmonov on 7/17/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import "KOChatDataSource.h"
#import "KOViewController.h"

@interface MYChatDataSource : KOChatDataSource

@property (nonatomic, strong) NSArray *entries;
@property (nonatomic, weak) KOViewController *parentViewController;

@end

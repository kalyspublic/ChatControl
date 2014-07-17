//
//  KOChatTableViewHeader.m
//  Pods
//
//  Created by Kalys Osmonov on 7/17/14.
//
//

#import "KOChatTableViewHeader.h"

@interface KOChatTableViewHeader ()
- (IBAction)loadMoreTap:(id)sender;

@end

@implementation KOChatTableViewHeader

- (IBAction)loadMoreTap:(id)sender {
    [self.delegate koChatTableViewHeader:self loadMoreDidTap:sender];
}

@end

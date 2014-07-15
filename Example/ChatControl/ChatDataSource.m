//
//  ChatDataSource.m
//  ChatControl
//
//  Created by Kalys Osmonov on 7/13/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import "ChatDataSource.h"
#import <ChatControl/KOChatCellView.h>
#import <ChatControl/KOChatEntryDelegate.h>

@implementation ChatDataSource

- (NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entries count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KOChatCellView *cell = (KOChatCellView *) [tableView dequeueReusableCellWithIdentifier:@"chatCell" forIndexPath:indexPath];
    cell.entry = self.entries[indexPath.row];
    cell.bubbleColor = [UIColor redColor];
    return cell;
}

@end
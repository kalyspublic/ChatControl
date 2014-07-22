//
//  MYChatDataSource.m
//  ChatControl
//
//  Created by Kalys Osmonov on 7/17/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import "MYChatDataSource.h"
#import <ChatControl/KOChatCellView.h>
#import <ChatControl/KOChatControlHelper.h>
#import "KOChatEntry.h"

@implementation MYChatDataSource

- (NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entries count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KOChatCellView *cell = (KOChatCellView *) [tableView dequeueReusableCellWithIdentifier:@"KOChatCell"];
    KOChatEntry *entry = self.entries[indexPath.row];
    cell.entry = entry;
    entry.statusDelegate = cell;
    cell.delegate = self.parentViewController;
    
    if (indexPath.row == 2) {
        cell.isDateVisible = YES;
    }

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL dateVisible = indexPath.row == 2;
    return [KOChatControlHelper cellHeight:self.entries[indexPath.row] dateVisible:dateVisible];
}

@end

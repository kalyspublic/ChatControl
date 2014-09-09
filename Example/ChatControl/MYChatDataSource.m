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
#import "MYChatEntry.h"
#import "MYChatCellView.h"

@interface MYChatDataSource ()
@property (nonatomic, strong) NSMutableArray *expandedCellIndexPaths;
@end

@implementation MYChatDataSource

- (instancetype) init {
    self = [super init];
    if (self) {
        self.expandedCellIndexPaths = [NSMutableArray new];
    }
    return self;
}
- (NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entries count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYChatCellView *cell = (MYChatCellView *) [tableView dequeueReusableCellWithIdentifier:@"KOChatCell"];
    MYChatEntry *entry = self.entries[indexPath.row];
    cell.entry = entry;
    cell.delegate = self.parentViewController;
    
    if (indexPath.row == 2) {
        cell.isDateVisible = YES;
    }
    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 6) {
        cell.isOutgoing = YES;
    }

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL dateVisible = indexPath.row == 2;
    BOOL spamExpanded = [self.expandedCellIndexPaths containsObject:indexPath];
    return [KOChatControlHelper cellHeight:self.entries[indexPath.row] dateVisible:dateVisible spamExpanded:spamExpanded];
}

- (void) tableView:(UITableView *)tableView expandOrCollapseCell:(KOChatCellView *)cell {
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    if([cell.entry isSpamed]) {
        if ([self.expandedCellIndexPaths containsObject:indexPath]) {
            [self.expandedCellIndexPaths removeObject:indexPath];
        } else {
            [self.expandedCellIndexPaths addObject:indexPath];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end

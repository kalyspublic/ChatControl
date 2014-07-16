//
//  KOViewController.m
//  ChatControl
//
//  Created by Kalys Osmonov on 07/08/2014.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import <ChatControl/KOChatViewController.h>
#import <ChatControl/KOChatTableDelegate.h>
#import <ChatControl/KOChatCellView.h>
#import <ChatControl/KOChatEntryDelegate.h>
#import <EDHexColor/UIColor+EDHexColor.h>
#import "KOViewController.h"
#import "KOChatEntry.h"

@interface KOViewController ()

@property (nonatomic, strong) NSArray *entries;
@property (nonatomic, strong) NSArray *bubbleColors;

@end

@implementation KOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.entries = [self prepareChatEntries];
    self.bubbleColors = @[@"def4c4", @"c4eaf5", @"ffffff"];
    
    KOChatViewController *chatVC = [[KOChatViewController alloc] init];
    chatVC.tableDelegate = self;
    chatVC.messageFormDelegate = self;
    chatVC.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    [self.navigationController pushViewController:chatVC animated:NO];
}

- (NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entries count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KOChatCellView *cell = (KOChatCellView *) [tableView dequeueReusableCellWithIdentifier:@"KOChatCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KOChatCellView" owner:self options:nil] firstObject];
    }
    cell.entry = self.entries[indexPath.row];
    if (indexPath.row == 1) {
        cell.isDateVisible = YES;
    }
    cell.bubbleColor = [UIColor colorWithHexString: self.bubbleColors[indexPath.row % 3]];

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<KOChatEntryDelegate> entry = self.entries[indexPath.row];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGRect rect = [[entry text] boundingRectWithSize:CGSizeMake(240, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    float cellHeight = rect.size.height + 48;
    if (indexPath.row == 1) {
        cellHeight += 16;
    }

    if ([[entry likesCount] integerValue] != 0 || [[entry dislikesCount] integerValue] != 0) {
        cellHeight += 20;
    }
    return cellHeight;
}

- (void) sendButtonTouched:(id)sender textField:(UITextView *)textField {
    
}

- (void) cameraButtonTouched:(id)sender {
    
}

- (NSArray *) prepareChatEntries {
    KOChatEntry *entry = [KOChatEntry new];
    entry.text = @"Hello.\nHow are you?";
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    KOChatEntry *entry1 = entry;

    entry = [KOChatEntry new];
    entry.text = @"Hey!\nHey!\nHey!\nHey!\nHey!\nHey!\nHey!\nHey!\nHey!";
    entry.isOutgoing = NO;
    entry.isBookmarked = YES;
    entry.username = @"Misha Sytchev";
    entry.date = @"Today";
    entry.time = @"12:44";
    entry.likesCount = @10;
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    KOChatEntry *entry2 = entry;

    entry = [KOChatEntry new];
    entry.text = @"Hello.\nHow are you?";
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    entry.dislikesCount = @5;
    KOChatEntry *entry3 = entry;
    
    entry = [KOChatEntry new];
    entry.text = @"Hello.\nHow are you?";
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    entry.likesCount = @23;
    entry.dislikesCount = @5;
    KOChatEntry *entry4 = entry;
    
    entry = [KOChatEntry new];
    entry.text = @"Hello.\nHow are you?";
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    entry.likesCount = @23;
    entry.dislikesCount = @5;
    entry.isSpamed = YES;
    KOChatEntry *entry5 = entry;
    
    //KOChatEntry *entry3 = [KOChatEntry new];
    return @[entry1, entry2, entry3, entry4, entry5];//, entry2, entry3];
}

@end

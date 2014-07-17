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
#import <ChatControl/KOChatControlHelper.h>
#import <EDHexColor/UIColor+EDHexColor.h>
#import "KOViewController.h"
#import "KOChatEntry.h"

@interface KOViewController ()

@property (nonatomic, strong) NSArray *entries;
@property (nonatomic, strong) NSArray *bubbleColors;
@property (nonatomic, strong) KOChatEntry *testEntry;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *testButton;

@end

@implementation KOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.entries = [self prepareChatEntries];
    
    KOChatViewController *chatVC = [[KOChatViewController alloc] init];
    chatVC.tableDelegate = self;
    chatVC.messageFormDelegate = self;
    chatVC.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    chatVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStyleDone target:self action:@selector(testButton:)];
    [self.navigationController pushViewController:chatVC animated:NO];
}

- (void) testButton:(id) sender {
    if (self.testEntry.sendingStatus == koMessageStatusSending) {
        self.testEntry.sendingStatus = koMessageStatusSuccessful;
    } else {
        self.testEntry.sendingStatus = koMessageStatusSending;
    }
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

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KOChatControlHelper cellHeight:self.entries[indexPath.row]];
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
    entry.text = @"I found a contacts of your studio on the internetz. I'm looking for a a talents who will develop me an iOS application that will have a chat listing that will have a cell that will have a text view that will support various orientaton and handle text width correctly. That's it.";
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    entry.dislikesCount = @5;
    KOChatEntry *entry3 = entry;
    self.testEntry = entry3;
    
    entry = [KOChatEntry new];
    entry.text = @"Hello.\nHow are you?";
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    entry.likesCount = @230;
    entry.dislikesCount = @500;
    entry.showDate = YES;
    KOChatEntry *entry4 = entry;
    
    entry = [KOChatEntry new];
    entry.text = @"Hello.\nHow are you?";
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    entry.likesCount = @2;
    entry.dislikesCount = @5;
    KOChatEntry *entry41 = entry;
    
    entry = [KOChatEntry new];
    entry.text = @"Hello.\nHow are you?";
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    entry.likesCount = @0;
    entry.dislikesCount = @50;
    entry.isSpamed = YES;
    KOChatEntry *entry5 = entry;
    
    //KOChatEntry *entry3 = [KOChatEntry new];
    return @[entry1, entry2, entry3, entry4, entry41, entry5];//, entry2, entry3];
}

@end

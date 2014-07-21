//
//  KOViewController.m
//  ChatControl
//
//  Created by Kalys Osmonov on 07/08/2014.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import <ChatControl/KOChatEntryDelegate.h>
#import <EDHexColor/UIColor+EDHexColor.h>
#import "KOViewController.h"
#import "KOChatEntry.h"
#import "MYChatDataSource.h"
#import "KOOloloViewController.h"

@interface KOViewController ()

@property (nonatomic, strong) NSArray *entries;
@property (nonatomic, strong) NSArray *bubbleColors;
@property (nonatomic, strong) KOChatEntry *testEntry;
@property (nonatomic, strong) MYChatDataSource *chatDataSource;
@property (nonatomic, strong) KOChatViewController *chatVC;
@end

@implementation KOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // dataSource has to be retained.
    self.chatDataSource = [MYChatDataSource new];
    self.chatDataSource.parentViewController = self;
    self.chatDataSource.entries = [self prepareChatEntries];
    
    // chat VC init code
    self.chatVC = [[KOOloloViewController alloc] initWithNibName:@"KOChatViewController" bundle:nil];
    self.chatVC.messageFormDelegate = self;
    self.chatVC.delegate = self;

    self.chatVC.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.chatVC.tableView.dataSource = self.chatDataSource;
    self.chatVC.tableView.delegate = self.chatDataSource;
    // end of chat VC init code
    
    self.chatVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStyleDone target:self action:@selector(testButton:)];
    
    [self.chatVC showLoadMore];
    [self.navigationController pushViewController:self.chatVC animated:NO];
}

- (void) testButton:(id) sender {
    if (self.testEntry.sendingStatus == koMessageStatusSending) {
        self.testEntry.sendingStatus = koMessageStatusSuccessful;
        [self.chatVC showLoadMore];
        [self.chatVC hideJoin];
    } else {
        self.testEntry.sendingStatus = koMessageStatusSending;
        [self.chatVC hideLoadMore];
        [self.chatVC showJoin];
    }
}

- (void) sendButtonTouched:(id)sender textField:(UITextView *)textField {
    NSLog(@"Send button %@", textField);
}

- (void) cameraButtonTouched:(id)sender {
    NSLog(@"Camera button tap");
}

- (void) koChatViewController:(KOChatViewController *)koChatViewController joinDidTap:(id)sender {
    NSLog(@"Join tapped");
}

- (void) koChatViewController:(KOChatViewController *)koChatViewController loadMoreDidTap:(id)sender {
    NSLog(@"Load more tapped");
}

- (void) koChatCellView:(KOChatCellView *)cell photoTap:(id<KOChatEntryProtocol>)model sender:(id)sender {
    NSLog(@"%@", model);
}

- (NSArray *) prepareChatEntries {
    KOChatEntry *entry = [KOChatEntry new];
    entry.type = koChatEntryTypeText;
    entry.text = @"Hello.\nHow are you?";
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    KOChatEntry *entry1 = entry;

    entry = [KOChatEntry new];
    entry.type = koChatEntryTypeText;
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
    entry.type = koChatEntryTypeText;
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
    entry.type = koChatEntryTypePhoto;
    entry.thumbnailURL = @"http://i.imgur.com/G5w2iCk.jpg";
    entry.username = @"Misha Sytchev";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    entry.likesCount = @2;
    entry.showDate = YES;
    KOChatEntry *entry4 = entry;
    
    entry = [KOChatEntry new];
    entry.type = koChatEntryTypeVideo;
    entry.thumbnailURL = @"http://i.imgur.com/yBZozU4.jpg";
    entry.username = @"Misha Sytchev";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    entry.likesCount = @2;
    entry.showDate = YES;
    KOChatEntry *entry405 = entry;
    
    entry = [KOChatEntry new];
    entry.type = koChatEntryTypeText;
    entry.text = @"Hello.\nHow are you?";
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    entry.likesCount = @230;
    entry.dislikesCount = @5;
    KOChatEntry *entry41 = entry;
    
    entry = [KOChatEntry new];
    entry.type = koChatEntryTypeText;
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

    return @[entry1, entry2, entry3, entry4,entry405, entry41, entry5];
}

@end

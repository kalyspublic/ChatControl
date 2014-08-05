//
//  KOViewController.m
//  ChatControl
//
//  Created by Kalys Osmonov on 07/08/2014.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import <ChatControl/KOChatEntryDelegate.h>
#import <ChatControl/KOChatControlHelper.h>
#import <ChatControl/KOTextAttachment.h>
#import <EDHexColor/UIColor+EDHexColor.h>
#import "MYViewController.h"
#import "MYChatEntry.h"
#import "MYChatDataSource.h"
#import "KOOloloViewController.h"

@interface MYViewController ()

@property (nonatomic, strong) NSArray *entries;
@property (nonatomic, strong) NSArray *bubbleColors;
@property (nonatomic, strong) MYChatEntry *testEntry;
@property (nonatomic, strong) MYChatDataSource *chatDataSource;
@property (nonatomic, strong) KOChatViewController *chatVC;
@end

@implementation MYViewController

- (void) viewDidAppear:(BOOL)animated {
    self.chatVC = nil;
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // dataSource has to be retained.
    self.chatDataSource = [MYChatDataSource new];
    self.chatDataSource.parentViewController = self;
    self.chatDataSource.entries = [self prepareChatEntries];
    
    // chat VC init code
    self.chatVC = [[KOOloloViewController alloc] initWithNibName:@"KOChatViewController" bundle:nil];
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
        [self.chatVC showInput];
        //[self.chatVC showLoadMore];
        //[self.chatVC hideJoin];
    } else if (self.testEntry.sendingStatus == koMessageStatusSuccessful) {
        self.testEntry.sendingStatus = koMessageStatusError;
        //[self.chatVC hideLoadMore];
        //[self.chatVC showJoin];
    } else {
        self.testEntry.sendingStatus = koMessageStatusSending;
        [self.chatVC hideInput];
    }
}

- (void) koChatCellView:(KOChatCellView *)cell avatarTap:(id<KOChatEntryProtocol>)model sender:(id)sender {
    NSLog(@"avatar tap");
}

- (void) koChatViewController:(KOChatViewController *)koChatViewController sendButtonTouched:(id)sender textField:(UITextView *)textField {
    NSLog(@"Send button %@", textField);
    NSArray *elements = koChatViewController.textViewElements;
    NSLog(@"%@", elements);
    UIImage *originalImage = elements.lastObject;
    [koChatViewController finishSending];
}

- (void) koChatViewController:(KOChatViewController *)koChatViewController cameraButtonTouched:(id)sender textField:(UITextView *)textField {
    [koChatViewController appendImageToTextView:[UIImage imageNamed:@"photo1.jpg"] withImageIdentifier:@"ololo"];
    [textField becomeFirstResponder];
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

- (void) koChatCellView:(KOChatCellView *)cell errorCellTap:(id<KOChatEntryProtocol>)model sender:(id)sender {
    NSLog(@"error cell tap %@", cell);
}

- (void) koChatCellView:(KOChatCellView *)cell didLongPress:(id<KOChatEntryProtocol>)model sender:(id)sender {
    NSLog(@"Long tap");
}

- (BOOL) koChatCellView:(KOChatCellView *)cell canPerformAction:(SEL)action withSender:(id)sender {
    NSLog(@"can perform action");
    return YES;
}

- (NSArray *) prepareChatEntries {
    MYChatEntry *entry = [MYChatEntry new];
    entry.type = koChatEntryTypeText;
    entry.content = @[@"Hello.\nHow are you?", [UIImage imageNamed:@"photo1.jpg"], @"Lol.", @"It works"];
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    MYChatEntry *entry1 = entry;
    
    entry = [MYChatEntry new];
    entry.type = koChatEntryTypeText;
    entry.content = @[@"Hello.\nHow are you?", [UIImage imageNamed:@"photo1.jpg"], @"Lol.", @"It works"];
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    MYChatEntry *entry2 = entry;
    
    entry = [MYChatEntry new];
    entry.type = koChatEntryTypeText;
    entry.content = @[@"Hello.\nHow are you?", [UIImage imageNamed:@"photo1.jpg"], @"Lol.", @"It works"];
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    MYChatEntry *entry3 = entry;
    
    entry = [MYChatEntry new];
    entry.type = koChatEntryTypeText;
    entry.content = @[@"Hello.\nHow are you?", [UIImage imageNamed:@"photo1.jpg"], @"Lol.", @"It works"];
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    MYChatEntry *entry4 = entry;
    
    entry = [MYChatEntry new];
    entry.type = koChatEntryTypeText;
    entry.content = @[@"Hello.\nHow are you?", [UIImage imageNamed:@"photo1.jpg"], @"Lol.", @"It works"];
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    MYChatEntry *entry5 = entry;
    
    entry = [MYChatEntry new];
    entry.type = koChatEntryTypeText;
    entry.content = @[@"Hello.\nHow are you?", [UIImage imageNamed:@"photo1.jpg"], @"Lol.", @"It works"];
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    MYChatEntry *entry6 = entry;
    
    entry = [MYChatEntry new];
    entry.type = koChatEntryTypeText;
    entry.content = @[@"Hello.\nHow are you?", [UIImage imageNamed:@"photo1.jpg"], @"Lol.", @"It works"];
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    MYChatEntry *entry7 = entry;
    

    return @[entry1, entry2, entry3, entry4, entry5, entry6, entry7];
}

@end

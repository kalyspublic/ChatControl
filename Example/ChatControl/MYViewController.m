//
//  KOViewController.m
//  ChatControl
//
//  Created by Kalys Osmonov on 07/08/2014.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import <ChatControl/KOChatEntryDelegate.h>
#import <ChatControl/KOTextAttachment.h>
#import <EDHexColor/UIColor+EDHexColor.h>
#import "MYViewController.h"
#import "MYChatEntry.h"
#import "MYChatDataSource.h"
#import "KOOloloViewController.h"
#import "MYChatEntryElement.h"
#import "MYTestViewController.h"

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

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    [self.chatVC appendImageElementToTextView:[MYChatEntryElement elementWithImageURL:@"http://i.imgur.com/krDidy9.png" andThumbnailURL:@"http://i.imgur.com/krDidy9.png   "]];

    [picker dismissViewControllerAnimated:YES completion:^{
        [self.chatVC updateTextFieldFrame];
    }];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) testButton:(id) sender {
    //MYTestViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"testVC"];
    //[self presentViewController:vc animated:YES completion:nil];
    /*
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
    }*/
}

- (void) koChatCellView:(KOChatCellView *)cell avatarTap:(id<KOChatEntryProtocol>)model sender:(id)sender {
    NSLog(@"avatar tap");
}

- (void) koChatViewController:(KOChatViewController *)koChatViewController sendButtonTouched:(id)sender textViewElements:(NSArray *)elements {
    NSLog(@"%@", elements);
    [koChatViewController finishSending];
}

- (void) koChatViewController:(KOChatViewController *)koChatViewController cameraButtonTouched:(id)sender textField:(UITextView *)textField {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    /*
    [koChatViewController appendImageElementToTextView:[MYChatEntryElement elementWithImageURL:@"http://i.imgur.com/krDidy9.png" andThumbnailURL:@"http://i.imgur.com/krDidy9.png   "] withThumbnail:[UIImage imageNamed:@"test"]];
    [textField becomeFirstResponder];
    NSLog(@"Camera button tap");
     */
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

- (void) koChatCellView:(KOChatCellView *)cell mediaTapOnElement:(id<KOChatElementProtocol>)element model:(id<KOChatEntryProtocol>)model sender:(id)sender {
    NSLog(@"%@ %@ %@ %@", cell, element, model, sender);
}

- (NSArray *) prepareChatEntries {
    
    MYChatEntry *entry = [MYChatEntry new];
    entry.content = @[
        [MYChatEntryElement elementWithText: @"Hello.\nHow are you?"],
        [MYChatEntryElement elementWithText: @"Hey.\nI'm fine. And here go very long text. A superconducting version of the EmDrive, would, in principle, generate thousands of times more thrust. And because it does not require energy just to hold things up (just as a chair does not require power to keep you off the ground), in theory you could have a hoverboard which does not require energy to float in the air."],
        [MYChatEntryElement elementWithImageURL:@"http://i.imgur.com/krDidy9.png" andThumbnailURL:@"http://i.imgur.com/krDidy9.png"],
         [MYChatEntryElement elementWithVideoURL:@"http://i.imgur.com/krDidy9.png" andThumbnailURL:@"http://i.imgur.com/krDidy9.png"]
    ];
    entry.isOutgoing = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    MYChatEntry *entry1 = entry;
    
    entry = [MYChatEntry new];
    entry.content = @[
                      [MYChatEntryElement elementWithImageURL:@"http://i.imgur.com/krDidy9.png" andThumbnailURL:@"http://i.imgur.com/krDidy9.png"],
                      [MYChatEntryElement elementWithText: @"Hello.\nHow are you?"],
                      [MYChatEntryElement elementWithText: @"Hey.\nI'm fine. And here go very long text. A superconducting version of the EmDrive, would, in principle, generate thousands of times more thrust. And because it does not require energy just to hold things up (just as a chair does not require power to keep you off the ground), in theory you could have a hoverboard which does not require energy to float in the air."],

                      [MYChatEntryElement elementWithVideoURL:@"http://i.imgur.com/krDidy9.png" andThumbnailURL:@"http://i.imgur.com/krDidy9.png"]
                      ];
    entry.isSpamed = YES;
    entry.username = @"Kalys Osmonov";
    entry.time = @"11:30";
    entry.date = @"Today";
    entry.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    entry.likesCount = 50;
    MYChatEntry *entry2 = entry;

    return @[entry1, entry2];
}

- (void) koChatCellView:(KOChatCellView *)cell usernameTap:(id<KOChatEntryProtocol>)model sender:(id)sender {
    NSLog(@"username tap");
}

- (void) koChatCellView:(KOChatCellView *)cell expandOrCollapseSpammedMessage:(id<KOChatEntryProtocol>)model {
    [self.chatDataSource tableView:self.chatVC.tableView expandOrCollapseCell:cell];
}

@end

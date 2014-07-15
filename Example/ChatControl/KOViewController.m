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
    CGRect rect = [[entry text] boundingRectWithSize:CGSizeMake(229, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    float cellHeight = rect.size.height + 54;
    if (indexPath.row == 1) {
        cellHeight += 16;
    }
    return cellHeight;
}

- (void) sendButtonTouched:(id)sender textField:(UITextView *)textField {
    
}

- (void) cameraButtonTouched:(id)sender {
    
}

- (NSArray *) prepareChatEntries {
    KOChatEntry *entry1 = [KOChatEntry new];
    entry1.text = @"Hello.\nHow are you?";
    entry1.isOutgoing = YES;
    entry1.username = @"Kalys";
    entry1.time = @"11:30";
    entry1.date = @"Today";
    entry1.likesCount = @10;
    entry1.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";

    KOChatEntry *entry2 = [KOChatEntry new];
    entry2.text = @"Hey!\nHey!\nHey!\nHey!\nHey!\nHey!\nHey!\nHey!\nHey!";
    entry2.isOutgoing = YES;
    entry2.username = @"Misha";
    entry2.date = @"Today";
    entry2.time = @"12:44";
    entry2.likesCount = @10;
    entry2.avatarPath = @"http://i.imgur.com/Nc8CsUI.png";
    
    //KOChatEntry *entry3 = [KOChatEntry new];
    return @[entry1, entry2, entry1, entry1, entry1];//, entry2, entry3];
}

@end

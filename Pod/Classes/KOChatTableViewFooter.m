//
//  KOChatTableViewFooter.m
//  Pods
//
//  Created by Kalys Osmonov on 7/18/14.
//
//

#import "KOChatTableViewFooter.h"
#import <QuartzCore/QuartzCore.h>

@interface KOChatTableViewFooter ()

- (IBAction) joinTap:(id)sender;
@property (nonatomic, weak) IBOutlet UIButton *joinButton;
@end

@implementation KOChatTableViewFooter

- (void) awakeFromNib {
    [super awakeFromNib];
    self.joinButton.layer.cornerRadius = 8;
}

- (IBAction) joinTap:(id)sender {
    [self.delegate koChatTableViewFooter:self joinDidTap:sender];
}

@end
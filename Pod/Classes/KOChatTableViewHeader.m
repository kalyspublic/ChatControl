//
//  KOChatTableViewHeader.m
//  Pods
//
//  Created by Kalys Osmonov on 7/17/14.
//
//

#import "KOChatTableViewHeader.h"

@interface KOChatTableViewHeader ()
- (IBAction)loadMoreTap:(id)sender;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation KOChatTableViewHeader

- (IBAction)loadMoreTap:(id)sender {
    [self.delegate koChatTableViewHeader:self loadMoreDidTap:sender];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

@end

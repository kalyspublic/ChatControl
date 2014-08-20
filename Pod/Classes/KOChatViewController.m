//
//  KOChatViewController.m
//  Pods
//
//  Created by Kalys Osmonov on 7/10/14.
//
//
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <EDHexColor/UIColor+EDHexColor.h>
#import <UIImage-Resize/UIImage+Resize.h>
#import "GCPlaceholderTextView.h"
#import "KOTextAttachment.h"
#import "KOChatEntryElement.h"

#import "KOChatViewController.h"

#define KOMessageFrameHeight 42.0


@interface KOChatViewController ()
- (IBAction)cameraTap:(id)sender;
- (IBAction)sendtap:(id)sender;

@property (nonatomic, weak) IBOutlet UIView *keyboardAccessoryView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *keyboardAccessoryViewHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *keyboardAccessoryViewBottom;
@property (nonatomic, weak) IBOutlet GCPlaceholderTextView *messageTextField;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) RACSubject *messageTextFieldUpdateSignal;

@property (assign) BOOL isLoadMoreVisible;
@property (assign) BOOL isJoinVisible;
@property (assign) BOOL isKeyboardActive;
@end

@implementation KOChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"KOChatCellView"
                                               bundle:nil] forCellReuseIdentifier:@"KOChatCell"];
    
    self.messageTextField.placeholder = @"Write a comment";
    self.messageTextField.delegate = self;
    [self configureMessageTextField];
    self.messageTextFieldUpdateSignal = [RACSubject subject];
    
    RACSignal *messageTextFieldUpdated = [RACSignal merge:@[self.messageTextField.rac_textSignal, self.messageTextFieldUpdateSignal]];
    RAC(self.sendButton, enabled) = [messageTextFieldUpdated map:^id(NSString *value) {
        return @(![value isEqualToString:@""] && ![value isEqualToString:@"Write a comment"]);
    }];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInputControls)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    [self registerForKeyboardNotifications];
    [self hideJoin];
    [self hideLoadMore];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.tableView.tableHeaderView.hidden = YES;
    [self setTextViewFrame:toInterfaceOrientation];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.tableView.tableHeaderView.hidden = NO;
    [self calculateTableViewInsets];
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        self.tableView.tableFooterView.frame = CGRectMake(0, 0, 568, 64);
    } else {
        self.tableView.tableFooterView.frame = CGRectMake(0, 0, 320, 64);
    }
    
    [self.tableView reloadData];
}

- (void) dismissInputControls {
    [self.view endEditing:YES];
}

- (void) registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

- (void) keyboardWillShow:(NSNotification *)notification {
    self.isKeyboardActive = YES;
    [self setTextViewFrame:self.interfaceOrientation];
    [self animateMessageFrame:notification];
}

- (void) keyboardWillHide:(NSNotification *)notification {
    self.isKeyboardActive = NO;
    [self setTextViewFrame:self.interfaceOrientation];
    [self animateMessageFrame:notification];
}

- (void) keyboardDidShow:(NSNotification *)notification {
    [self calculateTableViewInsets];
}

- (void) keyboardDidHide:(NSNotification *)notification {
    [self calculateTableViewInsets];
}

- (void) animateMessageFrame:(NSNotification *) notification {
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGRect convertedRect = [self.view convertRect:keyboardRect fromView:nil];
    
    if (convertedRect.origin.y == 568) {
        convertedRect.origin.y = 504;
    }
    
    NSInteger animationCurveOption = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    self.keyboardAccessoryViewBottom.constant = self.view.frame.size.height - convertedRect.origin.y;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:animationCurveOption
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (void) showLoadMore {
    self.tableView.tableHeaderView = (KOChatTableViewHeader *)[[[NSBundle mainBundle] loadNibNamed:@"KOChatTableViewHeader" owner:self options:nil] firstObject];
    self.isLoadMoreVisible = YES;
    ((KOChatTableViewHeader *)self.tableView.tableHeaderView).delegate = self;
    [self calculateTableViewInsets];
}

- (void) hideLoadMore {
    self.isLoadMoreVisible = NO;
    self.tableView.tableHeaderView = nil;
    [self calculateTableViewInsets];
}

- (void) showJoin {
    self.tableView.tableFooterView = (KOChatTableViewHeader *)[[[NSBundle mainBundle] loadNibNamed:@"KOChatTableViewFooter" owner:self options:nil] firstObject];
    ((KOChatTableViewFooter *)self.tableView.tableFooterView).delegate = self;

    self.keyboardAccessoryViewBottom.constant = -KOMessageFrameHeight;
//    self.tableViewBottom.constant = 0.0;
//    [self calculateTableViewInsets];
}

- (void) hideJoin {
    self.tableView.tableFooterView = nil;
    self.keyboardAccessoryViewBottom.constant = 0;
//    self.tableViewBottom.constant = 42.0;
//    [self calculateTableViewInsets];
}

- (void) showInput {
    self.keyboardAccessoryViewBottom.constant = 0;
}

- (void) hideInput {
    self.keyboardAccessoryViewBottom.constant = -KOMessageFrameHeight;
}

- (void) calculateTableViewInsets {
    // table view insets depend on orientation, 'load more' visibility, 'join' visibility
    CGFloat topInset, bottomInset = 2, keyboardTopInset = 0.0, keyboardBottomInset = 2;
    
    // CGRect navBarRect = self.navigationController.navigationBar.frame;
    keyboardTopInset = topInset = 0; //navBarRect.origin.y + navBarRect.size.height;
    
    if (!self.isLoadMoreVisible) {
        topInset += 4;
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(topInset, 0.0, bottomInset, 0.0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(keyboardTopInset, 0.0, keyboardBottomInset, 0.0);
}

- (void) koChatTableViewHeader:(KOChatTableViewHeader *)koChatTableViewHeader loadMoreDidTap:(id)sender {
    [self.delegate koChatViewController:self loadMoreDidTap:sender];
}

- (void) koChatTableViewFooter:(KOChatTableViewFooter *)koChatTableViewFooter joinDidTap:(id)sender {
    [self.delegate koChatViewController:self joinDidTap:sender];
}

- (IBAction)cameraTap:(id)sender {
    //[self unregiserKeyboardNotifications];
    [self.delegate koChatViewController:self cameraButtonTouched:sender textField:self.messageTextField];
}

- (IBAction)sendtap:(id)sender {
    [self.delegate koChatViewController:self sendButtonTouched:sender textViewElements:[self textViewElements]];
}

- (void) textViewDidChange:(UITextView *)textView {
    [self setTextViewFrame:self.interfaceOrientation];
}

- (void) setTextViewFrame:(UIInterfaceOrientation) orientation {
    CGSize textViewContentSize = self.messageTextField.contentSize;

    CGFloat limit, newHeight;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        limit = 100;
    } else {
        limit = 200;
    }
    
    if (textViewContentSize.height < limit) {
        newHeight = textViewContentSize.height + 12;
    } else {
        newHeight = limit;
    }
    
    if (self.keyboardAccessoryView.frame.size.height > limit) {
        newHeight = limit;
    }
    
    if (!self.isKeyboardActive) {
        newHeight = KOMessageFrameHeight;
        self.messageTextField.contentOffset = CGPointZero;
    }
    
    self.keyboardAccessoryViewHeight.constant = newHeight;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (void) finishSending {
    self.messageTextField.text = @"";
    [self.messageTextFieldUpdateSignal sendNext:@""];
    [self updateTextFieldFrameWithDelay];
}

- (void) unregiserKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (void) dealloc {
    [self unregiserKeyboardNotifications];
    [self.messageTextFieldUpdateSignal sendCompleted];
}

- (void) updateTextFieldFrame {
    [self setTextViewFrame:self.interfaceOrientation];
}

- (void) updateTextFieldFrameWithDelay {
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateTextFieldFrame) userInfo:nil repeats:NO];
}

- (NSArray *) textViewElements {
    NSAttributedString *attributedString = self.messageTextField.attributedText;
    
    NSMutableArray *elements = [NSMutableArray new];
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (![[[attributedString string] substringWithRange:range] isEqualToString:@"\n"]) {
            if ([attrs.allKeys containsObject:@"NSAttachment"]) {
                KOTextAttachment *textAttachment = [attrs objectForKey:@"NSAttachment"];
                
                [elements addObject: textAttachment.element];
            } else {
                [elements addObject:[KOChatEntryElement elementWithText:[[attributedString string] substringWithRange:range]]];
            }
        }
    }];
    return elements;
}

- (void) appendImageElementToTextView:(id<KOChatElementProtocol>)element withThumbnail:(UIImage *)image {
    [self.messageTextField clearPlaceholder];
    
    NSMutableAttributedString *attrString = [self.messageTextField.attributedText mutableCopy];
    
    if (![self.messageTextField.text isEqualToString:@""]) {
        NSAttributedString *textAttrString = [[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
        [attrString appendAttributedString:textAttrString];
    }
    
    KOTextAttachment *textAttachment = [[KOTextAttachment alloc] init];
    
    textAttachment.image = [image resizedImageToFitInSize:CGSizeMake(205, 114) scaleIfSmaller:NO];
    textAttachment.element = element;
    NSMutableAttributedString *imageAttrString = [[NSAttributedString attributedStringWithAttachment:textAttachment] mutableCopy];
    
    [attrString appendAttributedString:imageAttrString];
    NSAttributedString *textAttrString = [[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
    [attrString appendAttributedString:textAttrString];
    self.messageTextField.attributedText = attrString;
    [self.messageTextFieldUpdateSignal sendNext:@"append photo"];
    [self updateTextFieldFrameWithDelay];
}

- (void) focusInput {
    [self.messageTextField becomeFirstResponder];
}

- (void) enableSendButton {
    self.sendButton.enabled = YES;
}

- (void) disableSendButton {
    self.sendButton.enabled = NO;
}

- (void) configureMessageTextField {
    self.messageTextField.layer.borderWidth = 1;
    self.messageTextField.layer.borderColor = [UIColor colorWithHexString:@"DCDCDC"].CGColor;
    self.messageTextField.layer.cornerRadius = 5;
}

@end

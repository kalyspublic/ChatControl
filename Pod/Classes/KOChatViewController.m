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
#import "GCPlaceholderTextView.h"

#import "KOChatViewController.h"

#define KOMessageFrameHeight 42.0


@interface KOChatViewController ()
- (IBAction)cameraTap:(id)sender;
- (IBAction)sendtap:(id)sender;

@property (nonatomic, weak) IBOutlet UIView *keyboardAccessoryView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *keyboardAccessoryViewHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *keyboardAccessoryViewBottom;
@property (nonatomic, weak) IBOutlet GCPlaceholderTextView *messageTextField;

@property (assign) BOOL isLoadMoreVisible;
@property (assign) BOOL isJoinVisible;
@property (assign) BOOL isKeyboardActive;
@end

@implementation KOChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.messageTextField.placeholder = @"Write a comment";
    [self.tableView registerNib:[UINib nibWithNibName:@"KOChatCellView"
                                               bundle:nil] forCellReuseIdentifier:@"KOChatCell"];
    self.messageTextField.delegate = self;
    
    self.messageTextField.layer.borderWidth = 1;
    self.messageTextField.layer.borderColor = [UIColor colorWithHexString:@"DCDCDC"].CGColor;
    self.messageTextField.layer.cornerRadius = 5;

    
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
    [self.messageFormDelegate cameraButtonTouched:sender];
}

- (IBAction)sendtap:(id)sender {
    [self.messageFormDelegate sendButtonTouched:sender textField:self.messageTextField];
}

- (void) textViewDidChange:(UITextView *)textView {
    [self setTextViewFrame:self.interfaceOrientation];
}

- (void) setTextViewFrame:(UIInterfaceOrientation) orientation {
    NSString *text = [self.messageTextField.text stringByAppendingString:@"\naeou"];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(self.messageTextField.frame.size.width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];

    CGFloat limit, newHeight;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        limit = 100;
    } else {
        limit = 200;
    }
    
    if (rect.size.height < limit) {
        newHeight = rect.size.height + 12;
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
    [self setTextViewFrame:self.interfaceOrientation];
}


- (void) dealloc {
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

@end

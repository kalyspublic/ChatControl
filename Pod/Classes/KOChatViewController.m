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
#import <GCPlaceholderTextView/GCPlaceholderTextView.h>

#import "KOChatViewController.h"
#import "KOKeyboardAccessoryView.h"


@interface KOChatViewController ()
- (IBAction)cameraTap:(id)sender;
- (IBAction)sendtap:(id)sender;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (nonatomic, weak) IBOutlet UIView *keyboardAccessoryView;
@property (nonatomic, weak) IBOutlet GCPlaceholderTextView *messageTextField;

@property (assign) BOOL isLoadMoreVisible;
@property (assign) BOOL isJoinVisible;
@property (assign) CGSize keyboardSize;
@end

@implementation KOChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"KOChatCellView"
                                               bundle:nil] forCellReuseIdentifier:@"KOChatCell"];
    self.messageTextField.delegate = self;
    
    self.messageTextField.layer.borderWidth = 1;
    self.messageTextField.layer.borderColor = [UIColor colorWithHexString:@"DCDCDC"].CGColor;
    self.messageTextField.layer.cornerRadius = 5;

    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInputControls)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    [self registerForKeyboardNotifications];
//
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(orientationChanged:)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void) dismissInputControls {
    [self.view endEditing:YES];
}

- (void) setBackgroundImage:(UIImage *)backgroundImage {
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
}

- (void) registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillShow:(NSNotification *)notification {
    [self animateMessageFrame:notification];
}

- (void) keyboardWillHide:(NSNotification *)notification {
    [self animateMessageFrame:notification];
}

- (void) animateMessageFrame:(NSNotification *) notification {
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convertedRect = [self.view convertRect:keyboardRect fromView:nil];
    CGRect newFrame = self.keyboardAccessoryView.frame;
    NSInteger animationCurveOption = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    newFrame.origin = CGPointMake(convertedRect.origin.x, convertedRect.origin.y - newFrame.size.height);
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:animationCurveOption
                     animations:^{
                         self.keyboardAccessoryView.frame = newFrame;
                     }
                     completion:nil];
}

/*
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidChangeFrameNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}*/

//- (void) keyboardDidChangeFrame:(NSNotification *) aNotification {
//    NSDictionary* info = [aNotification userInfo];
//    CGRect keyboardRect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect convertedRect = [self.view convertRect:keyboardRect fromView:nil];
//    self.keyboardSize = convertedRect.size;
//    [self calculateTableViewInsets];
//}

- (void) showLoadMore {
    self.tableView.tableHeaderView = (KOChatTableViewHeader *)[[[NSBundle mainBundle] loadNibNamed:@"KOChatTableViewHeader" owner:self options:nil] firstObject];
    self.isLoadMoreVisible = YES;
    ((KOChatTableViewHeader *)self.tableView.tableHeaderView).delegate = self;
//    [self calculateTableViewInsets];
}

- (void) hideLoadMore {
    self.isLoadMoreVisible = NO;
    self.tableView.tableHeaderView = nil;
//    [self calculateTableViewInsets];
}

- (void) showJoin {
    self.tableView.tableFooterView = (KOChatTableViewHeader *)[[[NSBundle mainBundle] loadNibNamed:@"KOChatTableViewFooter" owner:self options:nil] firstObject];
    ((KOChatTableViewFooter *)self.tableView.tableFooterView).delegate = self;
    self.keyboardAccessoryView.hidden = YES;
//    self.tableViewBottom.constant = 0.0;
//    [self calculateTableViewInsets];
}

- (void) hideJoin {
    self.tableView.tableFooterView = nil;
    self.keyboardAccessoryView.hidden = NO;
//    self.tableViewBottom.constant = 42.0;
//    [self calculateTableViewInsets];
}

//- (void) calculateTableViewInsets {
//    CGFloat topInset;
//    CGFloat keyboardTopInset;
//    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
//    {
//        topInset = 52;
//        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 568, 38);
//        self.tableView.tableFooterView.frame = CGRectMake(0, 0, 568, 64);
//    } else {
//        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 38);
//        self.tableView.tableFooterView.frame = CGRectMake(0, 0, 320, 64);
//        topInset = 64;
//    }
//    keyboardTopInset = topInset;
//    
//    if (!self.isLoadMoreVisible) {
//        topInset +=4;
//    }
//    
//    CGFloat bottomInset;
//    if (self.keyboardAccessoryView.hidden) {
//        bottomInset = 20.0;
//    } else {
//        bottomInset = self.keyboardSize.height - 38;
//    }
//    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(topInset, 0.0, bottomInset, 0.0);
//    self.tableView.contentInset = contentInsets;
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(keyboardTopInset, 0.0, bottomInset - 4.0, 0.0);
//}

- (void) koChatTableViewHeader:(KOChatTableViewHeader *)koChatTableViewHeader loadMoreDidTap:(id)sender {
    [self.delegate koChatViewController:self loadMoreDidTap:sender];
}

- (void) koChatTableViewFooter:(KOChatTableViewFooter *)koChatTableViewFooter joinDidTap:(id)sender {
    [self.delegate koChatViewController:self joinDidTap:sender];
}

- (IBAction)cameraTap:(id)sender {
}

- (IBAction)sendtap:(id)sender {
}
@end

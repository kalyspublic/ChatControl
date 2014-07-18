//
//  KOChatViewController.m
//  Pods
//
//  Created by Kalys Osmonov on 7/10/14.
//
//
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "KOChatViewController.h"
#import "KOKeyboardAccessoryView.h"

@interface KOChatViewController ()

@property (nonatomic, strong) KOKeyboardAccessoryView *keyboardAccessoryView;
@property (assign) BOOL isLoadMoreVisible;
@property (assign) CGSize keyboardSize;
@end

@implementation KOChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"KOChatCellView"
                                               bundle:nil] forCellReuseIdentifier:@"KOChatCell"];
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInputControls)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}


- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) dismissInputControls {
    [self becomeFirstResponder];
}

- (UIView *) inputAccessoryView {
    self.keyboardAccessoryView = [[[NSBundle mainBundle] loadNibNamed:@"KOKeyboardAccessoryView" owner:self options:nil] firstObject];
    self.keyboardAccessoryView.delegate = self.messageFormDelegate;
    return self.keyboardAccessoryView;
}

- (void) setBackgroundImage:(UIImage *)backgroundImage {
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
}

- (void) registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidChangeFrameNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

- (void) keyboardDidChangeFrame:(NSNotification *) aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGRect keyboardRect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convertedRect = [self.view convertRect:keyboardRect fromView:nil];
    self.keyboardSize = convertedRect.size;
    [self calculateTableViewInsets];
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
//    [self calculateTableViewInsets];
}

- (void) hideJoin {
    self.tableView.tableFooterView = nil;
//    [self calculateTableViewInsets];
}

- (void) calculateTableViewInsets {
    CGFloat topInset;
    CGFloat keyboardTopInset;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        topInset = 54;
        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 568, 38);
        self.tableView.tableFooterView.frame = CGRectMake(0, 0, 568, 64);
    } else {
        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 38);
        self.tableView.tableFooterView.frame = CGRectMake(0, 0, 320, 64);
        topInset = 64;
    }
    keyboardTopInset = topInset;
    
    if (!self.isLoadMoreVisible) {
        topInset +=4;
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(topInset, 0.0, self.keyboardSize.height - 38, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(keyboardTopInset, 0.0, self.keyboardSize.height - 42, 0.0);
}

- (void) koChatTableViewHeader:(KOChatTableViewHeader *)koChatTableViewHeader loadMoreDidTap:(id)sender {
    [self.delegate koChatViewController:self loadMoreDidTap:sender];
}

- (void) koChatTableViewFooter:(KOChatTableViewFooter *)koChatTableViewFooter joinDidTap:(id)sender {
    [self.delegate koChatViewController:self joinDidTap:sender];
}

@end

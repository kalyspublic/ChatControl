//
//  KOChatViewController.m
//  Pods
//
//  Created by Kalys Osmonov on 7/10/14.
//
//

#import "KOChatViewController.h"
#import "KOKeyboardAccessoryView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface KOChatViewController ()

@property (nonatomic, strong) KOKeyboardAccessoryView *keyboardAccessoryView;
@end

@implementation KOChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"KOChatCellView"
                                               bundle:nil] forCellReuseIdentifier:@"KOChatCell"];
    RAC(self.tableView, dataSource) = RACObserve(self, tableDelegate);
    RAC(self.tableView, delegate) = RACObserve(self, tableDelegate);
    
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
}

- (void) keyboardDidChangeFrame:(NSNotification *) aNotification {
    CGFloat topPadding;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        topPadding = 56;
    } else {
        topPadding = 68;
    }
    NSDictionary* info = [aNotification userInfo];
    CGRect keyboardRect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convertedRect = [self.view convertRect:keyboardRect fromView:nil];
    CGSize kbSize = convertedRect.size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(topPadding, 0.0, kbSize.height - 38, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topPadding - 4, 0.0, kbSize.height - 42, 0.0);
    
    CGFloat yOffset = 0;
    
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        yOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    }
}

@end

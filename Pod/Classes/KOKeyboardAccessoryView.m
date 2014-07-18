//
//  KOKeyboardAccessoryView.m
//  Pods
//
//  Created by Kalys Osmonov on 7/10/14.
//
//

#import <QuartzCore/QuartzCore.h>

#import "KOKeyboardAccessoryView.h"
#import <EDHexColor/UIColor+EDHexColor.h>

@interface KOKeyboardAccessoryView ()

@property (nonatomic, weak) IBOutlet GCPlaceholderTextView *messageTextField;
- (IBAction)sendMessage:(id)sender;
- (IBAction)showCameraOptions:(id)sender;

@end

@implementation KOKeyboardAccessoryView

- (void) awakeFromNib {
    [super awakeFromNib];
    self.messageTextField.placeholder = @"Write a comment";

    self.messageTextField.delegate = self;
    
    self.messageTextField.layer.borderWidth = 1;
    self.messageTextField.layer.borderColor = [UIColor colorWithHexString:@"DCDCDC"].CGColor;
    self.messageTextField.layer.cornerRadius = 5;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (IBAction)sendMessage:(id)sender {
    [self.delegate sendButtonTouched:sender textField:nil];
}

- (IBAction)showCameraOptions:(id)sender {
    [self.delegate cameraButtonTouched:sender];
}

- (void) textViewDidChange:(UITextView *)textView {
    [self calculateSelfFrame];
}

- (void) dismissInputControl {
    [self.messageTextField resignFirstResponder];
}

- (void)orientationChanged:(NSNotification *)notification
{
    [self calculateSelfFrame];
}

- (void) calculateSelfFrame {
    NSString *text = [self.messageTextField.text stringByAppendingString:@"\naeou"];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(self.messageTextField.frame.size.width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    // detecting orientation
    CGFloat limit;
    if (self.messageTextField.frame.size.width > 215) {
        limit = 100;
    } else {
        limit = 200;
    }
    
    if (rect.size.height < limit) {
        self.frame = CGRectMake(0, 0, self.frame.size.width, rect.size.height + 12);
    } else {
        self.frame = CGRectMake(0, 0, self.frame.size.width, limit);
    }
    
    if (self.frame.size.height > limit) {
        self.frame = CGRectMake(0, 0, self.frame.size.width, limit);
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

@end
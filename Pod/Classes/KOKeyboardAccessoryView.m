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
}

- (IBAction)sendMessage:(id)sender {
    [self.delegate sendButtonTouched:sender textField:nil];
}

- (IBAction)showCameraOptions:(id)sender {
    [self.delegate cameraButtonTouched:sender];
}

- (void) textViewDidChange:(UITextView *)textView {
    NSString *text = [textView.text stringByAppendingString:@"\naeou"];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textView.frame.size.width, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributes
                                      context:nil];
    if (rect.size.height < 200) {
        self.frame = CGRectMake(0, 0, self.frame.size.width, rect.size.height + 12);
    }
}

- (void) dismissInputControl {
    [self.messageTextField resignFirstResponder];
}

@end
//
//  KOKeyboardAccessoryView.h
//  Pods
//
//  Created by Kalys Osmonov on 7/10/14.
//
//

#import <UIKit/UIKit.h>
#import "KOKeyboardAccessoryViewDelegate.h"
#import "GCPlaceholderTextView.h"

@interface KOKeyboardAccessoryView : UIView<UITextViewDelegate>

@property (nonatomic, weak) id<KOKeyboardAccessoryViewDelegate> delegate;

- (void) dismissInputControl;

@end

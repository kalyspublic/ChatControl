//
//  KOKeyboardAccessoryViewProtocol.h
//  Pods
//
//  Created by Kalys Osmonov on 7/10/14.
//
//

#import <Foundation/Foundation.h>

@protocol KOKeyboardAccessoryViewDelegate <NSObject>

- (void) cameraButtonTouched:(id) sender;
- (void) sendButtonTouched:(id) sender textField:(UITextView *)textField;

@end

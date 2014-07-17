//
//  KOViewController.h
//  ChatControl
//
//  Created by Kalys Osmonov on 07/08/2014.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChatControl/KOKeyboardAccessoryViewDelegate.h>
#import <ChatControl/KOChatViewController.h>

@interface KOViewController : UIViewController<KOKeyboardAccessoryViewDelegate, KOChatViewControllerDelegate>

@end

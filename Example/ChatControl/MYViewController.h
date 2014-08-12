//
//  KOViewController.h
//  ChatControl
//
//  Created by Kalys Osmonov on 07/08/2014.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChatControl/KOChatViewController.h>
#import <ChatControl/KOChatCellView.h>

@interface MYViewController : UIViewController<KOChatViewControllerDelegate, KOChatCellViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

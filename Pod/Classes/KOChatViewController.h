//
//  KOChatViewController.h
//  Pods
//
//  Created by Kalys Osmonov on 7/10/14.
//
//

#import <UIKit/UIKit.h>
#import "KOKeyboardAccessoryViewDelegate.h"
#import "KOChatTableDelegate.h"

@interface KOChatViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) id<KOKeyboardAccessoryViewDelegate> messageFormDelegate;
@property (nonatomic, weak) id<KOChatTableDelegate> tableDelegate;

- (void) setBackgroundImage:(UIImage *)backgroundImage;

@end

//
//  KOChatTableDelegate.h
//  Pods
//
//  Created by Kalys Osmonov on 7/13/14.
//
//

#import <Foundation/Foundation.h>

@protocol KOChatTableDelegate <UITableViewDelegate, UITableViewDataSource>

@optional

// make required UITableViewDataSource methods optional
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

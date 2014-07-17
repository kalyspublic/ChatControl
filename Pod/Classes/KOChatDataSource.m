//
//  KOChatDataSource.m
//  Pods
//
//  Created by Kalys Osmonov on 7/17/14.
//
//

#import "KOChatDataSource.h"

@implementation KOChatDataSource

- (NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                    reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                  userInfo:nil];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end

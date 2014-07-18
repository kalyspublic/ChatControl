//
//  KOChatControlHelper.m
//  Pods
//
//  Created by Kalys Osmonov on 7/17/14.
//
//

#import "KOChatControlHelper.h"

@implementation KOChatControlHelper

+ (CGFloat) cellHeight:(id<KOChatEntryDelegate>)entry {
    float cellHeight = 0.0;
    if ([entry type] == koChatEntryTypeText) {
        UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
        CGFloat textViewWidth;
        if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
            textViewWidth = 565;
        } else {
            textViewWidth = 255;
        }
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGRect rect = [[entry text] boundingRectWithSize:CGSizeMake(textViewWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        cellHeight += rect.size.height + 48;
        if ([entry showDate]) {
            cellHeight += 16;
        }
    } else if ([entry type] ==koChatEntryTypePhoto) {
        cellHeight += 138 + 48;
    }
    
    if ([[entry likesCount] integerValue] != 0 || [[entry dislikesCount] integerValue] != 0) {
        cellHeight += 20;
    }
    return cellHeight;
}

@end

//
//  KOChatControlHelper.m
//  Pods
//
//  Created by Kalys Osmonov on 7/17/14.
//
//

#import "KOChatControlHelper.h"

@implementation KOChatControlHelper

+ (CGFloat) cellHeight:(id<KOChatEntryProtocol>)entry dateVisible:(BOOL)dateVisible  {
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
        cellHeight += rect.size.height + 34;
        
        if (dateVisible) {
            cellHeight += 18;
        } else {
            cellHeight += 4;
        }
    } else if ([entry type] == koChatEntryTypePhoto || [entry type] == koChatEntryTypeVideo) {
        cellHeight += 138 + 48;
    }
    
    if ([entry likesCount] != 0 || [entry dislikesCount] != 0) {
        cellHeight += 22;
    } else {
        cellHeight += 6;
    }

    return cellHeight;
}

@end

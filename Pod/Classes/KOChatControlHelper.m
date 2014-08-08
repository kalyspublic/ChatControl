//
//  KOChatControlHelper.m
//  Pods
//
//  Created by Kalys Osmonov on 7/17/14.
//
//

#import "KOChatControlHelper.h"
#import "KOChatElementsView.h"

@implementation KOChatControlHelper

+ (CGFloat) cellHeight:(id<KOChatEntryProtocol>)entry dateVisible:(BOOL)dateVisible  {
    float cellHeight = 0.0;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    CGFloat textViewWidth;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        textViewWidth = koContentWidthLandscape;
    } else {
        textViewWidth = koContentWidthPortrait;
    }
    
    
    for (id<KOChatElementProtocol> element in [entry content]) {
        if ([element type] == koChatEntryTypeText) {
            CGRect textFrame = [[element text] boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            cellHeight += textFrame.size.height;
        } else if ([element type] == koChatEntryTypePhoto || [element type] == koChatEntryTypeVideo) {
            cellHeight += koMediaElementHeight;
            cellHeight += koMediaElementBottomPadding;
        }
    }
    
    cellHeight += 34;
    
    if (dateVisible) {
        cellHeight += 18;
    } else {
        cellHeight += 4;
    }
    
    if ([entry likesCount] != 0 || [entry dislikesCount] != 0) {
        cellHeight += 22;
    } else {
        cellHeight += 6;
    }

    return cellHeight;
}

@end

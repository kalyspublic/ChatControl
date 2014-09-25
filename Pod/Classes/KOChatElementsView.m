//
//  KOChatElementsView.m
//  Pods
//
//  Created by Kalys Osmonov on 8/7/14.
//
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <QuartzCore/QuartzCore.h>
#import "KOChatElementsView.h"
#import "KOImageView.h"

@implementation KOChatElementsView

- (void) setElements:(NSArray *)elements {
    _elements = elements;
    [self renderElements];
}

- (void) renderElements {
    float yOffset = 0.0;
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (id<KOChatElementProtocol> element in self.elements) {
        if ([element type] == koChatEntryTypeText) {
            CGFloat elementHeight = [self appendTextElement:element yOffset:yOffset];
            yOffset += elementHeight;
        } else if ([element type] == koChatEntryTypePhoto || [element type] == koChatEntryTypeVideo) {
            CGFloat elementHeight = [self appendMediaElement:element yOffset:yOffset];
            yOffset += elementHeight;
        }
    }
}

- (CGFloat) appendTextElement:(id<KOChatElementProtocol>) element yOffset:(CGFloat)yOffset {
    CGFloat textViewWidth;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        textViewWidth = koContentWidthLandscape;
    } else {
        textViewWidth = koContentWidthPortrait;
    }
    CGRect textFrame = [[element text] boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, yOffset, textViewWidth, textFrame.size.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = [element text];
    [self addSubview:label];
    return textFrame.size.height + 10;
}

- (CGFloat ) appendMediaElement:(id<KOChatElementProtocol>)element yOffset:(CGFloat)yOffset {
    KOImageView *imageView = [[KOImageView alloc] initWithFrame:CGRectMake(0, yOffset, koMediaElementWidth, koMediaElementHeight)];
    [imageView setImageWithURL:[element thumbnailURL]];
    imageView.element = element;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnImage:)];
    [imageView addGestureRecognizer:tapRecognizer];
    imageView.userInteractionEnabled = YES;
    
    imageView.layer.cornerRadius = 5.0f;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:imageView];
    
    if ([element type] == koChatEntryTypeVideo) {
        UIImageView *playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnPlay"]];
        [imageView addSubview:playImageView];
        
        playImageView.center = CGPointMake(koMediaElementWidth/2.0, koMediaElementHeight/2.0);
    }

    return koMediaElementHeight + koMediaElementBottomPadding;
}

- (void) didTapOnImage:(UITapGestureRecognizer *)sender {
    KOImageView *imageView = (KOImageView *)sender.view;
    [self.elementsViewDelegate koChatElementsView:self didTapOnElement:imageView.element sender:sender.view];
}

- (void) dealloc {
    self.elements = nil;
}

@end

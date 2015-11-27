//
//  UIView+RBAddition.m
//  fitplus
//
//  Created by 天池邵 on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "UIView+RBAddition.h"
#import "RBBorderView.h"

@interface UIView ()
@property (nonatomic,assign) BOOL existsBorderView;
@end

@implementation UIView (RBAddition)
SYNTHESIZE_CATEGORY_VALUE_PROPERTY(BOOL, existsBorderView, setExistsBorderView:);

- (void)rb_addBorder:(RB_BorderSide)side width:(CGFloat)width color:(UIColor *)color {
    
    UIView *targetView = self;
    if ([self isKindOfClass:[UITableView class]]) {
        targetView = self.subviews[0];
    }
    
    if (targetView.existsBorderView) {
        return;
    }
    
    BOOL needTop = side & BorderSide_Top, needBottom = side & BorderSide_Bottom,
    needLeft = side & BorderSide_Left, needRight = side & BorderSide_Right;
    
    RBBorderView *borderView = [RBBorderView new];
    borderView.backgroundColor = [UIColor clearColor];
    borderView.borderWidth = width;
    borderView.borderColor = color;
    borderView.userInteractionEnabled = NO;
    borderView.tag = NSIntegerMax;
    
    CGSize size = targetView.frame.size;
    if (needBottom && !needTop) {
        size.height += width;
    } else if (!needBottom) {
        size.height += width * 2;
    }
    
    if (needRight && !needLeft) {
        size.width += width;
    } else if (!needRight) {
        size.width += width * 2;
    }
    
    borderView.frame = CGRectMake(needLeft ? 0 : -width, needTop ? 0 : -width, size.width, size.height);
    
    targetView.layer.masksToBounds = YES;
    borderView.translatesAutoresizingMaskIntoConstraints = NO;
    [targetView addSubview:borderView];
    [targetView sendSubviewToBack:borderView];
    
    [targetView addConstraints:@[[NSLayoutConstraint constraintWithItem:borderView
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:targetView
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1. constant:needLeft ? 0 : -width],
                                 [NSLayoutConstraint constraintWithItem:borderView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:targetView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1. constant:needTop ? 0 : -width],
                                 [NSLayoutConstraint constraintWithItem:borderView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:targetView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1. constant:needBottom ? 0 : width],
                                 [NSLayoutConstraint constraintWithItem:borderView
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:targetView
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1. constant:needRight ? 0 : width]]];
    
    targetView.existsBorderView = YES;
    [targetView layoutIfNeeded];
}
@end

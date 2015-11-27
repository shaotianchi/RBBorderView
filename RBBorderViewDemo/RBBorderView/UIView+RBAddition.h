//
//  UIView+RBAddition.h
//  fitplus
//
//  Created by 天池邵 on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef NS_OPTIONS(NSUInteger, RB_BorderSide) {
    BorderSide_Top = 1 << 0,
    BorderSide_Bottom = 1 << 1,
    BorderSide_Left = 1 << 2,
    BorderSide_Right  = 1 << 3
};

#define SYNTHESIZE_CATEGORY_OBJ_PROPERTY(propertyGetter, propertySetter)\
- (id) propertyGetter {\
return objc_getAssociatedObject(self, @selector( propertyGetter ));\
}\
- (void) propertySetter (id)obj{\
objc_setAssociatedObject(self, @selector( propertyGetter ), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\


#define SYNTHESIZE_CATEGORY_VALUE_PROPERTY(valueType, propertyGetter, propertySetter)\
- (valueType) propertyGetter {\
valueType ret = {0};\
[objc_getAssociatedObject(self, @selector( propertyGetter )) getValue:&ret];\
return ret;\
}\
- (void) propertySetter (valueType)value{\
NSValue *valueObj = [NSValue valueWithBytes:&value objCType:@encode(valueType)];\
objc_setAssociatedObject(self, @selector( propertyGetter ), valueObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\

@interface UIView (RBAddition)
@property (assign, nonatomic) BOOL existsBorderView;
- (void)rb_addBorder:(RB_BorderSide)side width:(CGFloat)width color:(UIColor *)color;
@end

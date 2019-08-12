//
//  UIScrollView+MGHeader.m
//  CER_IKE_01
//
//  Created by guohq on 2019/3/8.
//  Copyright © 2019年 saicmotor. All rights reserved.
//

#import "UIScrollView+MGHeader.h"
#import <objc/runtime.h>

@implementation NSObject (MJRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end


static const char MGRefreshHeaderKey = '\2';
@implementation UIScrollView (MGHeader)

- (void)setMg_header:(MGRefreshHeader *)mg_header{
    if (mg_header != self.mg_header) {
        // 删除旧的，添加新的
        [self.mg_header removeFromSuperview];
        [self insertSubview:mg_header atIndex:0];
        
        // 存储新的
        objc_setAssociatedObject(self, &MGRefreshHeaderKey,
                                 mg_header, OBJC_ASSOCIATION_RETAIN);
    }
}

- (MGRefreshHeader *)mg_header
{
    return objc_getAssociatedObject(self, &MGRefreshHeaderKey);
}


#pragma mark - footer
static const char MGRefreshFooterKey = '\1';
- (void)setMg_footer:(MGRefreshFooter *)mg_footer
{
    if (mg_footer != self.mg_footer) {
        // 删除旧的，添加新的
        [self.mg_footer removeFromSuperview];
        [self insertSubview:mg_footer atIndex:0];
        
        // 存储新的
        objc_setAssociatedObject(self, &MGRefreshFooterKey,
                                 mg_footer, OBJC_ASSOCIATION_RETAIN);
    }
}

- (MGRefreshFooter *)mg_footer
{
    return objc_getAssociatedObject(self, &MGRefreshFooterKey);
}


@end

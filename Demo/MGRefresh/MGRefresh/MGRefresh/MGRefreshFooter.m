//
//  MGRefreshFooter.m
//  画圆
//
//  Created by guohq on 2019/3/14.
//  Copyright © 2019年 guohq. All rights reserved.
//

#import "MGRefreshFooter.h"
#import "UIScrollView+MGExtension.h"

@interface MGRefreshFooter()
{
    /** 记录scrollView刚开始的inset */
    UIEdgeInsets _scrollViewOriginalInset;
}
@end

@implementation MGRefreshFooter

#pragma mark - 构造方法
+ (instancetype)footerWithRefreshingBlock:(MGEndRefresh)refreshingBlock
{
    MGRefreshFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MGRefreshFooter *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 覆盖父类的方法
- (void)prepare
{
    [super prepare];
    
    // 设置高度
    self.height = 54;
    
}


- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 内容的高度
    CGFloat contentHeight = self.scrollView.contentSize.height;
    // 表格的高度
    CGFloat viewHeight    = self.scrollView.height - _scrollViewOriginalInset.top - _scrollViewOriginalInset.bottom;
    // 设置位置和尺寸
    self.y = MAX(contentHeight, viewHeight);
    
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

    if (self.state == MGRefreshStateNoMoreData || self.y == 0 || self.scrollView.height == 0 || self.state == MGRefreshStateRefreshing) return;
    
    _scrollViewOriginalInset = self.scrollView.mj_inset;

    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.contentOffset.y;

    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    CGFloat offsetY = self.scrollView.contentOffset.y;
    
    if (self.scrollView.dragging) {
        if (offsetY + self.scrollView.height  >  self.y + 54) {
            self.state = MGRefreshStatePulling;
        }else{
            self.state = MGRefreshStateIdle;
        }
    }
    else if (self.state == MGRefreshStatePulling)
    {
        self.state = MGRefreshStateRefreshing;

    }else if (self.state == MGRefreshStateIdle){
//        [self.scrollView setContentOffset:CGPointMake(0, self.y) animated:YES];
    }
 
    
    
}

/** 提示没有更多的数据 */
- (void)endRefreshingWithNoMoreData{
    MGRefreshDispatchAsyncOnMainQueue(self.state = MGRefreshStateNoMoreData;)

}


- (void)setState:(MGRefreshState)state
{
    MGRefreshCheckState
}


#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{

    CGFloat h = self.scrollView.frame.size.height;
    CGFloat he = self.scrollView.contentSize.height;
    return he - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - 0;
    } else {
        return - 0;
    }
}

@end

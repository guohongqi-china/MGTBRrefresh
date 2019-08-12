//
//  MGRefreshComponent.m
//  CER_IKE_01
//
//  Created by guohq on 2019/3/8.
//  Copyright © 2019年 saicmotor. All rights reserved.
//


#import "MGRefreshComponent.h"

NSString *const MJRefreshKeyPathContentOffset12 = @"contentOffset";
NSString *const MJRefreshKeyPathContentInset12 = @"contentInset";
NSString *const MJRefreshKeyPathContentSize12 = @"contentSize";
NSString *const MJRefreshKeyPathPanState12 = @"state";


@interface MGRefreshComponent()
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@end

@implementation MGRefreshComponent

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 准备工作
        [self prepare];
        self.backgroundColor = [UIColor clearColor];
        self.circleLineColor = [UIColor orangeColor];
        
        // 默认是普通状态
        self.state = MGRefreshStateIdle;
    }
    return self;
}

- (void)prepare
{
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
}

- (void)layoutSubviews
{
    [self placeSubviews];    
    [super layoutSubviews];
}

- (void)setCircleLineColor:(UIColor *)circleLineColor{
    _circleLineColor = circleLineColor;
}

- (void)placeSubviews{}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 设置宽度
        self.width = newSuperview.width;
        
        // 设置位置
        self.left = 0;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
//        _scrollViewOriginalInset = _scrollView.mj_inset;
        
        // 添加监听
        [self addObservers];
    }
    
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MGRefreshComponent *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

- (void)setState:(MGRefreshState)state
{
    _state = state;

    // 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
    MGRefreshDispatchAsyncOnMainQueue([self setNeedsLayout];)
}

#pragma mark - KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentOffset12 options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentSize12 options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:MJRefreshKeyPathPanState12 options:options context:nil];
}


- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:MJRefreshKeyPathContentOffset12];
    [self.superview removeObserver:self forKeyPath:MJRefreshKeyPathContentSize12];
    [self.pan removeObserver:self forKeyPath:MJRefreshKeyPathPanState12];
    self.pan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:MJRefreshKeyPathContentSize12]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:MJRefreshKeyPathContentOffset12]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:MJRefreshKeyPathPanState12]) {
        [self scrollViewPanStateDidChange:change];
    }
}


- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{}


#pragma mark - 公共方法
#pragma mark 设置回调对象和回调方法
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    self.refreshingTarget = target;
    self.refreshingAction = action;
}


#pragma mark - 内部方法
- (void)executeRefreshingCallback
{
    MGRefreshDispatchAsyncOnMainQueue({
        
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        
        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
            MGRefreshMsgSend(MGRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
        }

    })
}

#pragma mark 结束刷新状态
- (void)endRefreshing
{
    MGRefreshDispatchAsyncOnMainQueue(self.state = MGRefreshStateIdle;)
}

#pragma mark 进入刷新状态
- (void)beginRefreshing
{
    MGRefreshDispatchAsyncOnMainQueue(self.state = MGRefreshStateWillRefresh;)
}

- (void)hidenLoadingBar:(BOOL)status{
    self.hidden = status;
}

@end

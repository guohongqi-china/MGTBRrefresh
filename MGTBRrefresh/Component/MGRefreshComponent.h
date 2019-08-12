//
//  MGRefreshComponent.h
//  CER_IKE_01
//
//  Created by guohq on 2019/3/8.
//  Copyright © 2019年 saicmotor. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "UIView+Extension.h"
#import <objc/message.h>


/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, MGRefreshState) {
    MGRefreshStateRefreshing = 500,   // 刷新中
    MGRefreshStateDraging,      // 正在拖拽
    MGRefreshStatePulling,      // 释放刷新
    MGRefreshStateIdle,         // 闲置状态
    MGRefreshStateWillRefresh,  // 即将刷新的状态
    MGRefreshStateNoMoreData    // 所有数据加载完毕，没有更多的数据了
};

/** 进入刷新状态的回调 */
typedef void (^MGEndRefresh)(void);

// 状态检查
#define MGRefreshCheckState \
MGRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];

// 异步主线程执行，不强持有Self
#define MGRefreshDispatchAsyncOnMainQueue(x) \
__weak typeof(self) weakSelf = self; \
dispatch_async(dispatch_get_main_queue(), ^{ \
typeof(weakSelf) self = weakSelf; \
{x} \
});

// 运行时objc_msgSend
#define MGRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define MGRefreshMsgTarget(target) (__bridge void *)(target)


NS_ASSUME_NONNULL_BEGIN

@interface MGRefreshComponent : UIView
/** 父控件 */
@property (weak, nonatomic, readonly) UIScrollView *scrollView;
/** 当前控件的刷新状态 */
@property (nonatomic, assign)    MGRefreshState             state;
/** 进度条颜色 */
@property (nonatomic, strong)    UIColor                    *circleLineColor;

/** 正在刷新的回调 */
@property (copy, nonatomic) MGEndRefresh refreshingBlock;

/** 回调对象 */
@property (weak, nonatomic) id refreshingTarget;
/** 回调方法 */
@property (assign, nonatomic) SEL refreshingAction;


/** 初始化 */
- (void)prepare NS_REQUIRES_SUPER;
/** 摆放子控件frame */
- (void)placeSubviews NS_REQUIRES_SUPER;
/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
/** 当scrollView的contentSize发生改变的时候调用 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
/** 当scrollView的拖拽状态发生改变的时候调用 */
- (void)scrollViewPanStateDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;

/** 隐藏状态栏 */
- (void)hidenLoadingBar:(BOOL)status;


/** 设置回调对象和回调方法 */
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;

#pragma mark - 内部方法
- (void)executeRefreshingCallback;



/** 进入刷新状态 */
- (void)beginRefreshing;
/** 结束刷新状态 */
- (void)endRefreshing;

@end

NS_ASSUME_NONNULL_END

//
//  MGRefreshFooter.h
//  画圆
//
//  Created by guohq on 2019/3/14.
//  Copyright © 2019年 guohq. All rights reserved.
//

#import "MGRefreshComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRefreshFooter : MGRefreshComponent


/** 创建header */
+ (instancetype)footerWithRefreshingBlock:(MGEndRefresh)refreshingBlock;
/** 创建header */
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 提示没有更多的数据 */
- (void)endRefreshingWithNoMoreData;


@end

NS_ASSUME_NONNULL_END

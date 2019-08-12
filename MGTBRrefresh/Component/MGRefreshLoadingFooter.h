//
//  MGRefreshLoadingFooter.h
//  画圆
//
//  Created by guohq on 2019/3/14.
//  Copyright © 2019年 guohq. All rights reserved.
//

#import "MGRefreshFooter.h"
#import "MGLineRoundView.h"
NS_ASSUME_NONNULL_BEGIN

@interface MGRefreshLoadingFooter : MGRefreshFooter

@property (retain, nonatomic, readonly) MGLineRoundView           *roundView;
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;

@end

@interface UILabel(MJRefresh)
+ (instancetype)mj_label;
- (CGFloat)mj_textWith;
@end

NS_ASSUME_NONNULL_END

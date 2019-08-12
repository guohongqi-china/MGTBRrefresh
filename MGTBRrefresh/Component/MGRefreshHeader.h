//
//  MGRefreshHeader.h
//  CER_IKE_01
//
//  Created by guohq on 2019/3/10.
//  Copyright © 2019年 saicmotor. All rights reserved.
//

#import "MGRefreshComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRefreshHeader : MGRefreshComponent

/** 创建header */
+ (instancetype)headerWithRefreshingBlock:(MGEndRefresh)refreshingBlock;
/** 创建header */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end

NS_ASSUME_NONNULL_END

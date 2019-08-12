//
//  UIScrollView+MGHeader.h
//  CER_IKE_01
//
//  Created by guohq on 2019/3/8.
//  Copyright © 2019年 saicmotor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGRefreshLoadingHeader.h"
#import "MGRefreshLoadingFooter.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (MGHeader)
/** 下拉刷新控件 */

@property (nonatomic, strong)    MGRefreshHeader           *mg_header;
/** 上拉刷新控件 */
@property (strong, nonatomic)    MGRefreshFooter           *mg_footer;


@end

NS_ASSUME_NONNULL_END

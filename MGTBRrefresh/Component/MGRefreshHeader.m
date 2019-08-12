//
//  MGRefreshHeader.m
//  CER_IKE_01
//
//  Created by guohq on 2019/3/10.
//  Copyright © 2019年 saicmotor. All rights reserved.
//

#import "MGRefreshHeader.h"
#import "UIScrollView+MGExtension.h"

@implementation MGRefreshHeader

#pragma mark - 构造方法
+ (instancetype)headerWithRefreshingBlock:(MGEndRefresh)refreshingBlock
{
    MGRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MGRefreshHeader *cmp = [[self alloc] init];
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

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    CGFloat offsetY = self.scrollView.contentOffset.y;
    
    if (self.state == MGRefreshStateRefreshing) {
        // 暂时保留
        if (self.window == nil) return;
        
        if (offsetY > 0 || offsetY == 0) {
          self.scrollView.mj_insetT = 0;
            return;
        }
    }
    

    if (self.scrollView.isDragging && self.state != MGRefreshStateRefreshing)
    { // 如果正在拖拽
        if (offsetY < -70) {
            self.state =  MGRefreshStatePulling;
        }
        else
        {
            self.state =  MGRefreshStateIdle;
        }
    }
    else if(self.state ==  MGRefreshStatePulling)
    {
        self.state = MGRefreshStateRefreshing;
    }else if (self.state == MGRefreshStateWillRefresh && offsetY < -70){
        self.state = MGRefreshStateRefreshing;
    }

}



- (void)placeSubviews
{
    [super placeSubviews];
    
    self.top = -54;
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
}

- (void)setState:(MGRefreshState)state
{
   MGRefreshCheckState
}


@end

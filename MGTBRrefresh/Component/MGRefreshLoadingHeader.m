//
//  MGRefreshLoadingHeader.m
//  CER_IKE_01
//
//  Created by guohq on 2019/3/11.
//  Copyright © 2019年 saicmotor. All rights reserved.
//

#import "MGRefreshLoadingHeader.h"

@interface MGRefreshLoadingHeader()
{
    CGFloat angle;
    __unsafe_unretained MGLineRoundView *_roundView;

}
@property (nonatomic, weak)    UIActivityIndicatorView           *loadingView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end

@implementation MGRefreshLoadingHeader

- (void)placeSubviews{
    [super placeSubviews];
    
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = CGPointMake(self.centerX, self.height / 2);
    }
}

- (void)setCircleLineColor:(UIColor *)circleLineColor{
    [super setCircleLineColor:circleLineColor];
    self.roundView.lineColor = self.circleLineColor;
    self.loadingView.color   = self.circleLineColor;

}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.contentOffset.y;

    if (offsetY < -20) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.state == MGRefreshStateRefreshing) return;
            self.roundView.currentAngle = (offsetY + 20) / (-54) * M_PI * 2 +  M_PI_2 * 3;
        });
    }
}

- (void)setState:(MGRefreshState)state{
    
    MGRefreshCheckState

    if(state == MGRefreshStateRefreshing)
    {
        [self executeRefreshingCallback];
        [self.loadingView startAnimating];
        self.roundView.hidden = YES;
        MGRefreshDispatchAsyncOnMainQueue(
            [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(54.0f, 0.0f, 0.0f, 0.0f);
            }];
        )
    }
    else if (state == MGRefreshStateIdle)
    {
       
        [self.loadingView stopAnimating];
        MGRefreshDispatchAsyncOnMainQueue(
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        } completion:^(BOOL finished) {
            self.roundView.hidden = NO;
            self.roundView.currentAngle = M_PI_2 * 3;
        }];
       )
    }
    else if (state == MGRefreshStateWillRefresh)
    {
        MGRefreshDispatchAsyncOnMainQueue(
         [self.scrollView setContentOffset:CGPointMake(0, -71) animated:YES];
        );
    }
}


#pragma mark  ---------------------  getter setter   ----------------------------------------------

- (MGLineRoundView *)roundView
{
    if (!_roundView) {
        MGLineRoundView *roundView = [[MGLineRoundView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 25, 54 / 2 - 25, 50, 50)];
        roundView.backgroundColor = [UIColor clearColor];
        [self addSubview:_roundView = roundView];
    }
    return _roundView;
}

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

@end

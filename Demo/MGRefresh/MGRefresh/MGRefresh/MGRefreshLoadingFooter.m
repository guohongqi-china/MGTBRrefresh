//
//  MGRefreshLoadingFooter.m
//  画圆
//
//  Created by guohq on 2019/3/14.
//  Copyright © 2019年 guohq. All rights reserved.
//


#import "MGRefreshLoadingFooter.h"
#import "MGLineRoundView.h"

// RGB颜色
#define MJRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define MJRefreshLabelTextColor MJRefreshColor(90, 90, 90)

// 字体大小
#define MJRefreshLabelFont [UIFont boldSystemFontOfSize:14]

@interface MGRefreshLoadingFooter()
{
    __unsafe_unretained MGLineRoundView *_roundView;
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
}
@property (nonatomic, weak)    UIActivityIndicatorView           *loadingView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end

@implementation MGRefreshLoadingFooter

- (void)prepare{
    [super prepare];
    
    self.stateLabel.text = @"Load completed";

}

- (void)setCircleLineColor:(UIColor *)circleLineColor{
    [super setCircleLineColor:circleLineColor];
    self.roundView.lineColor = self.circleLineColor;
    self.loadingView.color   = self.circleLineColor;
    self.stateLabel.textColor= self.circleLineColor;
}

- (void)placeSubviews{
    [super placeSubviews];
    
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = CGPointMake(self.centerX, self.height / 2);
    }
    
    if (self.stateLabel.constraints.count) return;
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(MGRefreshState)state{
    MGRefreshCheckState
    self.stateLabel.hidden = YES;
    if(state == MGRefreshStateRefreshing)
    {
        
        MGRefreshDispatchAsyncOnMainQueue(
            self.roundView.hidden = YES;
            [self.loadingView startAnimating];
            [UIView animateWithDuration:0.25 animations:^{
                 self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0, self.height, 0);
                 [self.scrollView setContentOffset:CGPointMake(0, self.y - self.scrollView.height + self.height) animated:YES];
            } completion:^(BOOL finished) {
                 [self executeRefreshingCallback];
            }];
        )
    }
    else if (state == MGRefreshStateIdle)
    {
        if (oldState == MGRefreshStateRefreshing) {
            [self.loadingView stopAnimating];
           MGRefreshDispatchAsyncOnMainQueue(
            [UIView animateWithDuration:0.25 animations:^{
               self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0, 0, 0);
            } completion:^(BOOL finished) {
                self.roundView.hidden = NO;
                self.roundView.currentAngle = M_PI_2 * 3;
            }];
           )
        }else{
            self.roundView.hidden = NO;
            self.roundView.currentAngle = M_PI_2 * 3;
        }
        
    }
    else if (state == MGRefreshStateWillRefresh)
    {
        MGRefreshDispatchAsyncOnMainQueue(
            [self.scrollView setContentOffset:CGPointMake(0, -71) animated:YES];
        )
    }else if (state == MGRefreshStateNoMoreData){
        self.roundView.hidden = YES;
        [self.loadingView stopAnimating];
        MGRefreshDispatchAsyncOnMainQueue(
            self.stateLabel.hidden = NO;
        )
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.contentOffset.y;

    if (offsetY > self.y - self.scrollView.height && self.state != MGRefreshStateRefreshing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.roundView.currentAngle = (offsetY - self.y + self.scrollView.height) / 50 * M_PI * 2 +  M_PI_2 * 3;
        });
    }
}

- (CGFloat)heightForContentBreakView
{

    CGFloat h = self.scrollView.frame.size.height;
    CGFloat he = self.scrollView.contentSize.height;
    return he < h ? 0 : he - h;
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

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel mj_label]];
    }
    return _stateLabel;
}

@end

@implementation UILabel(MJRefresh)
+ (instancetype)mj_label
{
    UILabel *label = [[self alloc] init];
    label.font = MJRefreshLabelFont;
    label.textColor = MJRefreshLabelTextColor;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor greenColor];
    return label;
}

- (CGFloat)mj_textWith {
    CGFloat stringWidth = 0;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if (self.text.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringWidth =[self.text
                      boundingRectWithSize:size
                      options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{NSFontAttributeName:self.font}
                      context:nil].size.width;
#else
        
        stringWidth = [self.text sizeWithFont:self.font
                            constrainedToSize:size
                                lineBreakMode:NSLineBreakByCharWrapping].width;
#endif
    }
    return stringWidth;
}
@end

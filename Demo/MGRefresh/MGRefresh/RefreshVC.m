//
//  RefreshVC.m
//  MGRefresh
//
//  Created by guohq on 2019/8/11.
//  Copyright © 2019 guohq. All rights reserved.
//

#import "RefreshVC.h"
#import "UIScrollView+MGHeader.h"

@interface RefreshVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)    NSMutableArray           *dataArr;



@end

@implementation RefreshVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.dataArr                             = [@[@"1",@"2",@"3",@"1",@"2",@"3"] mutableCopy];
    
    __weak typeof(self) weakself             = self;
    
    self.tableView.mg_header                 = [MGRefreshLoadingHeader headerWithRefreshingBlock:^{
        __strong typeof(weakself) strongself = weakself;
        [strongself loadNewData];
    }];
    
    self.tableView.mg_footer                 = [MGRefreshLoadingFooter footerWithRefreshingBlock:^{
        __strong typeof(weakself) strongself = weakself;
        [strongself reloadMoreData];
    }];
    
    [self.tableView.mg_header beginRefreshing];
    
    // 设置loading颜色
    self.tableView.mg_header.circleLineColor = [UIColor redColor];
    self.tableView.mg_footer.circleLineColor = [UIColor greenColor];
    // 页面无数据、无网络情况下，不允许上拉刷新
    // [self.tableView.mg_footer hidenLoadingBar:YES];

    
}

- (void)loadNewData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mg_header endRefreshing];
        [self.tableView.mg_footer endRefreshing];
        self.dataArr                             = [@[@"1",@"2",@"3",@"1",@"2",@"3"] mutableCopy];

        
        [self.tableView reloadData];
        
    });
}

- (void)reloadMoreData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mg_header endRefreshing];
        [self.tableView.mg_footer endRefreshing];
        
        [self.dataArr addObjectsFromArray:@[@"2",@"3",@"4"]];
        [self.tableView reloadData];
    });
}

#pragma mark --  UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

#pragma mark --  getter setter

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

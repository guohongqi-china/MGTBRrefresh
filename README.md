Installation MGTBRrefresh
======================

### CocoaPods

1. Add `pod 'MGTBRrefresh'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<MGTBRrefresh/MGTBRrefresh\>.


Example
======================
![image](https://github.com/guohongqi-china/MGTBRrefresh/blob/master/Untitled.gif)

Use Case
======================

### talbeivew head
* `headerWithRefreshingBlock`   
  - `beginRefreshing 头部自动刷新`
  - `circleLineColor 刷新控件颜色控制`
  - `endRefreshing 头部结束刷新`
  
### talbeivew footer
* `footerWithRefreshingBlock`
  - `circleLineColor 刷新控件颜色控制`
  - `endRefreshing 尾部结束刷新`
  - `hidenLoadingBar 隐藏尾部视图 ===> 场景：无网络、无数据情况下，禁止上拉加载使用`

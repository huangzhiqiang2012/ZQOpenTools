//
//  ZQScrollViewExtension.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/29.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

public struct ZQScrollViewWrapper<Base> {
    let base:Base
    init(_ base:Base) {
        self.base = base
    }
}

public protocol ZQScrollViewExtensionsProvider {}

extension ZQScrollViewExtensionsProvider {
    public var zq:ZQScrollViewWrapper<Self> {
        return ZQScrollViewWrapper(self)
    }
}

extension UIScrollView:ZQScrollViewExtensionsProvider{}

extension ZQScrollViewWrapper where Base : UIScrollView {
    
    /*******DGElasticPullToRefresh*******/
    /// 添加弹性刷新头
    /// - Parameter actionHandler: 回调
    func addDGElasticRefresh(actionHandler: @escaping () -> Void) {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.red
        base.dg_addPullToRefreshWithActionHandler(actionHandler, loadingView: loadingView)
        base.dg_setPullToRefreshFillColor(UIColor.blue)
        base.dg_setPullToRefreshBackgroundColor(UIColor.yellow)
    }
    
    /// 停止弹性刷新头
    func stopDGElasticRefresh() {
        base.dg_stopLoading()
    }
    
    /// 移除弹性刷新头
    func removeDGElasticRefresh() {
        base.dg_removePullToRefresh()
    }
    
    /*******MJRefresh*******/
    /// 添加刷新头
    /// - Parameters:
    ///   - header: 刷新头
    ///   - actionHandler: 回调
    func addMJRefreshHeader(header:MJRefreshHeader = ZQRefreshHeader(), actionHandler:@escaping MJRefreshComponentAction) {
        base.mj_header = header
        header.refreshingBlock = actionHandler
    }
    
    /// 添加刷新尾
    /// - Parameters:
    ///   - footer: 刷新尾
    ///   - actionHandler: 回调
    func addMJRefreshFooter(footer:MJRefreshFooter = ZQRefreshFooter(), actionHandler:@escaping MJRefreshComponentAction) {
        base.mj_footer = footer
        footer.refreshingBlock = actionHandler
    }
    
    /// 停止刷新头
    func stopMJRefreshHeader() {
        base.mj_header?.endRefreshing()
    }
    
    /// 停止刷新尾
    func stopMJRefreshFooter() {
        base.mj_footer?.endRefreshing()
    }
    
    /// 停止刷新尾,没有更多数据
    func stopMJRefreshFooterWithNoMoreData() {
        base.mj_footer?.endRefreshingWithNoMoreData()
    }
}

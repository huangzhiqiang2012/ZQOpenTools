//
//  ZQPageFetchProtocol.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/4.
//  Copyright © 2020 Darren. All rights reserved.
//

import Foundation

/// 分页适配器
class ZQPageFetchAdater {
    
    /// 当前页数
    fileprivate var pageMark : Int = 1
    
    /// 是否没有更多数据
    fileprivate var isNoMoreData : Bool = false
}

/// 分页抓取协议
protocol ZQPageFetchProtocol : class {
    
    /// 适配器
    var pageFetchAdater : ZQPageFetchAdater { get }
    
    /// 每页个数
    var perPage: Int { get }
    
    /// 计算将要抓取的页数
    /// - Parameter isFirstFetch: 是否第一次抓取
    func caculatePage(_ isFirstFetch: Bool) -> Int
    
    /// 处理数据
    /// - Parameters:
    ///   - datas: 数据
    ///   - scrollView: 滚动视图
    ///   - isFirstFetch: 是否第一次抓取
    ///   - totalCount: 数据总数
    func handleData(_ datas:[AnyObject], scrollView: UIScrollView, isFirstFetch: Bool, totalCount: Int)
    
    /// 注入数据
    /// - Parameters:
    ///   - datas: 数据
    ///   - isFirstFetch: 是否第一次抓取
    dynamic func injectData(_ datas:[AnyObject], isFirstFetch: Bool)
}

extension ZQPageFetchProtocol {
    func caculatePage(_ isFirstFetch: Bool) -> Int {
        return isFirstFetch ? 1 : (pageFetchAdater.pageMark + 1)
    }
    
    func handleData(_ datas:[AnyObject], scrollView: UIScrollView, isFirstFetch: Bool, totalCount: Int) {
        
        scrollView.zq.endMJRefreshHeader()
        
        /// 下拉刷新
        if isFirstFetch {
            injectData(datas, isFirstFetch: true)
            scrollView.zq.resetMJRefreshFooterWithNoMoreData()
            pageFetchAdater.pageMark = 1
            pageFetchAdater.isNoMoreData = false
        }
            
        /// 上拉加载更多
        else {
            if datas.isEmpty {
                scrollView.zq.endMJRefreshFooterWithNoMoreData()
                pageFetchAdater.isNoMoreData = true
            }
            else {
                if perPage * pageFetchAdater.pageMark >= totalCount {
                    scrollView.zq.endMJRefreshFooterWithNoMoreData()
                    pageFetchAdater.isNoMoreData = true
                }
                else {
                    injectData(datas, isFirstFetch: false)
                    scrollView.zq.endMJRefreshFooter()
                    pageFetchAdater.pageMark += 1
                }
            }
        }
    }
}

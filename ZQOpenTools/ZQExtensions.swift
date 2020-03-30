//
//  ZQExtensions.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/7.
//  Copyright © 2020 Darren. All rights reserved.
//

public struct ZQ<Base> {
    let base:Base
    init(_ base:Base) {
        self.base = base
    }
}

public protocol ZQExtensionsProvider {}

extension ZQExtensionsProvider {
    public var zq:ZQ<Self> {
        return ZQ(self)
    }
}


// MARK: String + Extension
extension String:ZQExtensionsProvider {}
extension ZQ where Base == String {
    
    /// 获取控制器的class
    func getViewControllerClass() -> AnyObject {
        
        // 根据字符串获取对应的class，在Swift中不能直接使用
        // Swift中命名空间的概念
        guard let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            print("没有命名空间")
            return NSNull()
        }
        
        guard let childVcClass = NSClassFromString(nameSpace + "." + base) else {
            print("没有获取到对应的class")
            return NSNull()
        }
        
        guard let childVcType = childVcClass as? UIViewController.Type else {
            print("没有得到的类型")
            return NSNull()
        }
        
        // 根据类型创建对应的对象
        let vc = childVcType.init()
        return vc
    }
}

// MARK: UIScrollView + Extension
extension UIScrollView:ZQExtensionsProvider{}
extension ZQ where Base : UIScrollView {
    
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

// MARK: UIImageView + Extension
extension UIImageView:ZQExtensionsProvider{}
extension ZQ where Base == UIImageView {
    
    @discardableResult
    /// .processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default) 支持webp格式图片
    func setImage(urlStr:String?, placeholder:Placeholder? = UIImage(named: "placeholder")) -> DownloadTask? {
        return base.kf.setImage(with: URL(string: urlStr ?? ""), placeholder: placeholder, options: [.transition(.fade(0.5)), .processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)])
    }
}

// MARK: UIButton + Extension
extension UIButton:ZQExtensionsProvider{}
extension ZQ where Base == UIButton {
    
    @discardableResult
    /// .processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default) 支持webp格式图片
    func setImage(urlStr:String?, for state:UIControl.State, placeholder:UIImage? = UIImage(named: "placeholder")) -> DownloadTask? {
        return base.kf.setImage(with: URL(string: urlStr ?? ""), for: state, placeholder: placeholder, options:[.transition(.fade(0.5)), .processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)])
    }
}

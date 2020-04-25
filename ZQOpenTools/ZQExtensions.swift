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
    func endMJRefreshHeader() {
        base.mj_header?.endRefreshing()
    }
    
    /// 停止刷新尾
    func endMJRefreshFooter() {
        base.mj_footer?.endRefreshing()
    }
    
    /// 停止刷新尾,没有更多数据
    func endMJRefreshFooterWithNoMoreData() {
        base.mj_footer?.endRefreshingWithNoMoreData()
    }
    
    /// 重置没有更多的数据（消除没有更多数据的状态）
    func resetMJRefreshFooterWithNoMoreData() {
        base.mj_footer?.resetNoMoreData()
    }
}

// MARK: UIView + Extension
extension UIView : ZQExtensionsProvider {}
extension ZQ where Base : UIView {
    func addSubViews(_ views:[UIView]) {
        for view in views {
            base.addSubview(view)
        }
    }
    
    func addBorder(withBorderWidth borderWidth:CGFloat, borderColor:UIColor, radius:CGFloat) -> Void {
        base.layer.borderWidth = borderWidth
        base.layer.borderColor = borderColor.cgColor
        addRadius(radius: radius)
    }
    
    func addBorder(withBorderWidth borderWidth:CGFloat, borderColor:UIColor) -> Void {
        addBorder(withBorderWidth: borderWidth, borderColor: borderColor, radius: 0)
    }
    
    func addRadius(radius:CGFloat) -> Void {
        base.layer.cornerRadius = radius
        base.clipsToBounds = radius > 0 ? true : false
    }
}

// MARK: UIImageView + Extension
extension ZQ where Base == UIImageView {
    
    @discardableResult
    /// .processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default) 支持webp格式图片
    func setImage(urlStr:String?, placeholder:Placeholder? = UIImage(named: "placeholder")) -> DownloadTask? {
        return base.kf.setImage(with: URL(string: urlStr ?? ""), placeholder: placeholder, options: [.transition(.fade(0.5)), .processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)])
    }
}

// MARK: UIButton + Extension
extension ZQ where Base == UIButton {
    
    @discardableResult
    /// .processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default) 支持webp格式图片
    func setImage(urlStr:String?, for state:UIControl.State, placeholder:UIImage? = UIImage(named: "placeholder")) -> DownloadTask? {
        return base.kf.setImage(with: URL(string: urlStr ?? ""), for: state, placeholder: placeholder, options:[.transition(.fade(0.5)), .processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)])
    }
}

// MARK: ASDisplayNode + Extension
extension ASDisplayNode:ZQExtensionsProvider{}
extension ZQ where Base : ASDisplayNode {
    func addSubNodes(_ nodes:[ASDisplayNode]) {
        for node in nodes {
            base.addSubnode(node)
        }
    }
    
    func addBorder(withBorderWidth borderWidth:CGFloat, borderColor:UIColor, radius:CGFloat) -> Void {
        base.borderWidth = borderWidth
        base.borderColor = borderColor.cgColor
        addRadius(radius: radius)
    }
    
    func addBorder(withBorderWidth borderWidth:CGFloat, borderColor:UIColor) -> Void {
        addBorder(withBorderWidth: borderWidth, borderColor: borderColor, radius: 0)
    }
    
    func addRadius(radius:CGFloat) -> Void {
        base.cornerRadius = radius
        base.clipsToBounds = radius > 0 ? true : false
    }
}

private struct ZQAssociatedKey {
    static var reloadIndexPathsKey:UInt8 = 0
}


// MARK: ASTableNode  + Extension
extension ASTableNode {
    
    /// 用于解决reloadData时闪烁问题
    var reloadIndexPaths:[IndexPath] {
        get {
            return objc_getAssociatedObject(self, &ZQAssociatedKey.reloadIndexPathsKey) as? [IndexPath] ?? [IndexPath]()
        }
        set {
            objc_setAssociatedObject(self, &ZQAssociatedKey.reloadIndexPathsKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    /// 刷新数据,解决闪烁问题,需在 func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock 方法中 配合 以下操作
     /** if tableNode.reloadIndexPaths.contains(indexPath) {
                cellNode.neverShowPlaceholders = true
                cellNode.model = model
              DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                cellNode.neverShowPlaceholders = false
              }
         }
          else {
               cellNode.neverShowPlaceholders = false
               cellNode.model = model
          }
     */
    /// 无闪烁刷新数据, 该方法只适用于数据源不发生变化的情况下使用,而上拉加载更多,下拉刷新之后的刷新列表不能用该方法
    /// - Parameters:
    ///   - indexPaths: 索引数组
    func reloadDataWithoutFlashing(indexPaths:[IndexPath] = []) {
        reloadIndexPaths = indexPaths.count == 0 ? indexPathsForVisibleRows() : indexPaths
        reloadIndexPaths.count > 0 ? reloadRows(at: reloadIndexPaths, with: .none) : reloadData()
    }
}

// MARK: Array + Extension
extension Array {
    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}

// MARK: ListSectionController + Extension
extension ListSectionController:ZQExtensionsProvider{}
extension ZQ where Base : ListSectionController {
    func selfWidth() -> CGFloat {
        if let width = base.collectionContext?.containerSize(for: base).width {
            return width
        }
        return UIScreen.main.bounds.size.width
    }
}

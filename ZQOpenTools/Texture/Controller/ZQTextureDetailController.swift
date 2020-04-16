//
//  ZQTextureDetailController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/9.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit
import WebKit

/// Texture 模块 详情控制器
class ZQTextureDetailController: ZQBaseASViewController {
    
    var id:String = "610050"
    
    private lazy var disposeBag:DisposeBag = DisposeBag()
    
    private lazy var viewModel:ZQTextureViewModel = ZQTextureViewModel()
    
    private lazy var scrollNode:ZQASScrollNode = ZQASScrollNode().then {
        $0.backgroundColor = UIColor.systemGroupedBackground
        $0.view.zq.addMJRefreshFooter { [weak self] in
            if let self = self {
                self.requestCommentData(isFirstFetch: false)
            }
        }
        
        /// 设置了 automaticallyManagesSubnodes, 不需手动添加和移除 subNodes
        //        $0.addSubnode(headerNode)
        //        $0.addSubnode(webNode)
        //        $0.addSubnode(tableNode)
    }
    
    private lazy var headerNode:ZQTextureHeaderNode = ZQTextureHeaderNode()
    
    private lazy var webNode:ASDisplayNode = ASDisplayNode { () -> UIView in
        return WKWebView().then {
            $0.scrollView.isScrollEnabled = false
        }
    }
    
    private lazy var relationNode:ZQTextureRelationNode = ZQTextureRelationNode()
    
    private lazy var commentNode:ZQTextureCommentNode = ZQTextureCommentNode()
    
    /**
     它会在 ASViewController 的生命周期的最开始调用，仅次于 -loadView 。这是你使用节点的 view 最早的时机。在这个方法里适合放只执行一次并且要使用 view/layer 的代码，比如加手势。
     布局的代码千万不要放在这个方法里，因为界面发生改变也不会再调用这个方法重新布局。
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        creatNode()
        addObserve()
        requestData()
    }
}

// MARK: private
extension ZQTextureDetailController {
    private func requestData() {
        viewModel.requestDetailData(id: id) { [weak self] in
            if let self = self {
                self.headerNode.model = self.viewModel.detailModel
                (self.webNode.view as! WKWebView).loadHTMLString("<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header><style type=\"text/css\">body{font-size:18px;}img{width:100% !important;height:auto;} </style>" + (self.viewModel.detailModel?.content ?? ""), baseURL: nil)
            }
        }
        
        viewModel.requestRecommendArticleData(id: id) { [weak self] in
            if let self = self {
                self.relationNode.datasArr = self.viewModel.recommendArticleArr
            }
        }
        
        requestCommentData(isFirstFetch: true)
    }
    
    private func requestCommentData(isFirstFetch:Bool) {
        viewModel.requestCommentData(isFirstFetch: isFirstFetch, id: id, scrollView: scrollNode.view) { [weak self] in
            if let self = self {
                self.commentNode.datasArr = self.viewModel.commentArr
            }
        }
    }
    
    private func addObserve() {
        (webNode.view as! WKWebView).scrollView.rx.observe(String.self, "contentSize").subscribe(onNext: {[weak self] value in
            if let self = self {
                let height = (self.webNode.view as! WKWebView).scrollView.contentSize.height
                if height > 0 {
                    self.webNode.transitionLayout(withAnimation: false, shouldMeasureAsync: false)
                    self.scrollNode.transitionLayout(withAnimation: false, shouldMeasureAsync: false)
                }
            }
        }).disposed(by: disposeBag)
        
        relationNode.didUpdataTableNode = { [weak self] in
            if let self = self {
                self.scrollNode.transitionLayout(withAnimation: false, shouldMeasureAsync: false)
            }
        }
        
        commentNode.didUpdataTableNode = { [weak self] in
            if let self = self {
                self.scrollNode.transitionLayout(withAnimation: false, shouldMeasureAsync: false)
            }
        }
    }
    
    private func creatNode() {
        scrollNode.layoutSpecBlock = {[weak self] (node, constrainedSize) -> ASLayoutSpec in
            guard let self = self else { return ASLayoutSpec()}
            let dimension:CGFloat = constrainedSize.max.width
            self.webNode.style.preferredSize = CGSize(width: dimension, height: (self.webNode.view as! WKWebView).scrollView.contentSize.height)
            let stack = ASStackLayoutSpec.vertical()
            stack.spacing = 0
            stack.justifyContent = .start
            stack.alignItems = .stretch
            stack.children = [self.headerNode, self.webNode, self.relationNode, self.commentNode]
            return stack
        }
        contentNode.layoutSpecBlock = {[weak self] (node, constrainedSize) -> ASLayoutSpec in
            guard let self = self else { return ASLayoutSpec()}
            let inset = ASInsetLayoutSpec(insets:node.safeAreaInsets, child: self.scrollNode)
            return inset
        }
    }
}

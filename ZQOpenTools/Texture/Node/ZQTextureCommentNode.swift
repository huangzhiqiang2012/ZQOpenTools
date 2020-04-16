//
//  ZQTextureCommentNode.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/3.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Texture 模块 评论视图
class ZQTextureCommentNode: ZQASDisplayNode {
    
    private lazy var disposeBag:DisposeBag = DisposeBag()
    
    private lazy var tableNode:ZQASTableNode = ZQASTableNode(dataSource: self, delegate: self).then {
        $0.view.isScrollEnabled = false
    }
    
    var datasArr:[ZQTextureArticleCommentModel] = [ZQTextureArticleCommentModel]() {
        didSet {
            tableNode.reloadDataWithoutFlashing()
        }
    }
    
    var didUpdataTableNode:(() -> ())?

    override init() {
        super.init()
        config()
        addObserve()
    }
}

// MARK: private
extension ZQTextureCommentNode {
    private func config() {
        backgroundColor = .white
    }
    
    private func addObserve() {
        tableNode.view.rx.observe(String.self, "contentSize").subscribe(onNext: {[weak self] value in
            if let self = self {
                let height = self.tableNode.view.contentSize.height
                if height > 0 {
                    self.tableNode.transitionLayout(withAnimation: false, shouldMeasureAsync: false)
                    self.didUpdataTableNode?()
                }
            }
        }).disposed(by: disposeBag)
    }
}

extension ZQTextureCommentNode {
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let dimension = constrainedSize.max.width
        tableNode.style.preferredSize = CGSize(width: dimension, height: tableNode.view.contentSize.height)
        let stackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [tableNode])
        return stackSpec
    }
}

// MARK: ASTableDataSource & ASTableDelegate
extension ZQTextureCommentNode : ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return datasArr.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {[weak self] () -> ASCellNode in
            let cellNode = ZQTextureCommentCellNode()
            if let self = self {
                let model = self.datasArr[indexPath.row]
                
                /// 配合reloadDataWithoutFlashing刷新方法一起使用
                if tableNode.reloadIndexPaths.contains(indexPath) {
                    cellNode.neverShowPlaceholders = true
                    cellNode.model = model
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        cellNode.neverShowPlaceholders = false
                    }
                }
                else {
                    cellNode.neverShowPlaceholders = false
                    cellNode.model = model
                }
            }
            return cellNode
        }
    }
}



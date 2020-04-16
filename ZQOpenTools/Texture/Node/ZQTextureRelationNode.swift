//
//  ZQTextureRelationNode.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/1.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Texture 模块 相关推荐视图
class ZQTextureRelationNode: ZQASDisplayNode {
    
    private lazy var disposeBag:DisposeBag = DisposeBag()
    
    private lazy var lineTopNode:ZQASDisplayNode = getLineNode()
    
    private lazy var titleNode:ZQASTextNode = ZQASTextNode().then {
        $0.show(text: "相关资讯", font: .systemFont(ofSize: 16, weight: .medium), color: .black)
    }
    
    private lazy var lineNode:ZQASDisplayNode = ZQASDisplayNode().then {
        $0.backgroundColor = .lightGray
    }
    
    private lazy var tableNode:ZQASTableNode = ZQASTableNode(dataSource: self, delegate: self).then {
        $0.view.isScrollEnabled = false
    }
    
    private lazy var moreButtonNode:ZQASButtonNode = ZQASButtonNode(target: self, action: #selector(actionForMoreButtonNode), forControlEvents: .touchUpInside).then {
        $0.setTitle("查看更多", with: .systemFont(ofSize: 14), with: .black, for: .normal)
        $0.setImage(UIImage(named: "detail_more_down"), for: .normal)
        $0.imageAlignment = .end
    }
        
    private lazy var lineBottomNode:ZQASDisplayNode = getLineNode()
    
    private lazy var showAll:Bool = false
    
    var didUpdataTableNode:(() -> ())?
    
    var datasArr:[ZQTextureArticleModel] = [ZQTextureArticleModel]() {
        didSet {
            tableNode.reloadDataWithoutFlashing()
        }
    }

    override init() {
        super.init()
        config()
        addObserve()
    }
}

// MARK: override
extension ZQTextureRelationNode {
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let dimension = constrainedSize.max.width
        let lineSize = CGSize(width: dimension, height: 8)
        lineTopNode.style.preferredSize = lineSize
        guard datasArr.count > 0 else {
            return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [lineTopNode])
        }
        
        lineBottomNode.style.preferredSize = lineSize
        let titleInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), child: titleNode)
        
        lineNode.style.preferredSize = CGSize(width: dimension - 20, height: 0.5)
        let lineCenterSpec = ASCenterLayoutSpec(centeringOptions: .X, sizingOptions: [], child: lineNode)
        
        tableNode.style.preferredSize = CGSize(width: dimension, height: tableNode.view.contentSize.height)
        
        let buttonCenterSpec = ASCenterLayoutSpec(centeringOptions: .X, sizingOptions: [], child: moreButtonNode)
        
        let stackLayoutSpec = ASStackLayoutSpec(direction: .vertical, spacing: 12, justifyContent: .spaceBetween, alignItems: .stretch, children: [lineTopNode, titleInsetSpec, lineCenterSpec, tableNode])
        if !showAll {
            stackLayoutSpec.children?.append(buttonCenterSpec)
        }
        stackLayoutSpec.children?.append(lineBottomNode)
        return stackLayoutSpec
    }
}

// MARK: private
extension ZQTextureRelationNode {
    
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
    
    private func config() {
        backgroundColor = .white
    }
    
    private func getLineNode() -> ZQASDisplayNode {
        return ZQASDisplayNode().then {
            $0.backgroundColor = UIColor.systemGroupedBackground
        }
    }
}

// MARK: action
extension ZQTextureRelationNode {
    @objc private func actionForMoreButtonNode() {
        showAll = true
        tableNode.reloadDataWithoutFlashing()
    }
}

// MARK: ASTableDataSource & ASTableDelegate
extension ZQTextureRelationNode : ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return (datasArr.count > 2 && !showAll) ? 2 : datasArr.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] () -> ASCellNode in
            let cellNode = ZQTextureRelationCellNode()
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
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        print("--__--|| didSelect__\(indexPath.row)")
    }
}

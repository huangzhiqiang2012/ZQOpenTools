//
//  ZQTextureListCellNode.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/15.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 列表cellNode
class ZQTextureListCellNode: ZQASCellNode {
    
    private lazy var titleNode:ZQASTextNode = ZQASTextNode()
    
    private lazy var coverImageNode:ZQASNetworkImageNode = ZQASNetworkImageNode().then {
        $0.zq.addBorder(withBorderWidth: 0.5, borderColor: UIColor.lightGray.withAlphaComponent(0.5), radius: 4)
    }
    
    private lazy var markImageNode:ZQASImageNode = ZQASImageNode(name: "list_wark")
    
    private lazy var watchButtonNode:ZQASButtonNode = ZQASButtonNode().then {
        $0.setImage(UIImage(named: "detail_watch"), for: .normal)
    }
    
    private lazy var commentButtonNode:ZQASButtonNode = ZQASButtonNode().then {
        $0.setImage(UIImage(named: "detail_comment"), for: .normal)
    }
    
    private lazy var likeButtonNode:ZQASButtonNode = ZQASButtonNode(target: self, action: #selector(actionForLikeButtonNode), forControlEvents: .touchUpInside).then {
        $0.setImage(UIImage(named: "detail_like"), for: .normal)
        $0.setImage(UIImage(named: "detail_like_selected"), for: .selected)
    }
    
    private lazy var lineNode:ZQASDisplayNode = ZQASDisplayNode().then {
        $0.backgroundColor = .lightGray
    }
    
    var model:ZQTextureArticleModel? {
        didSet {
            if let model = model {
                titleNode.show(text: model.title, font: .systemFont(ofSize: 15), color: .black)
                coverImageNode.url = URL(string: ZQTextureViewModel.imageDownloadBaseUrl + (model.photo?.components(separatedBy: ",").first ?? ""))
                watchButtonNode.setTitle("\(model.visitNum)", with: .systemFont(ofSize: 12), with: .lightGray, for: .normal)
                commentButtonNode.setTitle("\(model.commentsNum)", with: .systemFont(ofSize: 12), with: .lightGray, for: .normal)
                likeButtonNode.setTitle("\(model.likesNum)", with: .systemFont(ofSize: 12), with: .lightGray, for: .normal)
                likeButtonNode.setTitle("\(model.likesNum)", with: .systemFont(ofSize: 12), with: .red, for: .selected)
            }
        }
    }
    
    var hideLine:Bool? {
        didSet {
            if let hide = hideLine {
                lineNode.isHidden = hide
            }
        }
    }
}

// MARK: override
extension ZQTextureListCellNode {
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let coverImageSpec = ASRatioLayoutSpec(ratio: 190 / 325, child: coverImageNode)
        markImageNode.style.preferredSize = CGSize(width: 18, height: 28)
        markImageNode.style.layoutPosition = CGPoint(x: 14, y: -3)
        let absoluteSpec = ASAbsoluteLayoutSpec(children: [markImageNode])
        let overlaySpec = ASOverlayLayoutSpec(child: coverImageSpec, overlay: absoluteSpec)
        
        let buttonStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 15, justifyContent: .start, alignItems: .center, children: [watchButtonNode, commentButtonNode, likeButtonNode])
        
        let dimension:CGFloat = constrainedSize.max.width
        lineNode.style.preferredSize = CGSize(width: dimension - 65, height: 0.1)
        lineNode.style.spacingBefore = 10
        let allStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .start, alignItems: .stretch, children: [titleNode, overlaySpec, buttonStackSpec, lineNode])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 15, left: 40, bottom: 0, right: 25), child: allStackSpec)
    }
}

// MARK: action
extension ZQTextureListCellNode {
    @objc private func actionForLikeButtonNode(_ sender:ZQASButtonNode) {
        sender.isSelected.toggle()
        var num = model?.likesNum ?? 0
        num = sender.isSelected ? (num + 1) : (num - 1)
        model?.likesNum = num
        likeButtonNode.setTitle("\(num)", with: .systemFont(ofSize: 12), with: .lightGray, for: .normal)
        likeButtonNode.setTitle("\(num)", with: .systemFont(ofSize: 12), with: .red, for: .selected)
    }
}

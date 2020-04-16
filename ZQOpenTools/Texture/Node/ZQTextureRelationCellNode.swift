//
//  ZQTextureRelationCellNode.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/1.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Texture 模块 相关推荐cell
class ZQTextureRelationCellNode: ZQASCellNode {
    
    private lazy var imageNode:ZQASNetworkImageNode = ZQASNetworkImageNode.defaultNode().then {
        $0.zq.addRadius(radius: 3)
    }
    
    private lazy var titleNode:ZQASTextNode = ZQASTextNode()
    
    private lazy var timeImageNode:ZQASImageNode = ZQASImageNode(name: "detail_time")
    
    private lazy var timeTextNode:ZQASTextNode = ZQASTextNode()
    
    var model:ZQTextureArticleModel? {
        didSet {
            if let model = model {
                imageNode.url = URL(string: ZQTextureViewModel.imageDownloadBaseUrl + (model.photo?.components(separatedBy: ",").first ?? ""))
                titleNode.show(text: model.title, font: .systemFont(ofSize: 14, weight: .semibold), color: .black)
                timeTextNode.show(text: model.createTime, font: .systemFont(ofSize: 13), color: .lightGray)
            }
        }
    }
}

// MARK: override
extension ZQTextureRelationCellNode {
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: 145, height: 75)
        
        timeImageNode.style.preferredSize = CGSize(width: 13, height: 13)
        let timeStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .start, alignItems: .center, children: [timeImageNode, timeTextNode])
        
        let titleTimeStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .spaceBetween, alignItems: .stretch, children: [titleNode, timeStackSpec])
        titleTimeStackSpec.style.flexShrink = 1
        
        let allStackLayoutSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 16, justifyContent: .start, alignItems: .stretch, children: [imageNode, titleTimeStackSpec])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15), child: allStackLayoutSpec)
    }
}

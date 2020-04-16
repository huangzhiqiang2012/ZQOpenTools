//
//  ZQTextureHeaderNode.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/31.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Texture 模块 头部视图
class ZQTextureHeaderNode: ZQASDisplayNode {
    
    private lazy var backImageNode:ZQASNetworkImageNode = ZQASNetworkImageNode.defaultNode().then {
        $0.delegate = self
    }
    
    private lazy var headerImageNode:ZQASNetworkImageNode = ZQASNetworkImageNode.defaultNode().then {
        $0.zq.addRadius(radius: 18)
    }
    
    private lazy var userTypeImageNode:ZQASImageNode = ZQASImageNode(name:"detail_userType")
    
    private lazy var nameTextNode:ZQASTextNode = ZQASTextNode()
    
    private lazy var timeTextNode:ZQASTextNode = ZQASTextNode()
    
    private lazy var titleTextNode:ZQASTextNode = ZQASTextNode()

    private lazy var followButtonNode:ZQASButtonNode = ZQASButtonNode(target: self, action: #selector(actionForFollowButtonNode), forControlEvents: .touchUpInside).then {
        $0.setTitle("关注", with: UIFont.systemFont(ofSize: 13), with: UIColor.blue, for: .normal)
        $0.setTitle("已关注", with: UIFont.systemFont(ofSize: 13), with: UIColor.red, for: .selected)
        $0.zq.addBorder(withBorderWidth: 0.8, borderColor: UIColor.blue, radius: 5)
    }

    private lazy var watchImageNode:ZQASImageNode = ZQASImageNode(name:"detail_watch")
    
    private lazy var watchTextNode:ZQASTextNode = ZQASTextNode()
    
    private lazy var commentImageNode:ZQASImageNode = ZQASImageNode(name:"detail_comment")
    
    private lazy var commentTextNode:ZQASTextNode = ZQASTextNode()
    
    private lazy var likeButtonNode:ZQASButtonNode = ZQASButtonNode(target: self, action: #selector(actionForLikeButtonNode), forControlEvents: .touchUpInside).then {
        $0.setImage(UIImage(named: "detail_like"), for: .normal)
        $0.setImage(UIImage(named: "detail_like_selected"), for: .selected)
    }
    
    private lazy var likeTextNode:ZQASTextNode = ZQASTextNode()
    
    private lazy var lineNode:ZQASDisplayNode = ZQASDisplayNode().then {
        $0.backgroundColor = .lightGray
    }
    
    var model:ZQTextureDetailModel? {
        didSet {
            if let model = model {
                backImageNode.url = URL(string: ZQTextureViewModel.imageDownloadBaseUrl + (model.photo ?? ""))
                headerImageNode.url = URL(string: ZQTextureViewModel.imageDownloadBaseUrl + (model.headimg ?? ""))
                nameTextNode.show(text: model.nickname, font: .systemFont(ofSize: 14), color: .black)
                timeTextNode.show(text: model.createTime, font: .systemFont(ofSize: 11), color: .lightGray)
                titleTextNode.show(text: model.title, font: .systemFont(ofSize: 16, weight: .black), color: .black)
                watchTextNode.show(text: "\(model.visitNum)", font: .systemFont(ofSize: 12), color: .lightGray)
                commentTextNode.show(text: "\(model.commentsNum)", font: .systemFont(ofSize: 12), color: .lightGray)
                likeButtonNode.isSelected = model.islikes
                likeTextNode.show(text: "\(model.likesNum)", font: .systemFont(ofSize: 12), color: .lightGray)
            }
        }
    }
    
    override init() {
        super.init()
        config()
    }
}

// MARK: private
extension ZQTextureHeaderNode {
    private func config() {
        backgroundColor = .white
    }
}

// MARK: override
extension ZQTextureHeaderNode {
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var backImageWidth = backImageNode.image?.size.width ?? UIScreen.main.bounds.size.width
        if backImageWidth == 0 {
            backImageWidth = 100
        }
        let backImageHeight = backImageNode.image?.size.height ?? 1
        let backImageRatioSpec = ASRatioLayoutSpec(ratio: backImageHeight / backImageWidth, child: backImageNode)
        
        userTypeImageNode.style.preferredSize = CGSize(width: 40, height: 40)
        headerImageNode.style.preferredSize = CGSize(width: 36, height: 36)
        let overLayoutSpec = ASOverlayLayoutSpec(child: userTypeImageNode, overlay: headerImageNode)
        
        let nameTimeStackLayoutSpec = ASStackLayoutSpec(direction: .vertical, spacing: 7, justifyContent: .center, alignItems: .start, children: [nameTextNode, timeTextNode])
        
        let headerWithNameHorizontalStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .spaceBetween, alignItems: .center, children: [overLayoutSpec, nameTimeStackLayoutSpec])
        
        followButtonNode.style.preferredSize = CGSize(width: 60, height: 30)
        let userHorizontalStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .spaceBetween, alignItems: .center, children: [headerWithNameHorizontalStackSpec, followButtonNode])
        
        let watchStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                               spacing: 5,
                                               justifyContent: .spaceBetween,
                                               alignItems: .stretch,
                                               children: [watchImageNode, watchTextNode])
        let commentStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                               spacing: 5,
                                               justifyContent: .spaceBetween,
                                               alignItems: .stretch,
                                               children: [commentImageNode, commentTextNode])
        let likeStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                               spacing: 5,
                                               justifyContent: .spaceBetween,
                                               alignItems: .stretch,
                                               children: [likeButtonNode, likeTextNode])
        let threeStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                               spacing: 17,
                                               justifyContent: .start,
                                               alignItems: .stretch,
                                               children: [watchStackSpec, commentStackSpec, likeStackSpec])
        
        let verticalStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .spaceBetween, alignItems: .stretch, children: [userHorizontalStackSpec, titleTextNode, threeStackSpec])
        
        let allInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15), child: verticalStackSpec)
        
        let dimension:CGFloat = constrainedSize.max.width
        lineNode.style.preferredSize = CGSize(width: dimension - 20, height: 0.5)
        let lineCenterSpec = ASCenterLayoutSpec(centeringOptions: .X, sizingOptions: [], child: lineNode)
        
        let stackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .spaceBetween, alignItems: .stretch, children: [backImageRatioSpec, allInsetSpec, lineCenterSpec])
        return stackSpec
    }
}

// MARK: action
extension ZQTextureHeaderNode {
    @objc private func actionForFollowButtonNode(_ sender:ZQASButtonNode) {
        sender.isSelected.toggle()
        sender.borderColor = sender.isSelected ? UIColor.red.cgColor : UIColor.blue.cgColor
    }
    
    @objc private func actionForLikeButtonNode(_ sender:ZQASButtonNode) {
        sender.isSelected.toggle()
        var num = model?.likesNum ?? 0
        num = sender.isSelected ? (num + 1) : (num - 1)
        model?.likesNum = num
        likeTextNode.show(text: "\(num)", font: .systemFont(ofSize: 12), color: sender.isSelected ? .red : .lightGray)
    }
}

// MARK: ASNetworkImageNodeDelegate
extension ZQTextureHeaderNode: ASNetworkImageNodeDelegate {
    func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        transitionLayout(withAnimation: false, shouldMeasureAsync: false)
    }
}

//
//  ZQTextureCommentCellNode.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/4.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Texture 模块 评论cell
class ZQTextureCommentCellNode: ZQASCellNode {
    
    private lazy var headerImageNode:ZQASNetworkImageNode = ZQASNetworkImageNode.defaultNode().then {
        $0.zq.addRadius(radius: 15)
    }
    
    private lazy var nameNode:ZQASTextNode = ZQASTextNode()
    
    private lazy var timeNode:ZQASTextNode = ZQASTextNode()
    
    private lazy var contentNode:ZQASTextNode = ZQASTextNode()
    
    private lazy var likeNode:ZQASButtonNode = ZQASButtonNode(target: self, action: #selector(actionForLikeNode), forControlEvents: .touchUpInside).then {
        $0.setImage(UIImage(named: "detail_like"), for: .normal)
        $0.setImage(UIImage(named: "detail_like_selected"), for: .selected)
    }
    
    private lazy var childCommentNodeArr:[ZQASTextNode] = [ZQASTextNode]()
    
    var model:ZQTextureArticleCommentModel? {
        didSet {
            if let model = model {
                if let fromUser = model.formUserInfo {
                    headerImageNode.url = URL(string: ZQTextureViewModel.imageDownloadBaseUrl + (fromUser.headimg ?? ""))
                    nameNode.attributedText = NSAttributedString(string: fromUser.nickname ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.black])
                    contentNode.attributedText = NSAttributedString(string: model.comment ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black])
                    timeNode.attributedText = NSAttributedString(string: model.createTime ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
                    likeNode.setTitle("\(model.like)", with: .systemFont(ofSize: 14), with: .lightGray, for: .normal)
                    likeNode.setTitle("\(model.like)", with: .systemFont(ofSize: 14), with: .red, for: .selected)
                    likeNode.isSelected = model.isLike
                    addChildComment()
                }
            }
        }
    }
}

// MARK: private
extension ZQTextureCommentCellNode {
    private func addChildComment() {
        guard let childCommentArr = model?.childComment, childCommentArr.count > 0 else { return }
        childCommentNodeArr.removeAll()
        for comment in childCommentArr {
            if let fromUser = comment.formUserInfo, let toUser = comment.toUserInfo {
                var content = ""
                var linkAttributeNames:[String] = [String]()
                let fromName = fromUser.nickname ?? ""
                let commentStr = comment.comment ?? ""
                let toName = toUser.nickname ?? ""
                if fromUser.userId == toUser.userId {
                    content = "\(fromName): \(commentStr)"
                    linkAttributeNames = [fromName, commentStr]
                }
                else {
                    content = "\(fromName) 回复 \(toName): \(commentStr)"
                    linkAttributeNames = [fromName, commentStr, toName]
                }
                let textNode = ZQASTextNode()
                textNode.isUserInteractionEnabled = true
                textNode.delegate = self
                textNode.linkAttributeNames = linkAttributeNames
                let contentAttStr = NSMutableAttributedString(string: content, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black])
                contentAttStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], range: (content as NSString).range(of: fromName))
                contentAttStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], range: (content as NSString).range(of: toName))
                var valueArr:[String] = [String]()
                for i in 0..<linkAttributeNames.count {
                    let attributeName = linkAttributeNames[i]
                    if i == 0 {
                        valueArr.append(fromName)
                        valueArr.append(fromUser.userId ?? "")
                    }
                    else if i == linkAttributeNames.count - 1 {
                        valueArr.removeAll()
                        valueArr.append(toName)
                        valueArr.append(toUser.userId ?? "")
                    }
                    else {
                        valueArr.append(comment.id ?? "")
                    }
                    contentAttStr.addAttributes([NSAttributedString.Key(rawValue: attributeName) : valueArr], range: (content as NSString).range(of: attributeName))
                }
                textNode.attributedText = contentAttStr
                childCommentNodeArr.append(textNode)
            }
        }
    }
}

// MARK: action
extension ZQTextureCommentCellNode {
    @objc private func actionForLikeNode(_ sender:ZQASButtonNode) {
        sender.isSelected.toggle()
        var num = model?.like ?? 0
        num = sender.isSelected ? (num + 1) : (num - 1)
        model?.like = num
        if sender.isSelected {
            likeNode.setTitle("\(num)", with: .systemFont(ofSize: 14), with: .red, for: .selected)
        }
        else {
            likeNode.setTitle("\(num)", with: .systemFont(ofSize: 14), with: .lightGray, for: .normal)
        }
    }
}

// MARK: override
extension ZQTextureCommentCellNode {
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let nameTimeStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 3, justifyContent: .start, alignItems: .start, children: [nameNode, timeNode])

        likeNode.style.preferredSize = CGSize(width: 60, height: 30)
        let nameTimeLikeStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .start, children: [nameTimeStackSpec, likeNode])

        let allTextStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .spaceBetween, alignItems: .stretch, children: [nameTimeLikeStackSpec, contentNode])
        allTextStackSpec.style.flexGrow =  1
        allTextStackSpec.style.flexShrink = 1
        
        if childCommentNodeArr.count > 0 {
            let childCommentStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .spaceBetween, alignItems: .stretch, children: childCommentNodeArr)
            childCommentStackSpec.style.flexShrink = 1
            let whiteBackgroundNode = ZQASDisplayNode().then {
                $0.backgroundColor = .white
            }
            let grayBackgroundNode = ZQASDisplayNode().then {
                $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
            }
            let whiteBackgroundInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: -3, left: 5, bottom: -3, right: 0), child: childCommentStackSpec)
            let childCommentBgSpec = ASBackgroundLayoutSpec(child: whiteBackgroundInsetSpec, background: whiteBackgroundNode)
            let childCommentInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0), child: childCommentBgSpec)
            let grayBgSpec = ASBackgroundLayoutSpec(child: childCommentInsetSpec, background: grayBackgroundNode)
            allTextStackSpec.children?.append(grayBgSpec)
        }
        headerImageNode.style.preferredSize = CGSize(width: 30, height: 30)
        let headerAllTextStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 5, justifyContent: .start, alignItems: .start, children: [headerImageNode, allTextStackSpec])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15), child: headerAllTextStackSpec)
    }
}

// MARK: ASTextNodeDelegate
extension ZQTextureCommentCellNode : ASTextNodeDelegate {
    func textNode(_ textNode: ASTextNode!, tappedLinkAttribute attribute: String!, value: Any!, at point: CGPoint, textRange: NSRange) {
//        print("--__--|| attribute___\(attribute), value___\(value), point___\(point), textRange___\(textRange)")
        let valueArr = value as! Array<String>
        if let commentId = valueArr[safe: 2] {
            print("--__--|| 点击了评论 commentId__\(commentId)")
        }
        else if let userName = valueArr[safe: 0], let userId = valueArr[safe: 1] {
            print("--__--|| 点击了名字 userName__\(userName), userId__\(userId)")
        }
    }
}

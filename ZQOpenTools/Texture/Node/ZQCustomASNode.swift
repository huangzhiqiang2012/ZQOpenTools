//
//  ZQCustomASNode.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/31.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

class ZQASNetworkImageNode: ASNetworkImageNode {
    
    /// 不能这样重写
//    override init() {
//        super.init()
//        placeholderFadeDuration = 0.2
//        placeholderColor = .lightGray
//        placeholderEnabled = true
//        contentMode = .scaleAspectFit
//        shouldRenderProgressImages = true
//        needsDisplayOnBoundsChange = true
//    }
    
     static func defaultNode() -> ZQASNetworkImageNode {
        let node = ZQASNetworkImageNode()
        node.placeholderFadeDuration = 0.2
        node.placeholderColor = UIColor.lightGray.withAlphaComponent(0.3)
        node.placeholderEnabled = true
        node.contentMode = .scaleAspectFit
        node.shouldRenderProgressImages = true
        node.needsDisplayOnBoundsChange = true
        return node
    }
}

class ZQASImageNode: ASImageNode {
    override init() {
        super.init()
        placeholderFadeDuration = 0.2
        placeholderColor = UIColor.lightGray.withAlphaComponent(0.3)
        placeholderEnabled = true
        contentMode = .scaleAspectFit
        needsDisplayOnBoundsChange = true
    }
    convenience init(name:String) {
        self.init()
        image = UIImage(named: name)
    }
}

class ZQASTextNode: ASTextNode {
    override init() {
        super.init()
        placeholderFadeDuration = 0.2
        placeholderEnabled = true
        placeholderColor = UIColor.lightGray.withAlphaComponent(0.3)
        truncationMode = .byTruncatingTail;
        needsDisplayOnBoundsChange = true
    }
    
    func show(text:String?, font:UIFont = UIFont.systemFont(ofSize: 17), color:UIColor = UIColor.black) {
        if let text = text {
            attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : color])
        }
    }
}

class ZQASButtonNode: ASButtonNode {
    convenience init(target:Any?, action:Selector, forControlEvents:ASControlNodeEvent) {
        self.init()
        addTarget(target, action: action, forControlEvents: forControlEvents)
    }
}

class ZQASTableNode: ASTableNode {
    override init(style: UITableView.Style) {
        super.init(style: style)
        view.separatorStyle = .none
    }
    
    convenience init(style:UITableView.Style = .plain, dataSource:ASTableDataSource, delegate:ASTableDelegate) {
        self.init(style:style)
        self.dataSource = dataSource
        self.delegate = delegate
    }
}

class ZQASCellNode: ASCellNode {
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        selectionStyle = .none
    }
}

class ZQASScrollNode: ASScrollNode {
    override init() {
        super.init()
        automaticallyManagesContentSize = true
        automaticallyManagesSubnodes = true
    }
}

class ZQASDisplayNode: ASDisplayNode {
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
}

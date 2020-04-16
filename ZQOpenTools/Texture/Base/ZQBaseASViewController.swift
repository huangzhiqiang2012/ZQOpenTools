//
//  ZQBaseASViewController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/31.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 基类 
class ZQBaseASViewController: ASViewController<ASDisplayNode> {
    
    deinit {
        print("--__--|| \(self.classForCoder) dealloc")
    }
    
    lazy var contentNode:ZQASDisplayNode = ZQASDisplayNode().then {
        var height = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
        if let navigationController = self.navigationController {
            height += navigationController.navigationBar.bounds.size.height
        }
        $0.frame = CGRect(x: 0, y: 0, width: node.bounds.size.width, height: node.bounds.size.height - height)
        $0.backgroundColor = .white
        node.addSubnode($0)
        
        /// 设置了 automaticallyManagesSubnodes, 不需手动添加和移除 subNodes
    }
    
    /**
     这个方法只调用一次，是在 ASViewController 的生命周期的最开始的时候调用。在它初始化的过程中，不要使用 self.view 或者 self.node.view ，它会强制 view 被提前创建。这些事情应该在 viewDidLoad 中完成。
     ASViewController 的初始化方法是 initWithNode: ，代码如下所示。一个 ASViewController 管理节点就像 UIViewController 管理 view 一样，但是初始化的过程有小小的差异。
     */
    init() {
        let node = ZQASDisplayNode().then {
            $0.backgroundColor = .white
        }
        super.init(node: node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

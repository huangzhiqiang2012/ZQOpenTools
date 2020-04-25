//
//  ZQBaseCollectionReusableView.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/23.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 基础分区头尾
class ZQBaseCollectionReusableView: UICollectionReusableView {
    
    /// 解决iOS 11 滚动时,遮挡住滚动条的问题--__--||
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.zPosition = 0
    }
}

//
//  ZQIGListKitCollectionSectionHeaderView.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/23.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 分区头
class ZQIGListKitCollectionSectionHeaderView: ZQBaseCollectionReusableView {
    
    private lazy var titleLabel:UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20)
    }
    
    var title:String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var textColor:UIColor? {
        didSet {
            if let color = textColor {
                titleLabel.textColor = color
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (m) in
            m.leading.equalTo(15)
            m.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

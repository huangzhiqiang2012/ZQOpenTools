//
//  ZQKTVHTTPCacheCollectionViewCell.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/6/22.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

class ZQKTVHTTPCacheCollectionViewCell: UICollectionViewCell {
    lazy var titleLabel:UILabel = UILabel().then {
        $0.textColor = .brown
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (m) in
            m.leading.equalTo(15)
            m.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

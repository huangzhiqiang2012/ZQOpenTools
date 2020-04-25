//
//  ZQNewsCollectionViewCell.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/23.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 新闻cell
class ZQNewsCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZQNewsCollectionViewCell : ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? ZQDiffableBox<ZQIGListKitNewModel> else { return }
        let model = viewModel.value
        titleLabel.text = model.title
        titleLabel.textColor = model.color
    }
}

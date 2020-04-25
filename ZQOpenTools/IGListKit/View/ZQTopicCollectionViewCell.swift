//
//  ZQTopicCollectionViewCell.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/23.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 话题cell
class ZQTopicCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
        }
        
        /// 不能自适应高度,只能在外面计算--__--||
//        titleLabel.snp.makeConstraints { (m) in
//            m.leading.equalTo(15)
//            m.trailing.equalTo(-15)
//            m.top.equalTo(10)
//            m.height.equalTo(80)
//            m.bottom.equalTo(-10).priority(.high)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZQTopicCollectionViewCell : ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? ZQDiffableBox<ZQIGListKitTopicModel> else { return }
        let model = viewModel.value
        titleLabel.text = model.title
        titleLabel.textColor = model.color
    }
}

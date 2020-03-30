//
//  ZQKingfisherController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/29.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Kingfisher控制器
class ZQKingfisherController: ZQBaseController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: private
extension ZQKingfisherController {
    private func setupViews() {
        for i in 0..<2 {
            let imageView = UIImageView()
            imageView.zq.setImage(urlStr: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585549454825&di=c7e3be2174ca31f5b391eae7a1110e35&imgtype=0&src=http%3A%2F%2Fimg3.doubanio.com%2Fview%2Fnote%2Fl%2Fpublic%2Fp51213326.jpg")
            view.addSubview(imageView)
            imageView.snp.makeConstraints { (m) in
                m.width.height.equalTo(200)
                m.top.equalTo(40 + (i) * 220)
                m.centerX.equalToSuperview()
            }
        }
    }
}

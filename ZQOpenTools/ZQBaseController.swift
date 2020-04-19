//
//  ZQBaseController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/7.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 基础控制器
class ZQBaseController: UIViewController {
    
    deinit {
        print("--__--|| \(self.classForCoder) dealloc")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        baseConfig()
        setupViews()
    }
}

// MARK: private
extension ZQBaseController {
    private func baseConfig() {
        view.backgroundColor = .white

        /// 解决scrollView被导航栏遮住问题
        edgesForExtendedLayout = []
        
        /// 设置edgesForExtendedLayout后导航栏变灰,需要设置这个
        navigationController?.navigationBar.isTranslucent = false
    }
}

// MARK: public
extension ZQBaseController {
    @objc func setupViews() {}
}

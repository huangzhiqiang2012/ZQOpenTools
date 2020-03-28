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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseViews()
    }
}

// MARK: private
extension ZQBaseController {
    private func setupBaseViews() {
        view.backgroundColor = .white
    }
}

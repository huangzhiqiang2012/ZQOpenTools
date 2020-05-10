//
//  ZQIQKeyboardManagerController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/5/8.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// IQKeyboardManager 控制器
class ZQIQKeyboardManagerController: ZQBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backView = UIView().then {
            $0.backgroundColor = .brown
        }
        let textView = UITextView().then {
            $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
        backView.addSubview(textView)
        view.addSubview(backView)
        backView.snp.makeConstraints { (m) in
            m.width.height.equalTo(200)
            m.centerX.equalToSuperview()
            m.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        textView.snp.makeConstraints { (m) in
            m.width.height.equalTo(100)
            m.center.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
}

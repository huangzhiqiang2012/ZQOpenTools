//
//  ZQPanModalController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/5/10.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// PanModal 控制器
class ZQPanModalController: ZQBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        let button = UIButton(type: .custom).then {
            $0.backgroundColor = .brown
            $0.setTitle("present", for: .normal)
            $0.zq.addRadius(radius: 15)
            $0.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        }
        view.addSubview(button)
        button.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
            m.width.equalTo(100)
            m.height.equalTo(30)
        }
    }
    
    @objc private func actionForButton(_ sender:UIButton) {
        presentPanModal(ZQShowInfoController())
    }
}

/// 基础控制器
class ZQPanModalBaseController: ZQBaseController, PanModalPresentable {
    var panScrollable: UIScrollView? { return nil }
    
    /// 父类实现, 子类重写,才能生效 --__--||
    var shortFormHeight: PanModalHeight {
        return .contentHeight(100)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
}

/// 显示信息控制器
class ZQShowInfoController: ZQPanModalBaseController {
        
    override var shortFormHeight: PanModalHeight {
        return .contentHeight(500)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        let label = UILabel().then {
            $0.backgroundColor = .blue
            $0.text = "这是标题"
        }
        let textView = UITextView().then {
            $0.backgroundColor = .brown
            $0.text = "代付发大幅度看风景的看法觉得的房价的看法京东方快递费大幅度发到付大幅度发到付大幅度发大幅度发的"
        }
        view.zq.addSubViews([label, textView])
        label.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalTo(50)
        }
        textView.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalTo(label.snp.bottom).offset(50)
            m.width.equalTo(100)
            m.height.equalTo(50)
        }
    }
}

//
//  ZQToastController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/30.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Toast-Swift 控制器
class ZQToastController: ZQBaseController {
    
    private let defaultButtonTag:Int = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        let width = 100
        let height = 30
        let gap = 50
        for i in 0..<6 {
            let button = UIButton(type: .custom).then {
                $0.backgroundColor = .brown
                $0.zq.addRadius(radius: 15)
                $0.setTitle("Button", for: .normal)
                $0.tag = defaultButtonTag + i
                $0.addTarget(self, action: #selector(actionForButt), for: .touchUpInside)
            }
            view.addSubview(button)
            button.snp.makeConstraints { (m) in
                m.top.equalTo(gap + (gap + height) * i)
                m.centerX.equalToSuperview()
                m.size.equalTo(CGSize(width: width, height: height))
            }
        }
    }
}

// MARK: action
extension ZQToastController {
    @objc private func actionForButt(_ sender: UIButton) {
        view.hideAllToasts()
        
        let index = sender.tag - defaultButtonTag
        switch index {
        case 0:
            view.makeToast("This is a piece of toast")
            
        case 1:
            view.makeToast("This is a piece of toast", duration: 3.0, position: .top)
            
        case 2:
            view.makeToast("This is a piece of toast", duration: 2.0, point: view.center, title: "Toast Title", image: UIImage(named: "popMenu_kefu")) { (didTap) in
                if didTap {
                    print("--__--|| completion from tap")
                }
                else {
                    print("completion without tap")
                }
            }
            
        case 3:
            view.makeToastActivity(.center)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.view.hideToastActivity()
            }
            
        case 4:
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
            label.backgroundColor = .red
            label.text = "自定义视图"
            label.textAlignment = .center
            view.showToast(label, position: .center)
            
        case 5:
            var style = ToastStyle()
            style.messageColor = .red
            ToastManager.shared.style = style
            ToastManager.shared.isTapToDismissEnabled = true
            ToastManager.shared.isQueueEnabled = true
            view.makeToast("This is a piece of toast", duration: 3.0, position: .center)
        default: break
        }
    }
}

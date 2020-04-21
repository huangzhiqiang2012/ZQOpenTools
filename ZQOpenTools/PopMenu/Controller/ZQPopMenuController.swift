//
//  ZQPopMenuController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/20.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// PopMenu控制器
class ZQPopMenuController: ZQBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        let button0 = UIButton(type: .custom).then {
            $0.backgroundColor = .blue
            $0.setTitle("NewPopMenu", for: .normal)
            $0.zq.addRadius(radius: 15)
            $0.addTarget(self, action: #selector(actionForButton0(_:)), for: .touchUpInside)
        }
        view.addSubview(button0)
        button0.snp.makeConstraints { (m) in
            m.top.equalTo(50)
            m.size.equalTo(CGSize(width: 150, height: 30))
            m.centerX.equalToSuperview()
        }
        
        
        let button1 = UIButton(type: .custom).then {
            $0.backgroundColor = .brown
            $0.setTitle("YBPopupMenu", for: .normal)
            $0.zq.addRadius(radius: 15)
            $0.addTarget(self, action: #selector(actionForButton1(_:)), for: .touchUpInside)
        }
        view.addSubview(button1)
        button1.snp.makeConstraints { (m) in
            m.top.equalTo(button0.snp.bottom).offset(50)
            m.size.centerX.equalTo(button0)
        }
    }
}

// MARK: action
extension ZQPopMenuController {
    @objc private func actionForButton0(_ sender:UIButton) {
        let actions = [
            PopMenuDefaultAction(title: "消息", image: UIImage(named: "popMenu_msg")),
            PopMenuDefaultAction(title: "首页", image: UIImage(named: "popMenu_home")),
            PopMenuDefaultAction(title: "客服", image: UIImage(named: "popMenu_kefu")),
            PopMenuDefaultAction(title: "分享", image: UIImage(named: "popMenu_share"))
        ]
        let appearance = PopMenuAppearance()
        appearance.popMenuItemSeparator = .fill()
        let menuController = PopMenuViewController(sourceView: sender, actions: actions, appearance: appearance)
        menuController.delegate = self
        navigationController?.present(menuController, animated: true, completion: nil)
    }
    
    @objc private func actionForButton1(_ sender:UIButton) {
        YBPopupMenu.showRely(on: sender, titles: ["消息", "首页", "客服", "分享"], icons: ["popMenu_msg", "popMenu_home", "popMenu_kefu", "popMenu_share"], menuWidth: 100) { (popupMenu) in
            popupMenu?.delegate = self
            popupMenu?.type = .dark
        }
        
//        YBPopupMenu.show(at: CGPoint(x: sender.center.x, y: sender.frame.maxY + 90),titles: ["消息", "首页", "客服", "分享"], icons: ["popMenu_msg", "popMenu_home", "popMenu_kefu", "popMenu_share"], menuWidth: 100) { (popupMenu) in
//            popupMenu?.delegate = self
//            popupMenu?.type = .dark
//        }
    }
}

// MARK: PopMenuViewControllerDelegate
extension ZQPopMenuController : PopMenuViewControllerDelegate {
    func popMenuDidSelectItem(_ popMenuViewController: PopMenuViewController, at index: Int) {
        let title = popMenuViewController.actions[index].title
        print("--__--|| popMenu did selected title___\(title)")
    }
}

// MARK: YBPopupMenuDelegate
extension ZQPopMenuController : YBPopupMenuDelegate {
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        let title = ybPopupMenu.titles[index]
        print("--__--|| popupMenu did selected title___\(title)")
    }
}

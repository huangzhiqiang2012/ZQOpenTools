//
//  ZQRootController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/7.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 根视图控制器
class ZQRootController: ZQBaseController {
    
    private lazy var tableView:UITableView = UITableView(frame: .zero).then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        $0.delegate = self
        $0.dataSource = self
    }
    
    private let datasArr:[String] = ["Promise", "Moya", "Lottie", "Refresh"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: private
extension ZQRootController {
    private func setupViews() {
        title = "OpenTools"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (m) in
            m.leading.top.trailing.equalToSuperview()
            m.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension ZQRootController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = datasArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = datasArr[indexPath.row]
        let classStr = "ZQ\(title)Controller"
        let vc = classStr.getViewControllerClass()
        if !vc.isKind(of: UIViewController.self) {
            return
        }
        (vc as! UIViewController).title = title
        navigationController?.pushViewController(vc as! UIViewController, animated: true)
    }
}


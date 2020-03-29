//
//  ZQRefreshController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/29.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 刷新控制器
class ZQRefreshController: ZQBaseController {
    
    private lazy var datasArrr:[String] = {
        var arr:[String] = [String]()
        for i in 0..<10 {
            arr.append("\(i)")
        }
        return arr
    }()
    
    private lazy var tableView0:UITableView = getTableView()
    
    private lazy var tableView1:UITableView = getTableView()
    
    deinit {
        tableView0.zq.removeDGElasticRefresh()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addRefresh()
    }
}

// MARK: private
extension ZQRefreshController {
    
    private func getTableView() -> UITableView {
        return UITableView(frame: .zero).then {
            $0.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
            $0.dataSource = self
        }
    }
    
    private func setupViews() {
        view.addSubview(tableView0)
        view.addSubview(tableView1)
        tableView0.snp.makeConstraints { (m) in
            m.top.leading.trailing.equalToSuperview()
            m.height.equalTo(300)
        }
        tableView1.snp.makeConstraints { (m) in
            m.leading.trailing.height.equalTo(tableView0)
            m.top.equalTo(tableView0.snp.bottom).offset(20)
        }
    }
    
    private func addRefresh() {
        
        /// DGElasticPullToRefresh
        tableView0.zq.addDGElasticRefresh {[weak self] in
            self?.tableView0.zq.stopDGElasticRefresh()
        }
        
        /// MJRefresh
        tableView1.zq.addMJRefreshHeader {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.tableView1.zq.stopMJRefreshHeader()
            }
        }
        tableView1.zq.addMJRefreshFooter {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.tableView1.zq.stopMJRefreshFooterWithNoMoreData()
            }
        }
    }
}

// MARK: UITableViewDataSource
extension ZQRefreshController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasArrr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = datasArrr[indexPath.row]
        return cell
    }

}

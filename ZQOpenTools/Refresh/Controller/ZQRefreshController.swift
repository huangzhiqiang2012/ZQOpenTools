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
    
    /**
     默认情况下，下拉一个tableView，在松手之后，会弹回初始的位置。而下拉刷新控件，就是将自己放在tableView的上方，初始y设置成负数，所以平时不会显示出来，只有下拉的时候才会出现，放开又会弹回去。然后在loading的时候，临时把contentInset增大，相当于把tableView往下挤，于是下拉刷新的控件就会显示出来，然后刷新完成之后，再把contentInset改回原来的值，实现回弹的效果
     */
    
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
                self?.tableView1.zq.endMJRefreshHeader()
            }
        }
        tableView1.zq.addMJRefreshFooter {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.tableView1.zq.endMJRefreshFooterWithNoMoreData()
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

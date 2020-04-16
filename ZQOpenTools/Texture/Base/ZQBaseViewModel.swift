//
//  ZQBaseViewModel.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/4.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 基础viewModel
class ZQBaseViewModel: NSObject, ZQPageFetchProtocol {
    var pageFetchAdater: ZQPageFetchAdater = ZQPageFetchAdater()

    var perPage: Int {
        return 2
    }
    
    /// 添加 @objc dynamic, 子类才能在extension里面override
    @objc dynamic func injectData(_ datas: [AnyObject], isFirstFetch: Bool) {}
}

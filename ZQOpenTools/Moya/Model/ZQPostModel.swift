//
//  ZQPostModel.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/25.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

class ZQBaseModel: HandyJSON {
    required init() {}
}

class ZQPostModel: ZQBaseModel {
    var id: Int?
    var title: String?
    var body: String?
    var userId: Int?
}

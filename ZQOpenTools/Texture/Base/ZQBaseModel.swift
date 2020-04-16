//
//  ZQBaseModel.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/4.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

class ZQBaseModel: HandyJSON {
    required init() {}
}

class ZQBaseResModel: ZQBaseModel {
    var ret:Int?
    var msg:String?
}

//
//  ZQKTVHTTPCacheModel.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/6/22.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

class ZQKTVHTTPCacheModel: NSObject {

    var title:String?
    
    var url:String?
    
    convenience init(title:String?, url:String?) {
        self.init()
        self.title = title
        self.url = url
    }
}

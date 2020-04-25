//
//  ZQIGListKitModel.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/23.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// IGListKit 数据模型
class ZQIGListKitModel: ZQBaseModel {
    
    var topic:ZQIGListKitTopicModel?
    
    var course:ZQIGListKitCourseModel?
    
    var news:ZQIGListKitNewsModel?
}

class ZQIGListKitTopicModel: ZQBaseModel {
    var title:String = "这是话题"
    
    var color:UIColor = .red
}

class ZQIGListKitCourseModel: ZQBaseModel {
    var title:String = "这是课程"
    
    var color:UIColor = .green
}

class ZQIGListKitNewsModel: ZQBaseModel {
    var content:[ZQIGListKitNewModel] = [ZQIGListKitNewModel]()
}

class ZQIGListKitNewModel: ZQBaseModel {
    var title:String = "这是新闻"
    
    var color:UIColor = .orange
}


class ZQDiffableBox<T>: NSObject, ListDiffable where T: ZQBaseModel {
    
    var value: T
    
    init(value: T) {
        self.value = value
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let box = object as? ZQDiffableBox<T> else { return false }
        return value == box.value
    }
}

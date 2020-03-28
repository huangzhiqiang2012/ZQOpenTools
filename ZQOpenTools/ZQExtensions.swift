//
//  ZQExtensions.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/7.
//  Copyright © 2020 Darren. All rights reserved.
//

extension String {
    
    /// 获取控制器的class
    func getViewControllerClass() -> AnyObject {
        
        // 根据字符串获取对应的class，在Swift中不能直接使用
        // Swift中命名空间的概念
        guard let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            print("没有命名空间")
            return NSNull()
        }
        
        guard let childVcClass = NSClassFromString(nameSpace + "." + self) else {
            print("没有获取到对应的class")
            return NSNull()
        }
        
        guard let childVcType = childVcClass as? UIViewController.Type else {
            print("没有得到的类型")
            return NSNull()
        }
        
        // 根据类型创建对应的对象
        let vc = childVcType.init()
        return vc
    }
}

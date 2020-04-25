//
//  ZQMoyaManager.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/7.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

fileprivate class ZQMoyaDisposeBag: NSObject {
    static let `default` = ZQMoyaDisposeBag()
    
    fileprivate let disposeBag = DisposeBag()
}

class ZQMoyaManager<T> where T: HandyJSON {
    
}

// MARK: public
extension ZQMoyaManager {
    
    /// 请求Api,返回对象数据模型
    /// - Parameters:
    ///   - target: 接口
    ///   - type: 返回的数据模型
    static func callApiMapObject<R: TargetType>(_ target: R) -> Promise<T> {
        if let request = try? MoyaProvider.defaultEndpointMapping(for: target).urlRequest(),
            let url = request.url {
            let urlStr = url.absoluteString
            print("--__--|| CallApi Url___\(urlStr)")
        }
        let provider = MoyaProvider<R>()
        return Promise<T> { seal in
            provider.rx.request(target).mapObjectResponse(type: T.self).subscribe(onNext: { (model) in
                seal.fulfill(model)
            }, onError: { (error) in
                seal.reject(error)
            }).disposed(by: ZQMoyaDisposeBag.default.disposeBag)
        }
    }
    
    /// 请求Api,返回对象数组
    /// - Parameters:
    ///   - target: 接口
    ///   - type: 返回的数据模型
    static func callApiMapArray<R: TargetType>(_ target: R) -> Promise<[T]> {
        if let request = try? MoyaProvider.defaultEndpointMapping(for: target).urlRequest(),
            let url = request.url {
            let urlStr = url.absoluteString
            print("--__--|| CallApi Url___\(urlStr)")
        }
        let provider = MoyaProvider<R>()
        return Promise<[T]> { seal in
            provider.rx.request(target).mapArrayResponse(type: T.self).subscribe(onNext: { (model) in
                seal.fulfill(model)
            }, onError: { (error) in
                seal.reject(error)
            }).disposed(by: ZQMoyaDisposeBag.default.disposeBag)
        }
    }
}

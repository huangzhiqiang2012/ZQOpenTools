//
//  ZQMoyaManager.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/7.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

class ZQMoyaManager: NSObject {
    static let `default` = ZQMoyaManager()
    
    private let disposeBag = DisposeBag()
}

// MARK: public
extension ZQMoyaManager {
    
    /// 首页请求Api,返回对象数据模型
    /// - Parameters:
    ///   - target: 接口
    ///   - type: 返回的数据模型
    static func callHomeApiMapObject<T: HandyJSON>(_ target:ZQHomeMoyaAPI, type: T.Type) -> Promise<T> {
        if let request = try? MoyaProvider.defaultEndpointMapping(for: target).urlRequest(),
            let url = request.url {
            let urlStr = url.absoluteString
            print("--__--|| CallApi Url___\(urlStr)")
        }
        let provider = MoyaProvider<ZQHomeMoyaAPI>()
        return Promise<T> { seal in
            provider.rx.request(target).mapObjectResponse(type: type).subscribe(onNext: { (model) in
                seal.fulfill(model)
            }, onError: { (error) in
                seal.reject(error)
            }).disposed(by: ZQMoyaManager.default.disposeBag)
        }
    }
    
    /// 首页请求Api,返回对象数组
    /// - Parameters:
    ///   - target: 接口
    ///   - type: 返回的数据模型
    static func callHomeApiMapArray<T: HandyJSON>(_ target:ZQHomeMoyaAPI, type: T.Type) -> Promise<[T]> {
        if let request = try? MoyaProvider.defaultEndpointMapping(for: target).urlRequest(),
            let url = request.url {
            let urlStr = url.absoluteString
            print("--__--|| CallApi Url___\(urlStr)")
        }
        let provider = MoyaProvider<ZQHomeMoyaAPI>()
        return Promise<[T]> { seal in
            provider.rx.request(target).mapArrayResponse(type: type).subscribe(onNext: { (model) in
                seal.fulfill(model)
            }, onError: { (error) in
                seal.reject(error)
            }).disposed(by: ZQMoyaManager.default.disposeBag)
        }
    }
    
    /// Texture模块请求Api,返回对象数据模型
    /// - Parameters:
    ///   - target: 接口
    ///   - type: 返回的数据模型
    static func callTextureApiMapObject<T: HandyJSON>(_ target:ZQTextureAPI, type: T.Type) -> Promise<T> {
        if let request = try? MoyaProvider.defaultEndpointMapping(for: target).urlRequest(),
            let url = request.url {
            let urlStr = url.absoluteString
            print("--__--|| CallApi Url___\(urlStr)")
        }
        let provider = MoyaProvider<ZQTextureAPI>()
        return Promise<T> { seal in
            provider.rx.request(target).mapObjectResponse(type: type).subscribe(onNext: { (model) in
                seal.fulfill(model)
            }, onError: { (error) in
                seal.reject(error)
            }).disposed(by: ZQMoyaManager.default.disposeBag)
        }
    }
}

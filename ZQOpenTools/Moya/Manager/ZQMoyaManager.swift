//
//  ZQMoyaManager.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/7.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

class ZQMoyaManager<T> where T: HandyJSON {
    
    private let disposeBag = DisposeBag()
    
    // 超时时间
    private let timeoutInterval:TimeInterval = 30
    
    // 用来处理只请求一次的栅栏队列
    private let barrierQueue = DispatchQueue(label: "cn.darren.ZQOpenTools.ZQMoyaManager", attributes: .concurrent)
    
    // 用来处理只请求一次的数组, 保存请求的信息 唯一
    private var fetchRequestKeys = [String]()
    
    deinit {
        print("--__--|| ZQMoyaManager dealloc")
    }
}

// MARK: private
extension ZQMoyaManager {
    
    private func getUrlStr<R: TargetType>(_ target: R) -> String {
        if let request = try? MoyaProvider.defaultEndpointMapping(for: target).urlRequest(),
            let url = request.url {
            let urlStr = url.absoluteString
            return urlStr
        }
        return ""
    }
    
    private func isSameRequest<R: TargetType>(_ target: R) -> Bool {
        let urlStr = getUrlStr(target)
        print("--__--|| CallApi Url___\(urlStr)")
        var result: Bool!
        barrierQueue.sync(flags: .barrier) {
            result = fetchRequestKeys.contains(urlStr)
            if !result {
                fetchRequestKeys.append(urlStr)
            }
        }
        return result
    }
    
    private func cleanRequest<R: TargetType>(_ target: R) {
        let urlStr = getUrlStr(target)
        barrierQueue.sync(flags: .barrier) {
            fetchRequestKeys.removeElement(urlStr)
        }
    }
    
    private func createProvide<T: TargetType>(target: T) -> MoyaProvider<T> {
        let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<T>.RequestResultClosure) in
            do {
                var urlRequest = try endpoint.urlRequest()
                urlRequest.timeoutInterval = self.timeoutInterval
                done(.success(urlRequest))
            }
            catch {
                let error = MoyaError.requestMapping(endpoint.url)
                done(.failure(error))
            }
        }
        return MoyaProvider<T>(requestClosure: requestTimeoutClosure, plugins: [NetworkLoggerPlugin()], trackInflights: false)
    }
    
    private func callApiMapObject<R: TargetType>(_ target: R) -> Promise<T> {
        if isSameRequest(target) {
            return Promise(error: MoyaError.requestMapping(getUrlStr(target)))
        }
        let provider = createProvide(target: target)
        return Promise<T> { seal in
            provider.rx.request(target).mapObjectResponse(type: T.self).subscribe(onNext: { (model) in
                seal.fulfill(model)
                self.cleanRequest(target)
            }, onError: { (error) in
                seal.reject(error)
            }).disposed(by: disposeBag)
        }
    }
    
    private func callApiMapArray<R: TargetType>(_ target: R) -> Promise<[T]> {
        if isSameRequest(target) {
            return Promise(error: MoyaError.requestMapping(getUrlStr(target)))
        }
        let provider = createProvide(target: target)
        return Promise<[T]> { seal in
            provider.rx.request(target).mapArrayResponse(type: T.self).subscribe(onNext: { (model) in
                seal.fulfill(model)
                self.cleanRequest(target)
            }, onError: { (error) in
                seal.reject(error)
            }).disposed(by: disposeBag)
        }
    }
}

// MARK: public
extension ZQMoyaManager {
    
    /// 请求Api,返回对象数据模型
    /// - Parameters:
    ///   - target: 接口
    ///   - type: 返回的数据模型
    static func callApiMapObject<R: TargetType>(_ target: R) -> Promise<T> {
        return ZQMoyaManager<T>().callApiMapObject(target)
    }
    
    /// 请求Api,返回对象数组
    /// - Parameters:
    ///   - target: 接口
    ///   - type: 返回的数据模型
    static func callApiMapArray<R: TargetType>(_ target: R) -> Promise<[T]> {
        return ZQMoyaManager<T>().callApiMapArray(target)
    }
}

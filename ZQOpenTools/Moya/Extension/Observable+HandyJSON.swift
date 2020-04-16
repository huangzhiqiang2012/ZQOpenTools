//
//  Observable+HandyJSON.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/9.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 错误提示
enum ZQRxSwiftMoyaError: String {
    case parseJSONError
    case otherError
}

extension ZQRxSwiftMoyaError: Swift.Error { }

extension Observable {
    
    /// json => model
    func mapObject<T: HandyJSON>(type: T.Type) -> Observable<T> {
        return self.map { response in
            guard let dic = response as? [String: Any] else {
                throw ZQRxSwiftMoyaError.parseJSONError
            }
//            print("--__--|| dic__\(dic)")
            return T.deserialize(from: dic) ?? T.init()
        }
    }
    
    /// json => array
    func mapArray<T: HandyJSON>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            guard let array = response as? [Any] else {
                throw ZQRxSwiftMoyaError.parseJSONError
            }
            guard let dicts = array as? [[String: Any]] else {
                throw ZQRxSwiftMoyaError.parseJSONError
            }
            return ([T].deserialize(from: dicts) ?? [T].init()) as! [T]
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapObjectResponse<T: HandyJSON>(type: T.Type) -> Observable<T> {
        return self.mapResponse().mapObject(type: type)
    }
    
    func mapArrayResponse<T: HandyJSON>(type: T.Type) -> Observable<[T]> {
        return self.mapResponse().mapArray(type: type)
    }
    
    private func mapResponse() -> Observable<Any> {
        return self.map({ (res) in

            /// 这里统一处理错误码
//            print("--__--|| statusCode___\(res.statusCode)")
            return res
        }).mapJSON().asObservable()
    }
}

//
//  ZQMoyaAPI.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/9.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 首页模块API
enum ZQHomeMoyaAPI {
    case show
}

extension ZQHomeMoyaAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .show:
            return "/posts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .show:
            return .get
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        let params: [String: Any] = [:]
        
//        let bodyParams: [String: Any] = [:]
//        return .requestCompositeParameters(bodyParameters: bodyParams, bodyEncoding: URLEncoding.httpBody, urlParameters: params) // 参数放在HttpBody中
        
        /// 参数放在请求的url中
        return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    }
    
    var headers: [String : String]? {
        return nil
    }
}

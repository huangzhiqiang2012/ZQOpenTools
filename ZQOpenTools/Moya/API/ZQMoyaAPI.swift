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
        
        // post请求时参数放在HttpBody中
//        let bodyParams: [String: Any] = [:]
//        return .requestCompositeParameters(bodyParameters: bodyParams, bodyEncoding: URLEncoding.httpBody, urlParameters: params)
        
        /// 参数放在请求的url中
        return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    }
    
    var headers: [String : String]? {
        return nil
    }
}

/// Texture模块API
enum ZQTextureAPI {
    case list(uid:String, page:Int, perPage:Int)
    case detail(id:String)
    case recommendArticle(id:String)
    case articleComment(id:String, page:Int, perPage:Int)
}

extension ZQTextureAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.91sami.com/api/web")!
    }
    
    var path: String {
        switch self {
        case .list:
            return "v2/article/publish"
        case .detail(let id):
            return "/article/\(id)"
        case .recommendArticle:
            return "/article/articlerelation"
        case .articleComment:
            return "/articlecomment"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var params: [String: Any] = [:]
        params["cp"] = "2"
        params["access-token"] = "ImXP8RBZAblQkdo6DIH9LvPLWIeiTKx6"
        
        switch self {
        case .list(let uid, let page, let perPage):
            params["uid"] = uid
            params["page"] = page
            params["perPage"] = perPage
            
        case .recommendArticle(let id):
            params["aid"] = id
            params["recommend"] = 17
            
        case .articleComment(let id, let page, let perPage):
            params["aid"] = id
            params["page"] = page
            params["perPage"] = perPage
        default:
            break
        }
        
        /// 参数放在请求的url中
        return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    }
    
    var headers: [String : String]? {
        return nil
    }
}

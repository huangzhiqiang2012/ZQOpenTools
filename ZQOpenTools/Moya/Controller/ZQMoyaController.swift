//
//  ZQMoyaController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/7.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Moya控制器
class ZQMoyaController: ZQBaseController {
    
    /**
     Moya是一个基于Alamofire开发的，轻量级的Swift网络层。Moya的可扩展性非常强，可以方便的RXSwift，PromiseKit和ObjectMapper结合。
     Moya中，通过枚举来管理一组API,通过协议TargetType来表示这是一个API请求,
     然后，在进行API请求的时候，要创建MoyaProvider，接着调用Request方法进行实际的请求
     
     模块
     通过功能划分，Moya大致分为几个模块
     1 Request，包括TargetType，Endpoint，Cancellable集中类型
     2 Provider，网络请求的枢纽，Provider会把TargetType转换成Endpoint再转换成URLRequest交给Alamofire去实际执行
     3 Response，回调给上层的数据结构，支持filter，mapJSON等方法
     4 Alamofire封装，通过桥接的方式对上层隐藏alamofire的细节
     5 Plguins，插件。moya提供了插件来给给外部。包括四个方法，这里知道方法就好，后文会具体的讲解插件的方法在何时工作。
     public protocol PluginType {
         func prepare(_ request: URLRequest, target: TargetType) -> URLRequest
         func willSend(_ request: RequestType, target: TargetType)
         func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType)
         func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError>
     }
     
      
         endpointClosure  requestClosure    Plugin:prepare
                  |              |                |
                  |              |                |
     TargetType ----> EndPoint ----> URLRequest ----> stubClosure
                                                      |        |
                               plugin:willSend  <---  |        | ---> plugin:willSend
                                                      |        |
                                                  Alamofire   stub
                                                      |        |
                                                      |        |
      callback <----- Result <----- Respons <--------------------
                  |             |
                  |             |
          plugin:process   plugin:didReceive
     
     Provider这个类是网络请求的枢纽，它接受一个TargetType(请求)，并且通过闭包的方式给上层回调。
     Provider的初始化方法
     public init(endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
     requestClosure: @escaping RequestClosure = MoyaProvider.defaultRequestMapping,
     stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
     callbackQueue: DispatchQueue? = nil,
     session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
     plugins: [PluginType] = [],
     trackInflights: Bool = false)
     
     初始化的时候的几个参数：
     endpointClosure 作用是把TargetType转换成EndPoint，EndPoint是Moya网络请求的一个中间态。
     requestClosure 作用是把Endpoint转换成URLRequest
     stubClosure 是用来桩测试的，也就是模拟服务端假数据，这里先不管。
     session，实际请求的Alamofire的SessionManager
     plugins, 插件
     trackInflights，是否要跟踪重复网络请求
     
     Request
     TargetType到Endpoint的转换是通过闭包endpointClosure来完成的。闭包的输入是TargetType，输出是EndPoint
     
     在初始化Provider的时候，endpointClosure有默认参数，可以看到默认实现只是由Target创建了一个Endpoint
     final class func defaultEndpointMapping(for target: Target) -> Endpoint {
         return Endpoint(
             url: URL(target: target).absoluteString,
             sampleResponseClosure: { .networkResponse(200, target.sampleData) },
             method: target.method,
             task: target.task,
             httpHeaderFields: target.headers
         )
     }
     
     接着，通过requestClosure将Endpoing映射到URLRequest。这是你最后修改Request的机会，同样它也有默认参数。
     final class func defaultRequestMapping(for endpoint: Endpoint, closure: RequestResultClosure) {
         do {
             let urlRequest = try endpoint.urlRequest()
             closure(.success(urlRequest))
         } catch MoyaError.requestMapping(let url) {
             closure(.failure(MoyaError.requestMapping(url)))
         } catch MoyaError.parameterEncoding(let error) {
             closure(.failure(MoyaError.parameterEncoding(error)))
         } catch {
             closure(.failure(MoyaError.underlying(error, nil)))
         }
     }
     对于大部分API请求来说，使用Moya提供的默认闭包映射足以，这样大多数时候根本不需要关心着两个闭包的内容。但是有时候，有一些额外需求，比如对所有API请求增加额外的HTTP Header，moya通过闭包的方式开发者可以去修改这些内容。
     let endpointClosure = { (target: MyTarget) -> Endpoint<MyTarget> in
         let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
         return defaultEndpoint.adding(newHTTPHeaderFields: ["APP_NAME": "MY_AWESOME_APP"])
     }
     
     为什么要引入requestClosure，把底层的URLRequest暴露给外部？
     有些信息只有URLRequest创建之后才能知晓，比如cookie。
     URLRequest属性很多，大多不常用，比如allowsCellularAccess，没必在Moya这一层封装。
     Endpoint到URLRequest的映射是通过闭包回调的方式进行的，意味着你可以异步回调。
     
     为什么要引入Endpoint，不直接映射成URLRequest?也就是说，两步闭包映射变成一步
     为了保证TargetType维持不可变状态（属性全都是只读），同时给外部友好的API。通过Endpoint你可以方便的：添加新的参数,添加HttpHeader….
     
     Stub
     stub是一个测试相关的概念，通过stub你可以返回一些假数据。
     Moya的stub原理很简单，如果Provider决定Stub，那么就返回Endpoint中的假数据；否则就进行实际的网络请求。
     Moya通过StubClosure闭包开决定stub的模式：
     public typealias StubClosure = (Target) -> Moya.StubBehavior
     模式分为三种
     public enum StubBehavior {

         /// Do not stub.
         case never

         /// Return a response immediately.
         case immediate

         /// Return a response after a delay.
         case delayed(seconds: TimeInterval)
     }
     返回数据的时候，就是简单的根据EndPoint中的假数据闭包
     
     Plugin
     Plugin提供了一种插件的机制让你可以在网络请求的关键节点插入代码，比如显示小菊花扽等。
     Plugin没有用范型编程，所以不要尝试在plugin中进行JSON解析然后传递给上层。
     
     Moya提供了四种Plugin：
     AccessTokenPlugin OAuth的Token验证
     CredentialsPlugin 证书
     NetworkActivityPlugin 网络请求状态
     NetworkLoggerPlugin 网络日志
     
     Response
     Moya并没有对Response进行特殊处理，仅仅是把Alamofire层面返回的数据封装成Moya.Response，然后再调用convertResponseToResult进一步封装成Result<Moya.Response, MoyaError>类型交给上层
     public func convertResponseToResult(_ response: HTTPURLResponse?, request: URLRequest?, data: Data?, error: Swift.Error?) ->
         Result<Moya.Response, MoyaError> {
             switch (response, data, error) {
             case let (.some(response), data, .none):
                 let response = Moya.Response(statusCode: response.statusCode, data: data ?? Data(), request: request, response: response)
                 return .success(response)
             case let (.some(response), _, .some(error)):
                 let response = Moya.Response(statusCode: response.statusCode, data: data ?? Data(), request: request, response: response)
                 let error = MoyaError.underlying(error, response)
                 return .failure(error)
             case let (_, _, .some(error)):
                 let error = MoyaError.underlying(error, nil)
                 return .failure(error)
             default:
                 let error = MoyaError.underlying(NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil), nil)
                 return .failure(error)
             }
     }
     如果要对Response进一步转换成JSON，可以用Response的方法，比如
     func mapJSON(failsOnEmptyData: Bool = true) throws -> Any {
         do {
             return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
         } catch {
             if data.count < 1 && !failsOnEmptyData {
                 return NSNull()
             }
             throw MoyaError.jsonMapping(self)
         }
     }
     mapImage()尝试把响应数据转化为UIImage实例 如果不成功将产生一个错误。
     mapJSON()尝试把响应数据映射成一个JSON对象，如果不成功将产生一个错误。
     mapString()把响应数据转化成一个字符串，如果不成功将产生一个错误。
     mapString(atKeyPath:)尝试把响应数据的key Path映射成一个字符串，如果不成功将产生一个错误。
     到这里，Moya做的事情已经很清晰了：提供一种面向协议的接口来进行网络请求的编写；提供灵活的闭包接口来自定义请求；提供插件来让客户端在各个节点去介入网络请求；返回原始的请求数据给层。
     
     Cancel
     网络API请求应该是可以被取消的。也就是说，在发起一个API请求后，客户端应该能够有一个数据结构能够取消这个请求。Moya返回协议Cancellable给客户端
     public protocol Cancellable {

         /// A Boolean value stating whether a request is cancelled.
         var isCancelled: Bool { get }

         /// Cancels the represented request.
         func cancel()
     }
     在内部实现中，引入了一个CancellableWrapper来进行实际的Cancel动作包装，返回的实际实现协议的类型就是它
     internal class CancellableWrapper: Cancellable {
         internal var innerCancellable: Cancellable = SimpleCancellable()

         var isCancelled: Bool { return innerCancellable.isCancelled }

         internal func cancel() {
             innerCancellable.cancel()
         }
     }

     internal class SimpleCancellable: Cancellable {
         var isCancelled = false
         func cancel() {
             isCancelled = true
         }
     }
     
     为什么要用一个CancellableWrapper进行包装呢？
     原因是：
     对于没有实际发出的请求（参数错误），cancel动作直接用SimpleCancellable即可。
     对于实际发出的请求请求，cancel则需要取消实际的网络请求。
     
     Plugin
     moya有一个特别好用的插件Plugin,他可以让你在网络请求的的时候用来编辑请求，响应以及完成副作用。
     moya提供了4种插件
     AccessTokenPlugin OAuth的Token验证
     CredentialsPlugin 证书
     NetworkActivityPlugin 网络请求状态
     NetworkLoggerPlugin 网络日志
     
     plugins里面的对象都遵循协议PluginType, 协议了规定了几种方法，阐述了什么时候会被调用。
     public protocol PluginType {
         /// Called to modify a request before sending.
         func prepare(_ request: URLRequest, target: TargetType) -> URLRequest

         /// Called immediately before a request is sent over the network (or stubbed).
         func willSend(_ request: RequestType, target: TargetType)

         /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
         func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType)

         /// Called to modify a result before completion.
         func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError>
     }
     */
    private lazy var tableView:UITableView = UITableView(frame: .zero).then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        $0.rowHeight = 44
        $0.dataSource = self
    }
    
    private var datasArr:[ZQPostModel] = [ZQPostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
    }
    
    override func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (m) in
            m.leading.trailing.top.equalToSuperview()
            m.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: private
extension ZQMoyaController {
    private func requestData() {
        ZQMoyaManager.callHomeApiMapArray(.show, type: ZQPostModel.self).done { (arr) in
            self.datasArr = arr
            self.tableView.reloadData()
        }.catch { (error) in
            print("--__--|| error___\(error)")
        }
    }
}

// MARK: UITableViewDataSource
extension ZQMoyaController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        let model = datasArr[indexPath.row]
        cell.textLabel?.text = model.title
        return cell
    }
}

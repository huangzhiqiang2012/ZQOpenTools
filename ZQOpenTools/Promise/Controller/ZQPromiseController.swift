//
//  ZQPromiseController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/28.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Promise控制器
class ZQPromiseController: ZQBaseController {
    
    /**
     then & done
     Promise对象就是一个ReactCocoa中的SignalProducer，它可以异步fullfill返回一个成功对象或者reject返回一个错误信号。
     Promise { sink in
         it.requestJson().on(failed: { err in
             sink.reject(err)
         }, value: { data in
             sink.fulfill(data)
         }).start()
     }
     
     接下来就是把它用在各个方法块里面了，例如：
     firstly {
         Promise { sink in
             indicator.show(inView: view, text: text, detailText: nil, animated: true)
             sink.fulfill()
         }
     }.then {
             api.promise(format: .json)
     }.ensure {
             indicator.hide(inView: view, animated: true)
     }.done { data in
             let params = data.result!["args"] as! [String: String]
             assert((Constant.baseParams + Constant.params) == params)
     }.catch { error in
             assertionFailure()
     }
     firstly是可选的，它只能放在第一个，是为了代码能更加的优雅和整齐，他的block里也是return一个Promise。
     then是接在中间的，可以无限多个then相互连接，顾名思义，就像我们讲故事可以不断地有然后、然后、然后...then也是要求返回一个Promise对象的，也就是说，任何一个then都可以抛出一个error，中断事件。
     ensure类似于finally，不管事件是否错误，它都一定会得到执行，ensure不同于finally的是，它可以放在任何位置。
     done是事件结束的标志，它是必须要有的，只有上面的事件都执行成功时，才会最终执行done。
     catch是捕获异常，done之前的任何事件出现错误，都会直接进入catch。
     上面代码的含义就是先显示loading，然后请求api，不管api是否请求成功，都要确保loading隐藏，然后如果成功，则打印数据，否则打印异常。
     
     Guarantee
     Guarantee是Promise的特殊情况，当我们确保事件不会有错误的时候，就可以用Guarantee来代替Promise，有它就不需要catch来捕获异常了：
     firstly {
         after(seconds: 0.1)
     }.done {
         // there is no way to add a `catch` because after cannot fail.
     }
     after是一个延迟执行的方法，它就返回了一个Guarantee对象，因为延迟执行是一定不会失败的，所以我们只需要后续接done就行了。
     
     map
     map是指一次数据的变换，而不是一次事件，例如我们要把从接口返回的json数据转换成对象，就可以用map，map返回的也是一个对象，而不是Promise。
     
     tap
     tap是一个无侵入的事件，类似于Reactivecocoa的doNext，他不会影响事件的任何属性，只是在适当的时机做一些不影响主线的事情，适用于打点：
     firstly {
         foo()
     }.tap {
         print($0)
     }.done {
         //…
     }.catch {
         //…
     }
     
     when
     when是个可以并行执行多个任务的好东西，when中当所有事件都执行完成，或者有任何一个事件执行失败，都会让事件进入下一阶段，when还有一个concurrently属性，可以控制并发执行任务的最多数量：
     firstly {
         Promise { sink in
             indicator.show(inView: view, text: text, detailText: nil, animated: true)
             sink.fulfill()
         }
     }.then {
             when(fulfilled: api.promise(format: .json), api2.promise(format: .json))
     }.ensure {
             indicator.hide(inView: view, animated: true)
     }.done { data, data2 in
             assertionFailure()
             expectation.fulfill()
     }.catch { error in
             assert((error as! APError).description == err.description)
             expectation.fulfill()
     }
     这个方法还是很常用的，当我们要同时等2，3个接口的数据都拿到，再做后续的事情的时候，就适合用when了。
     
     on
     PromiseKit的切换线程非常的方便和直观，只需要在方法中传入on的线程即可：
     firstly {
         user()
     }.then(on: DispatchQueue.global()) { user in
         URLSession.shared.dataTask(.promise, with: user.imageUrl)
     }.compactMap(on: DispatchQueue.global()) {
         UIImage(data: $0)
     }
     哪个方法需要指定线程就在那个方法的on传入对应的线程。
     
     throw
     如果then中需要抛出异常，一种方法是在Promise中调用reject，另一种比较简便的方法就是直接throw：
     firstly {
         foo()
     }.then { baz in
         bar(baz)
     }.then { result in
         guard !result.isBad else { throw MyError.myIssue }
         //…
         return doOtherThing()
     }
     如果调用的方法可能会抛出异常，try也会让异常直达catch：
     foo().then { baz in
         bar(baz)
     }.then { result in
         try doOtherThing()
     }.catch { error in
         // if doOtherThing() throws, we end up here
     }
     
     recover
     recover能从异常中拯救任务，可以判定某些错误就忽略，当做正常结果返回，剩下的错误继续抛出异常。
     CLLocationManager.requestLocation().recover { error -> Promise<CLLocation> in
         guard error == MyError.airplaneMode else {
             throw error
         }
         return .value(CLLocation.savannah)
     }.done { location in
         //…
     }
     
     几个例子
     列表每行顺序依次渐变消失
     let fade = Guarantee()
     for cell in tableView.visibleCells {
         fade = fade.then {
             UIView.animate(.promise, duration: 0.1) {
                 cell.alpha = 0
             }
         }
     }
     fade.done {
         // finish
     }
     
     执行一个方法，指定超时时间
     let fetches: [Promise<T>] = makeFetches()
     let timeout = after(seconds: 4)

     race(when(fulfilled: fetches).asVoid(), timeout).then {
         //…
     }
    race和when不一样，when会等待所有任务执行成功再继续，race是谁第一个到就继续，race要求所有任务返回类型必须一样，最好的做法是都返回Void，上面的例子就是让4秒计时和请求api同时发起，如果4秒计时到了请求还没回来，则直接调用后续方法。
     
     至少等待一段时间做某件事
     let waitAtLeast = after(seconds: 0.3)

     firstly {
         foo()
     }.then {
         waitAtLeast
     }.done {
         //…
     }
     上面的例子从firstly中的foo执行之前就已经开始after(seconds: 0.3)，所以如果foo执行超过0.3秒，则foo执行完后不会再等待0.3秒，而是直接继续下一个任务。如果foo执行不到0.3秒，则会等待到0.3秒再继续。这个方法的场景可以用在启动页动画，动画显示需要一个保证时间。
     
     重试
     func attempt<T>(maximumRetryCount: Int = 3, delayBeforeRetry: DispatchTimeInterval = .seconds(2), _ body: @escaping () -> Promise<T>) -> Promise<T> {
         var attempts = 0
         func attempt() -> Promise<T> {
             attempts += 1
             return body().recover { error -> Promise<T> in
                 guard attempts < maximumRetryCount else { throw error }
                 return after(delayBeforeRetry).then(on: nil, attempt)
             }
         }
         return attempt()
     }
     attempt(maximumRetryCount: 3) {
         flakeyTask(parameters: foo)
     }.then {
         //…
     }.catch { _ in
         // we attempted three times but still failed
     }
     
     Delegate变Promise
     extension CLLocationManager {
         static func promise() -> Promise<CLLocation> {
             return PMKCLLocationManagerProxy().promise
         }
     }

     class PMKCLLocationManagerProxy: NSObject, CLLocationManagerDelegate {
         private let (promise, seal) = Promise<[CLLocation]>.pending()
         private var retainCycle: PMKCLLocationManagerProxy?
         private let manager = CLLocationManager()

         init() {
             super.init()
             retainCycle = self
             manager.delegate = self // does not retain hence the `retainCycle` property

             promise.ensure {
                 // ensure we break the retain cycle
                 self.retainCycle = nil
             }
         }

         @objc fileprivate func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
             seal.fulfill(locations)
         }

         @objc func locationManager(_: CLLocationManager, didFailWithError error: Error) {
             seal.reject(error)
         }
     }

     // use:
     CLLocationManager.promise().then { locations in
         //…
     }.catch { error in
         //…
     }
     retainCycle是其中一个循环引用，目的是为了不让PMKCLLocationManagerProxy自身被释放，当Promise结束的时候，在ensure方法中执行self.retainCycle = nil把引用解除，来达到释放自身的目的，非常巧妙。
     
     传递中间结果
     有时候我们需要传递任务中的一些中间结果，比如下面的例子，done中无法使用username变量：
     login().then { username in
         fetch(avatar: username)
     }.done { image in
         //…
     }
     可以通过map巧妙的把结果变成元组形式返回：
     login().then { username in
         fetch(avatar: username).map { ($0, username) }
     }.then { image, username in
         //…
     }
     */

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

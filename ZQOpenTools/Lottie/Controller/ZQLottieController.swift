//
//  ZQLottieController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/28.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit
 
/// Lottie cell
class ZQLottieCollectionViewCell: UICollectionViewCell {
    private lazy var animationView:AnimationView = AnimationView().then {
        $0.loopMode = .loop
    }
    
    var animationName:String? {
        didSet {
            if let name = animationName {
                if name.hasPrefix("http") {
                    Animation.loadedFrom(url: URL(string: name)!, closure: { (animation) in
                        if animation == nil {
                            print("--__--|| json文件下载失败")
                        }
                        else {
                            self.animationView.animation = animation
                            self.animationView.play()
                        }
                    }, animationCache: nil)
                }
                else {
                    animationView.animation = Animation.named(name)
                    animationView.play()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .blue
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
}

/// Lottie控制器
class ZQLottieController: ZQBaseController {

    /**
     Lottie是Airbnb开源的一个动画渲染库，支持多平台，包括iOS、Android、React Native以及Flutter，它通过bodymovin插件来解析Adobe After Effects 动画并导出为json文件，通过手机端原生的方式或者通过React Native的方式渲染出矢量动画。
    总而言之，咱们开发人员有了这个三方框架，再也不用去苦恼各种动画的实现了，还得跟UI设计人员扯皮。这个框架，UI设计人员将动画图制作好了后，利用工具转为json文件，咱们通过框架提供的方法加载json就可以实现各种精彩的动画，而且LOTAnimationView继承自UIView，可以给它添加手势和frame
     
     使用
     Lottie支持iOS 8 及其以上系统。当我们把动画需要的images资源文件添加到Xcode的目标工程的后，Lottie 就可以通过JSON文件或者包含了JSON文件的URL来加载动画。
     
     原理
     1）首先要明白，一个完整动画View，是由很多个子Layer 组成，而每个子Layer主要通过shapes（形状），masks（蒙版），transform三大部分进行动画。
     2）Lottie框架通过读取JSON文件，获取到每个子Layer 的shapes，masks，以及出现时间，消失时间以及Transform各个属性的关键帧数组。
     3）动画则是通过给CompositionLayer （所有的子layer都添加在这个Layer 上）的 currentFrame属性添加一个CABaseAnimation 来实现。
     4）所有的子Layer根据currentFrame 属性的变化，根据JSON中的关键帧数组计算出自己的当前状态进行显示。

     */
    
    private let datasArr:[String] = [
        "9squares-AlBoardman",
        "base64Test",
        "Boat_Loader",
        "DisableNodesTest",
        "FirstText",
        "GeometryTransformTest",
        "HamburgerArrow",
        "IconTransitions",
        "Keypath",
        "keypathTest",
        "LottieLogo1_masked",
        "LottieLogo1",
        "LottieLogo2",
        "MotionCorpse-Jrcanest",
        "PinJump",
        "setValueTest",
        "Switch_States",
        "Switch",
        "timeremap",
        "TwitterHeart",
        "TwitterHeartButton",
        "3d_rotate_loading_animation",
        "201-simple-loader",
        "226-splashy-loader",
        "empty_status",
        "glow_loading",
        "loading_animation",
        "wallet_&_coin",
        "https://github.com/airbnb/lottie-ios/blob/master/Example/lottie-swift/TestAnimations/Boat_Loader.json"]
    
    private lazy var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.width)
        $0.scrollDirection = .vertical
    }
    
    private lazy var collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .white
        $0.register(ZQLottieCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZQLottieCollectionViewCell.self))
        $0.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (m) in
            m.leading.top.trailing.equalToSuperview()
            m.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
 
// MARK: UICollectionViewDataSource
extension ZQLottieController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ZQLottieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZQLottieCollectionViewCell.self), for: indexPath) as! ZQLottieCollectionViewCell
        cell.animationName = datasArr[indexPath.item]
        return cell
    }
}


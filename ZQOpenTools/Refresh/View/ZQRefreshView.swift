//
//  ZQRefreshAnimator.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/29.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 刷新头
class ZQRefreshHeader: MJRefreshHeader {
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var animationView:AnimationView = AnimationView(name: "loading_animation").then {
        $0.loopMode = .loop
        $0.animationSpeed = 0.5
    }
    
    override func prepare() {
        super.prepare()
        mj_h = 60
        setupViews()
        rx.observe(String.self, "state").subscribe(onNext: {[weak self] value in
            if let self = self {
                switch self.state {
                case .idle:
                    self.animationView.stop()
                case .pulling:
                    self.animationView.play()
                case .refreshing:
                    self.animationView.play()
                case .willRefresh:
                    self.animationView.play()
                default:break
                }
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: private
extension ZQRefreshHeader {
    private func setupViews() {
        addSubview(animationView)
        animationView.snp.makeConstraints { (m) in
            m.top.bottom.centerX.equalToSuperview()
            m.width.equalTo(250)
        }
    }
}

/// 刷新尾
class ZQRefreshFooter: MJRefreshAutoNormalFooter {}

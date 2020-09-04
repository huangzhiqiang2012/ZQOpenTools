//
//  ZQAMPopTipController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/9/3.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// AMPopTip 控制器
class ZQAMPopTipController: ZQBaseController {
        
    private lazy var direction: PopTipDirection = PopTipDirection.up
    
    private lazy var timer: Timer? = nil
    
    private lazy var lyrics = [
      "Go to the dark side full moon",
      "You shoot the apple off of my head",
      "'Cause your love, sweet love, is all that you put me through",
      "And honey without it you know I'd rather be dead",
      "I'm tied up",
      "I'm tangled up",
      "And I'm all wrapped up",
      "In you"
    ]
    
    private lazy var topLeftButton:UIButton = getButton(backgroundColor: .red, type: .topLeft)
    
    private lazy var topRightButton:UIButton = getButton(backgroundColor: .orange, type: .topRight)

    private lazy var centerButton:UIButton = getButton(backgroundColor: .yellow, type: .center)
    
    private lazy var bottomLeftButton:UIButton = getButton(backgroundColor: .green, type: .bottomLeft)

    private lazy var bottomRightButton:UIButton = getButton(backgroundColor: .blue, type: .bottomRight)
    
    private lazy var popTip: PopTip = PopTip().then {
        $0.font = UIFont(name: "Avenir-Medium", size: 12)!
        $0.shouldDismissOnTap = true
        $0.shouldDismissOnTapOutside = true
        $0.edgeMargin = 5
        $0.offset = 5
        $0.bubbleOffset = 0
        $0.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        $0.bubbleColor = .brown
        
        $0.borderWidth = 2
        $0.borderColor = UIColor.purple
        $0.shadowOpacity = 0.4
        $0.shadowRadius = 3
        $0.shadowOffset = CGSize(width: 1, height: 1)
        $0.shadowColor = .black
            
//        $0.actionAnimation = .bounce(8)
        $0.actionAnimation = .pulse(1.1)
//        $0.actionAnimation = .float(offsetX: 10, offsetY: 10)
        
        $0.tapHandler = { _ in
            print("--__--|| tap")
        }
        
        $0.tapOutsideHandler = { _ in
            print("--__--|| tapOutside")
        }
        
        $0.swipeOutsideHandler = { _ in
            print("--__--|| swipeOutside")
        }
        
        $0.dismissHandler = { _ in
            print("--__--|| dismiss")
        }
    }

    
    enum ZQAMPopTipButtonType: Int {
        case topLeft  = 1000
        case topRight
        case center
        case bottomLeft
        case bottomRight
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        super.setupViews()
        view.zq.addSubViews([topLeftButton, topRightButton, centerButton, bottomLeftButton, bottomRightButton])
        let gap = 40, width = 80
        topLeftButton.snp.makeConstraints { (m) in
            m.leading.equalTo(gap)
            m.top.equalTo(gap)
            m.width.height.equalTo(width)
        }
        topRightButton.snp.makeConstraints { (m) in
            m.trailing.equalTo(-gap)
            m.top.width.height.equalTo(topLeftButton)
        }
        centerButton.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
            m.width.height.equalTo(topLeftButton)
        }
        bottomLeftButton.snp.makeConstraints { (m) in
            m.leading.equalTo(topLeftButton)
            m.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-gap)
            m.width.height.equalTo(topLeftButton)
        }
        bottomRightButton.snp.makeConstraints { (m) in
            m.trailing.equalTo(topRightButton)
            m.bottom.width.height.equalTo(bottomLeftButton)
        }
    }
}

// MARK: private
extension ZQAMPopTipController {
    private func getButton(backgroundColor:UIColor, type:ZQAMPopTipButtonType) -> UIButton {
        return UIButton(type: .custom).then {
            $0.backgroundColor = backgroundColor
            $0.tag = type.rawValue
            $0.addTarget(self, action: #selector(actionForButton(_:)), for: .touchUpInside)
        }
    }
}

// MARK: action
extension ZQAMPopTipController {
    @objc private func actionForButton(_ sender:UIButton) {
        guard let type = ZQAMPopTipButtonType(rawValue: sender.tag) else {
            return
        }
        timer?.invalidate()
        popTip.arrowRadius = 0
        
        switch type {
        case .topLeft:
            popTip.cornerRadius = 10
            let customView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 120))
            let label = UILabel(frame: customView.bounds).then {
                $0.text = "This is a custom view"
                $0.textAlignment = .center
                $0.numberOfLines = 0
                $0.textColor = .white
                $0.font = .systemFont(ofSize: 12)
            }
            customView.addSubview(label)
            popTip.show(customView: customView, direction: .auto, in: view, from: sender.frame)
            popTip.entranceAnimationHandler = { [weak self] completion in
                guard let self = self else { return }
                self.popTip.transform = CGAffineTransform(rotationAngle: 0.3)
                UIView.animate(withDuration: 0.5, animations: {
                    self.popTip.transform = .identity
                }) { (_) in
                    completion()
                }
            }
            
        case .topRight:
            popTip.show(text: "I have an offset to move the bubble down or left side.", direction: .autoHorizontal, maxWidth: 150, in: view, from: sender.frame)
            
        case .center:
            popTip.arrowRadius = 2
            popTip.show(text: "Animated popover, great for subtle UI tips and onboarding", direction: direction, maxWidth: 200, in: view, from: sender.frame)
            direction = direction.cycleDirection()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in
                guard let self = self else {
                    return
                }
                self.popTip.update(text: self.lyrics.sample())
            })
            
        case .bottomLeft:
            let attributedText = NSMutableAttributedString(string: "I'm presenting a string ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.white])
            attributedText.append(NSAttributedString(string: "with attributes!", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]))
            popTip.show(attributedText: attributedText, direction: .up, maxWidth: 200, in: view, from: sender.frame)
            
        case .bottomRight:
            if #available(iOS 13.0.0, *) {
                popTip.cornerRadius = 10
                #if canImport(SwiftUI) && canImport(Combine)
                popTip.show(rootView: ZQAMPopTipSwiftUIView(), direction: .up, in: view, from: sender.frame, parent: self)
                #endif
                popTip.entranceAnimationHandler = { [weak self] completion in
                    guard let self = self else { return }
                    self.popTip.transform = CGAffineTransform(rotationAngle: 0.3)
                    UIView.animate(withDuration: 0.5, animations: {
                        self.popTip.transform = .identity
                    }) { (_) in
                        completion()
                    }
                }
            }
        }
    }
}

// MARK: PopTipDirection + Extension
extension PopTipDirection {
  func cycleDirection() -> PopTipDirection {
    switch self {
    case .auto:
      return .auto
        
    case .autoVertical:
      return .autoVertical
        
    case .autoHorizontal:
      return .autoHorizontal
        
    case .up:
      return .right
        
    case .right:
      return .down
        
    case .down:
      return .left
        
    case .left:
      return .up
        
    case .none:
      return .none
    }
  }
}

// MARK: Array + Extension
extension Array {
  func sample() -> Element {
    let index = Int(arc4random_uniform(UInt32(count)))
    return self[index]
  }
}



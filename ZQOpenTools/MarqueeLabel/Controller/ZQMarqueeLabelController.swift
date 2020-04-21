//
//  ZQMarqueeLabelController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/21.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// MarqueeLabel控制器
class ZQMarqueeLabelController: ZQBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        let label0 = getLabel()
        label0.text = "This is a test of MarqueeLabel, with a somewhat long string."
        label0.type = .continuous
        label0.animationCurve = .easeInOut
        view.addSubview(label0)
        label0.snp.makeConstraints { (m) in
            m.leading.equalTo(15)
            m.trailing.equalTo(-15)
            m.top.equalTo(50)
        }
        
        let label1 = getLabel()
        label1.type = .continuousReverse
        label1.textAlignment = .right
        label1.lineBreakMode = .byTruncatingHead
        label1.speed = .duration(8.0)
        label1.fadeLength = 15.0
        label1.leadingBuffer = 40.0
        let attributedString1 = NSMutableAttributedString(string:"This is a long string, that's also an attributed string, which works just as well!")
        attributedString1.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica-Bold", size: 18)!, range: NSMakeRange(0, 21))
        attributedString1.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.lightGray, range: NSMakeRange(0, 14))
        attributedString1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.234, green: 0.234, blue: 0.234, alpha: 1.0), range: NSMakeRange(0, attributedString1.length))
        attributedString1.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "HelveticaNeue-Light", size: 18)!, range: NSMakeRange(21, attributedString1.length - 21))
        label1.attributedText = attributedString1
        view.addSubview(label1)
        label1.snp.makeConstraints { (m) in
            m.leading.trailing.equalTo(label0)
            m.top.equalTo(label0.snp.bottom).offset(50)
        }
        
        let label2 = getLabel()
        label2.type = .leftRight
        label2.speed = .rate(60)
        label2.fadeLength = 10.0
        label2.leadingBuffer = 30.0
        label2.trailingBuffer = 20.0
        label2.textAlignment = .center
        label2.text = "This is another long label that scrolls at a specific rate, rather than scrolling its length in a defined time window!"
        view.addSubview(label2)
        label2.snp.makeConstraints { (m) in
            m.leading.trailing.equalTo(label0)
            m.top.equalTo(label1.snp.bottom).offset(50)
        }
        
        let label3 = getLabel()
        label3.type = .rightLeft
        label3.textAlignment = .right
        label3.lineBreakMode = .byTruncatingHead
        label3.tapToScroll = true
        label3.holdScrolling = true
        label3.trailingBuffer = 20
        label3.text = "This label will not scroll until tapped, and then it performs its scroll cycle only once. Tap me!"
        view.addSubview(label3)
        label3.snp.makeConstraints { (m) in
            m.leading.trailing.equalTo(label0)
            m.top.equalTo(label2.snp.bottom).offset(50)
        }
        
        let label4 = getLabel()
        label4.type = .continuous
        label4.speed = .duration(10)
        label4.fadeLength = 10.0
        label4.trailingBuffer = 30.0
        label4.text = "This text is long, and can be paused with a tap - handled via a UIGestureRecognizer!"
        label4.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pauseTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        label4.addGestureRecognizer(tapRecognizer)
        view.addSubview(label4)
        label4.snp.makeConstraints { (m) in
            m.leading.trailing.equalTo(label0)
            m.top.equalTo(label3.snp.bottom).offset(50)
        }
        
        let label5 = getLabel()
        label5.type = .continuous
        label5.speed = .duration(15.0)
        label5.fadeLength = 10.0
        label5.trailingBuffer = 30.0
        let attributedString5 = NSMutableAttributedString(string:"This is a long, attributed string, that's set up to loop in a continuous fashion!")
        attributedString5.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.123, green: 0.331, blue: 0.657, alpha: 1.000), range: NSMakeRange(0,34))
        attributedString5.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.657, green: 0.096, blue: 0.088, alpha: 1.000), range: NSMakeRange(34, attributedString5.length - 34))
        attributedString5.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "HelveticaNeue-Light", size:18.0)!, range: NSMakeRange(0, 16))
        attributedString5.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "HelveticaNeue-Light", size:18.0)!, range: NSMakeRange(33, attributedString5.length - 33))
        label5.attributedText = attributedString5;
        view.addSubview(label5)
        label5.snp.makeConstraints { (m) in
            m.leading.trailing.equalTo(label0)
            m.top.equalTo(label4.snp.bottom).offset(50)
        }
        
        let button = UIButton(type: .custom).then {
            $0.backgroundColor = .blue
            $0.zq.addRadius(radius: 15)
            $0.setTitle("Labelize", for: .normal)
            $0.setTitle("Animate", for: .selected)
            $0.setTitleColor(.red, for: .normal)
            $0.setTitleColor(.yellow, for: .selected)
            $0.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        }
        view.addSubview(button)
        button.snp.makeConstraints { (m) in
            m.top.equalTo(label5.snp.bottom).offset(50)
            m.size.equalTo(CGSize(width: 150, height: 30))
            m.centerX.equalToSuperview()
        }
    }
}

// MARK: private
extension ZQMarqueeLabelController {
    private func getLabel() -> MarqueeLabel {
        return MarqueeLabel().then {
            $0.backgroundColor = .brown
        }
    }
}

// MARK: action
extension ZQMarqueeLabelController {
    @objc private func pauseTap(_ recognizer: UIGestureRecognizer) {
        let label = recognizer.view as! MarqueeLabel
        if recognizer.state == .ended {
            label.isPaused ? label.unpauseLabel() : label.pauseLabel()
        }
    }
    
    @objc private func actionForButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            MarqueeLabel.controllerLabelsLabelize(self)
        }
        else {
            MarqueeLabel.controllerLabelsAnimate(self)
        }
    }
}

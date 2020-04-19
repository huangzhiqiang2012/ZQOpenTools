//
//  ZQSwiftRichStringController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/16.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// SwiftRichString控制器
class ZQSwiftRichStringController: ZQBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        let style = Style {
            $0.font = SystemFonts.AmericanTypewriter.font(size: 25)
            $0.color = "#0433FF"
            $0.underline = (.patternDot, UIColor.red)
            $0.alignment = .center
        }
        let label0 = UILabel()
        label0.attributedText = "Hello World!".set(style: style)
        view.addSubview(label0)
        label0.snp.makeConstraints { (m) in
            m.top.equalTo(50)
            m.centerX.equalToSuperview()
        }
        
        let normal = Style {
            $0.font = SystemFonts.Helvetica_Light.font(size: 15)
        }
        let bold = Style {
            $0.font = SystemFonts.Helvetica_Bold.font(size: 20)
            $0.color = UIColor.red
            $0.backColor = UIColor.yellow
        }
        let italic = normal.byAdding {
            $0.traitVariants = .italic
        }
        let myGroup = StyleXML(base: normal, ["bold" : bold, "italic" : italic])
        let str = "Hello <bold>Daniele!</bold>. You're ready to <italic>play with us!</italic>"
        let label1 = UILabel()
        label1.attributedText = str.set(style: myGroup)
        view.addSubview(label1)
        label1.snp.makeConstraints { (m) in
            m.top.equalTo(label0.snp.bottom).offset(50)
            m.centerX.equalToSuperview()
        }
        
        let emailPattern = "([A-Za-z0-9_\\-\\.\\+])+\\@([A-Za-z0-9_\\-\\.])+\\.([A-Za-z]+)"
        let regStyle = StyleRegEx(pattern: emailPattern) {
            $0.color = UIColor.red
            $0.backColor = UIColor.yellow
            $0.alignment = .center
        }
        let label2 = UILabel().then {
            $0.numberOfLines = 0
        }
        label2.attributedText = "My email is hello@danielemargutti.com and my website is http://www.danielemargutti.com".set(style: regStyle!)
        view.addSubview(label2)
        label2.snp.makeConstraints { (m) in
            m.top.equalTo(label1.snp.bottom).offset(50)
            m.leading.equalTo(15)
            m.trailing.equalTo(-15)
        }
    }
}

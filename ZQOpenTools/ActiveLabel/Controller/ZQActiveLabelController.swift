//
//  ZQActiveLabelController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/16.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// ActiveLabel控制器
class ZQActiveLabelController: ZQBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        let label0 = ActiveLabel().then {
            $0.numberOfLines = 0
            $0.enabledTypes = [.mention, .hashtag, .url]
            $0.text = "This is a post with #hashtags and a @userhandle. Links are also supported like this one: http://www.baidu.com."
            $0.textColor = .black
            $0.handleHashtagTap { (hashtag) in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            $0.handleMentionTap { (methion) in
                print("Success. You just tapped the \(methion) methion")
            }
            $0.handleURLTap { (url) in
                print("Success. You just tapped the \(url.absoluteString) url")
            }
        }
        view.addSubview(label0)
        label0.snp.makeConstraints { (m) in
            m.top.equalTo(50)
            m.leading.equalTo(15)
            m.trailing.equalTo(-15)
        }
        
        let label1 = ActiveLabel().then {
            $0.numberOfLines = 0
            let customType = ActiveType.custom(pattern: "\\swith\\b")
            $0.enabledTypes = [.mention, .hashtag, .url, customType]
            $0.text = "This is a post with #hashtags and a @userhandle. Links are also supported like this one: http://www.baidu.com."
            $0.customColor[customType] = UIColor.purple
            $0.customSelectedColor[customType] = UIColor.green
            $0.handleCustomTap(for: customType) { (element) in
                print("Custom type tapped: \(element)")
            }
        }
        view.addSubview(label1)
        label1.snp.makeConstraints { (m) in
            m.top.equalTo(label0.snp.bottom).offset(50)
            m.leading.trailing.equalTo(label0)
        }
    }
}

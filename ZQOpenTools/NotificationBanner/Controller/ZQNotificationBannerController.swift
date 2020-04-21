//
//  ZQNotificationBannerController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/21.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

class ZQCustomBannerColors: BannerColorsProtocol {
    internal func color(for style: BannerStyle) -> UIColor {
        switch style {
        case .danger:           return .red
        case .info:             return .blue
        case .customView:       return .brown
        case .success:          return .orange
        case .warning:          return .cyan
        }
    }
}

/// NotificationBannerSwift控制器
class ZQNotificationBannerController: ZQBaseController {
    
    private let defaultTag = 100000

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titlesArr = ["Basic Banner", "Banner with Side Views", "Status Bar Banners", "Growing Banners", "Floating Banners", "Custom Banner Colors", "Stacked Banners"]
        let height = 30
        let top = 50
        for i in 0..<titlesArr.count {
            let button = getButton(title: titlesArr[i], tag: i)
            view.addSubview(button)
            button.snp.makeConstraints { (m) in
                m.top.equalTo(top + (top + height) * i)
                m.centerX.equalToSuperview()
                m.size.equalTo(CGSize(width: 180, height: height))
            }
        }
    }
}

// MARK: private
extension ZQNotificationBannerController {
    private func getButton(title:String, tag:Int) -> UIButton {
        return UIButton(type: .custom).then {
            $0.backgroundColor = .blue
            $0.zq.addRadius(radius: 15)
            $0.titleLabel?.font = .systemFont(ofSize: 15)
            $0.setTitle(title, for: .normal)
            $0.tag = defaultTag + tag
            $0.addTarget(self, action: #selector(actionForButton(_:)), for: .touchUpInside)
        }
    }
}

// MARK: action
extension ZQNotificationBannerController {
    @objc private func actionForButton(_ sender:UIButton) {
        switch sender.tag - defaultTag {
        case 0:
            let banner = NotificationBanner(title: "Basic Success Notification", subtitle: "Basic Success Notification", style: .success)
            banner.haptic = .heavy
            banner.onTap = {
                print("--__--|| tap Banner")
            }
            banner.onSwipeUp = {
                print("--__--|| swipeUp Banner")
            }
            banner.show()
            
        case 1:
            let banner = NotificationBanner(title: "Banner with Side Views", subtitle: "Banner with Side Views", leftView: UIImageView(image: UIImage(named: "popMenu_home")), style: .info)
            banner.haptic = .heavy
            banner.onTap = {
                print("--__--|| tap Banner")
            }
            banner.onSwipeUp = {
                print("--__--|| swipeUp Banner")
            }
            banner.show()
            
        case 2:
            let banner = StatusBarNotificationBanner(title: "Status Bar Banners", style: .success)
            banner.haptic = .heavy
            banner.onTap = {
                print("--__--|| tap Banner")
            }
            banner.onSwipeUp = {
                print("--__--|| swipeUp Banner")
            }
            banner.show()
            
        case 3:
            let banner = GrowingNotificationBanner(title: "Growing Banners", subtitle: "By default, each banner will be displayed on the main application window. If you are wanting to show a banner below a navigation bar, simply show on the view controller that is within the navigation system, Each of the show properties defined above can be mixed and matched to work flawlessly with eachother.By default, each banner will automatically dismiss after 5 seconds. To dismiss programatically, simply", leftView: UIImageView(image: UIImage(named: "popMenu_home")), style: .danger)
            banner.haptic = .heavy
            banner.onTap = {
                print("--__--|| tap Banner")
            }
            banner.onSwipeUp = {
                print("--__--|| swipeUp Banner")
            }
            banner.show()
            
        case 4:
            let banner = FloatingNotificationBanner(title: "Floating Banners", subtitle: "Floating Banners", titleFont: .systemFont(ofSize: 18), titleColor: .red, subtitleFont: .systemFont(ofSize: 15), subtitleColor: .brown, leftView: UIImageView(image: UIImage(named: "popMenu_home")), style: .info)
            banner.haptic = .heavy
            banner.onTap = {
                print("--__--|| tap Banner")
            }
            banner.onSwipeUp = {
                print("--__--|| swipeUp Banner")
            }
            banner.show(cornerRadius:8)
            
        case 5:
            let banner = NotificationBanner(title: "Custom Banner Colors", subtitle: "Custom Banner Colors", leftView: UIImageView(image: UIImage(named: "popMenu_home")), style: .success, colors: ZQCustomBannerColors())
            banner.haptic = .heavy
            banner.onTap = {
                print("--__--|| tap Banner")
            }
            banner.onSwipeUp = {
                print("--__--|| swipeUp Banner")
            }
            banner.show()
            
        case 6:
            let bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 3)

            let banner1 = FloatingNotificationBanner(title: "Success Notification - 1",
                                                     subtitle: "First Notification from 5 in current queue with 3 banners allowed simultaneously",
                                                     style: .success)
            banner1.delegate = self
            let banner2 = FloatingNotificationBanner(title: "Danger Notification - 2",
                                                     subtitle: "Second Notification from 5 in current queue with 3 banners allowed simultaneously",
                                                     style: .danger)
            banner2.delegate = self

            let banner3 = FloatingNotificationBanner(title: "Info Notification - 3",
                                                     subtitle: "Third Notification from 5 in current queue with 3 banners allowed simultaneously",
                                                     style: .info)
            banner3.delegate = self

            let banner4 = FloatingNotificationBanner(title: "Success Notification - 4",
                                                     subtitle: "Fourth Notification from 5 in current queue with 3 banners allowed simultaneously",
                                                     style: .success)
            banner4.delegate = self

            let banner5 = FloatingNotificationBanner(title: "Info Notification - 5",
                                                     subtitle: "Fifth Notification from 5 in current queue with 3 banners allowed simultaneously",
                                                     style: .info)
            banner5.delegate = self
            let banners = [banner1, banner2, banner3, banner4, banner5]
            banners.forEach { banner in
                banner.onTap = {
                    print("--__--|| tap Banner")
                }
                banner.onSwipeUp = {
                    print("--__--|| swipeUp Banner")
                }
                banner.show(queue: bannerQueue,
                            cornerRadius: 8,
                            shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1),
                            shadowBlurRadius: 16,
                            shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
            }
        default: break
        }
    }
}

// MARK: NotificationBannerDelegate
extension ZQNotificationBannerController: NotificationBannerDelegate {
    func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
        print("--__--|| Banner will appear")
    }
    
    func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
        print("--__--|| Banner did appear")
    }
    
    func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) {
        print("--__--|| Banner will disappear")
    }
    
    func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {
        print("--__--|| Banner did disappear")
    }
}

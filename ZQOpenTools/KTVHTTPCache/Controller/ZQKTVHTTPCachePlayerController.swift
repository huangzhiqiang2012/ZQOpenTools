//
//  ZQKTVHTTPCachePlayerController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/6/22.
//  Copyright © 2020 Darren. All rights reserved.
//

import AVKit

class ZQKTVHTTPCachePlayerController: AVPlayerViewController {
    
    private var urlStr:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: urlStr) {
            self.player = AVPlayer(url: url)
            self.player?.play()
        }
    }
    
    convenience init(urlStr:String?) {
        self.init()
        self.urlStr = urlStr
    }
    
    deinit {
        self.player?.currentItem?.asset.cancelLoading()
        self.player?.currentItem?.cancelPendingSeeks()
        self.player?.cancelPendingPrerolls()
    }
}

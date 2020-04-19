//
//  ZQKingfisherController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/29.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Kingfisher控制器
class ZQKingfisherController: ZQBaseController {
    
    /**
     Kingfisher 支持 webp 图片
     1 引入 KingfisherWebP 库
     $ pod 'KingfisherWebP'

     报错
      [!] Error installing libwebp
     [!] /usr/local/bin/git clone https://chromium.googlesource.com/webm/libwebp /var/folders/2f/yv5rlly926s0k1jdcs3m89lh0000gn/T/d20200110-6284-1uh2fk7 --template= --single-branch --depth 1 --branch v1.1.0
     Cloning into '/var/folders/2f/yv5rlly926s0k1jdcs3m89lh0000gn/T/d20200110-6284-1uh2fk7'...
     fatal: unable to access 'https://chromium.googlesource.com/webm/libwebp/': Failed to connect to chromium.googlesource.com port 443: Operation timed out

     修改pod repo中libwebp的git source 地址，再执行pod install 解决,具体步骤如下
     查看mac中cocoapods 本地库路径:
     $ pod repo
     输出
     - Type: git (master)
     - URL: https://github.com/CocoaPods/Specs.git
     - Path: /Users/darren/.cocoapods/repos/cocoapods

     在本地库中, 并找到对应的libwebp版本的文件
     $ find ~/.cocoapods/repos/cocoapods -iname libwebp
     输出
     /Users/darren/.cocoapods/repos/cocoapods/Specs/1/9/2/libwebp

     进入libwebp目录，可以看到你的仓库中有哪些对应的版本
     $ cd ~/.cocoapods/repos/cocoapods/Specs/1/9/2/libwebp
     $ ls -l
     输出
     total 0
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 0.4.1
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 0.4.2
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 0.4.3
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 0.4.4
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 0.5.0
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 0.5.1
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 0.5.2
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 0.6.0
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 0.6.1
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 1.0.0
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 1.0.1
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 1.0.2
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 1.0.3
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 1.1.0
     drwxr-xr-x  3 darren  staff  96 Jan 10 13:03 1.1.0-rc2

     由于KingfisherWebP依赖的 libwebp版本为1.1.0(具体看刚才报错信息里面提示的版本)，所以我们进入1.1.0中，并做修改
     $ cd 1.1.0/
     $ ls -l
     输出
     total 8
     -rw-r--r--  1 darren  staff  1854 Jan 10 13:03 libwebp.podspec.json

     修改目录下的libwebp.podspec.json文件中git source
     $ sudo vim libwebp.podspec.json
     找到
       "source": {
         "git": "https://chromium.googlesource.com/webm/libwebp",
         "tag": "v1.1.0"
       },
     将其中的"git" 对应的url替换为https://github.com/webmproject/libwebp.git,并保存
     最后再执行pod install, 完成
     Installing KingfisherWebP (0.7.0)
     Installing libwebp (1.1.0)
     Generating Pods project
     Integrating client project
     Pod installation complete! There are 37 dependencies from the Podfile and 45 total pods installed.

     2 添加 options
     import KingfisherWebP
     self.kf.setImage(with: URL(string: string),
                      placeholder: placeholder,
                      options: [.processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)]) { (img, err, cacheType, imgUrl) in

     }

     3 可以用以下链接测试
     http://mmbiz.qpic.cn/mmbiz_jpg/AZQZ9KUtamupibEQMmFDLqqsU7RLEvH5h5sPcyZEvhv6tQ5y3WAYKYibeQfnOtQulul5QHFHpL9b0icCKliajWFe2A/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1

     */
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        for i in 0..<2 {
            let imageView = UIImageView()
            let urlStr = i % 2 == 0 ? "http://mmbiz.qpic.cn/mmbiz_jpg/AZQZ9KUtamupibEQMmFDLqqsU7RLEvH5h5sPcyZEvhv6tQ5y3WAYKYibeQfnOtQulul5QHFHpL9b0icCKliajWFe2A/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1" : "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585549454825&di=c7e3be2174ca31f5b391eae7a1110e35&imgtype=0&src=http%3A%2F%2Fimg3.doubanio.com%2Fview%2Fnote%2Fl%2Fpublic%2Fp51213326.jpg"
            imageView.zq.setImage(urlStr: urlStr)
            view.addSubview(imageView)
            imageView.snp.makeConstraints { (m) in
                m.width.height.equalTo(200)
                m.top.equalTo(40 + (i) * 220)
                m.centerX.equalToSuperview()
            }
        }
    }
}

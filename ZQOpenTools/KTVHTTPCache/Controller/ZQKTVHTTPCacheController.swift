//
//  ZQKTVHTTPCacheController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/6/22.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// KTVHTTPCache 控制器
class ZQKTVHTTPCacheController: ZQBaseController {
    
    private lazy var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: view.bounds.size.width, height: 44)
        $0.scrollDirection = .vertical
    }
    
    private lazy var collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .white
        $0.register(ZQKTVHTTPCacheCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZQKTVHTTPCacheCollectionViewCell.self))
        $0.dataSource = self
        $0.delegate = self
    }
    
    private lazy var datas:[ZQKTVHTTPCacheModel] = {
        var datas:[ZQKTVHTTPCacheModel] = [
            ZQKTVHTTPCacheModel(title: "萧亚轩 - 冲动", url: "http://aliuwmp3.changba.com/userdata/video/45F6BD5E445E4C029C33DC5901307461.mp4"),
            ZQKTVHTTPCacheModel(title: "张惠妹 - 你是爱我的", url: "http://aliuwmp3.changba.com/userdata/video/3B1DDE764577E0529C33DC5901307461.mp4"),
            ZQKTVHTTPCacheModel(title: "hush! - 都是你害的", url: "http://qiniuuwmp3.changba.com/941946870.mp4"),
            ZQKTVHTTPCacheModel(title: "张学友 - 我真的受伤了", url: "http://lzaiuw.changba.com/userdata/video/940071102.mp4"),
        ]
        return datas
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.once {
            setupHTTPCache()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
}

// MARK: private
extension ZQKTVHTTPCacheController {
    private func setupHTTPCache() {
        if KTVHTTPCache.cacheTotalCacheLength() != 0 {
            KTVHTTPCache.cacheDeleteAllCaches()
        }
        KTVHTTPCache.logSetConsoleLogEnable(true)
        do {
            try KTVHTTPCache.proxyStart()
        } catch {
            print("--__--|| Proxy Start Failure")
        }
        KTVHTTPCache.encodeSetURLConverter { (url) -> URL? in
            print("--__--|| URL Filter reviced URL \(url?.absoluteString)")
            return url
        }
        KTVHTTPCache.downloadSetUnacceptableContentTypeDisposer { (url, contentType) -> Bool in
            print("--__--|| Unsupport Content-Type : \(contentType) Filter reviced URL : \(url?.absoluteString)")
            return false
        }
    }
}

// MARK: UICollectionViewDelegate & UICollectionViewDataSource
extension ZQKTVHTTPCacheController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ZQKTVHTTPCacheCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZQKTVHTTPCacheCollectionViewCell.self), for: indexPath) as! ZQKTVHTTPCacheCollectionViewCell
        cell.titleLabel.text = datas[indexPath.item].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = datas[indexPath.item]
        let urlStr = model.url?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = KTVHTTPCache.proxyURL(withOriginalURL: URL(string: urlStr))
        let playerController = ZQKTVHTTPCachePlayerController(urlStr: url?.absoluteString)
        present(playerController, animated: true, completion: nil)
    }
}

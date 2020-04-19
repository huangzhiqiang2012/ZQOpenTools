//
//  ZQSKPhotoBrowserController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/18.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// SKPhotoBrowser控制器
class ZQSKPhotoBrowserController: ZQBaseController {
    
    private lazy var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: 200, height: 200)
        $0.scrollDirection = .horizontal
    }
    
    private lazy var collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        $0.register(ZQTZImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZQTZImagePickerCollectionViewCell.self))
        $0.dataSource = self
        $0.delegate = self
    }
    
    private lazy var imagesArr:[SKPhoto] = [SKPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        let localButton = UIButton().then {
            $0.backgroundColor = .brown
            $0.zq.addRadius(radius: 15)
            $0.setTitle("localImage", for: .normal)
            $0.addTarget(self, action: #selector(actionForLocalButton), for: .touchUpInside)
        }
        view.addSubview(localButton)
        localButton.snp.makeConstraints { (m) in
            m.top.equalTo(50)
            m.centerX.equalToSuperview()
            m.size.equalTo(CGSize(width: 150, height: 30))
        }
        
        let urlButton = UIButton().then {
            $0.backgroundColor = .brown
            $0.zq.addRadius(radius: 15)
            $0.setTitle("urlImage", for: .normal)
            $0.addTarget(self, action: #selector(actionForUrlButton), for: .touchUpInside)
        }
        view.addSubview(urlButton)
        urlButton.snp.makeConstraints { (m) in
            m.top.equalTo(localButton.snp.bottom).offset(50)
            m.centerX.size.equalTo(localButton)
        }
        
        for i in 0..<4 {
            let photo = SKPhoto.photoWithImage(UIImage(named: "local_image_\(i).jpg")!)
            imagesArr.append(photo)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (m) in
            m.top.equalTo(urlButton.snp.bottom).offset(50)
            m.leading.equalTo(15)
            m.trailing.equalTo(-15)
            m.height.equalTo(200)
        }
        collectionView.reloadData()
    }
}

// MARK: action
extension ZQSKPhotoBrowserController {
    @objc private func actionForLocalButton() {
        var images:[SKPhoto] = [SKPhoto]()
        for i in 0..<4 {
            let photo = SKPhoto.photoWithImage(UIImage(named: "local_image_\(i).jpg")!)
            images.append(photo)
        }
        let browser = SKPhotoBrowser(photos: images, initialPageIndex: 1)
        navigationController?.present(browser, animated: true, completion: nil)
    }
    
    @objc private func actionForUrlButton() {
        let photo0 = SKPhoto.photoWithImageURL("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1587192733791&di=4075108bee4a6a5492d0576a884e7ede&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201609%2F01%2F20160901214059_cPZ5f.jpeg").then {
            $0.shouldCachePhotoURLImage = false
        }
        
        let photo1 = SKPhoto.photoWithImageURL("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1587192655917&di=7eb0bcb425c8a75055ab2ebb3fe9353d&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Ffront%2F400%2Fw720h480%2F20190215%2FUguQ-htacqwv3956386.jpg").then {
            $0.shouldCachePhotoURLImage = false
        }

        let photo2 = SKPhoto.photoWithImageURL("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1587192669988&di=283bde95a598f9452af98ac578e71ae5&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20190223%2Fb80aff378fdb4243a9cde0023256707b.jpeg").then {
            $0.shouldCachePhotoURLImage = false
        }

        let photo3 = SKPhoto.photoWithImageURL("https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1947343429,3615407169&fm=26&gp=0.jpg").then {
            $0.shouldCachePhotoURLImage = false
        }
        
        let browser = SKPhotoBrowser(photos: [photo0, photo1, photo2, photo3], initialPageIndex: 1)
        navigationController?.present(browser, animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDataSource
extension ZQSKPhotoBrowserController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ZQTZImagePickerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZQTZImagePickerCollectionViewCell.self), for: indexPath) as! ZQTZImagePickerCollectionViewCell
        cell.image = imagesArr[indexPath.item].underlyingImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell:ZQTZImagePickerCollectionViewCell = collectionView.cellForItem(at: indexPath) as! ZQTZImagePickerCollectionViewCell
        let originImage = cell.image
        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: imagesArr, animatedFromView: cell)
        browser.initializePageIndex(indexPath.item)
        navigationController?.present(browser, animated: true, completion: nil)
    }
}


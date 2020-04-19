//
//  ZQTZImagePickerController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/17.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// TZImagePickerController控制器
class ZQTZImagePickerController: ZQBaseController {
    
    private lazy var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: 200, height: 200)
        $0.scrollDirection = .horizontal
    }
    
    private lazy var collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        $0.register(ZQTZImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZQTZImagePickerCollectionViewCell.self))
        $0.dataSource = self
    }
    
    private lazy var button:UIButton = UIButton().then {
        $0.backgroundColor = .brown
        $0.zq.addRadius(radius: 15)
        $0.setTitle("chooseImage", for: .normal)
        $0.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
    }
    
    private lazy var imagesArr:[UIImage] = [UIImage]()
    
    private lazy var sourceAssetsArr:[Any] = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        view.zq.addSubViews([collectionView, button])
        collectionView.snp.makeConstraints { (m) in
            m.top.equalTo(50)
            m.leading.equalTo(15)
            m.trailing.equalTo(-15)
            m.height.equalTo(200)
        }
        button.snp.makeConstraints { (m) in
            m.top.equalTo(collectionView.snp.bottom).offset(50)
            m.centerX.equalToSuperview()
            m.size.equalTo(CGSize(width: 150, height: 30))
        }
    }
}

// MARK: private
extension ZQTZImagePickerController {
    
    /// 临时文件路径
    /// - Parameter extensionStr: 文件后缀,默认导出mp4格式
    private func tempFilePath(extensionStr:String? = "mp4") -> String {
        let fileName = UUID().uuidString
        var path:NSString = NSTemporaryDirectory() as NSString
        path = path.appendingPathComponent(fileName) as NSString
        if let fullPath = path.appendingPathExtension(extensionStr ?? "mp4") {
            path = fullPath as NSString
        }
        return path as String
    }
    
    /// 获取本地视频文件路径
    /// - Parameters:
    ///   - asset: asset
    ///   - handle: 回调
    func getVideoLocalPath(asset:Any, handle:@escaping((_ path:String) -> Void)) {
        var localPath = ""
        guard (asset as AnyObject).isKind(of: PHAsset.self) else {
            handle(localPath)
            return
        }
        let videoAsset = asset as! PHAsset
        let options = PHVideoRequestOptions()
        options.version = .current
        options.deliveryMode = .automatic
        PHImageManager.default().requestExportSession(forVideo: videoAsset, options: options, exportPreset: AVAssetExportPresetMediumQuality) { [weak self] (exportSession, info) in
            guard let self = self, let exportSession = exportSession else { return }
            let savePath = self.tempFilePath()
            exportSession.outputURL = URL(fileURLWithPath: savePath)
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.outputFileType = .mp4
            exportSession.exportAsynchronously {
                switch exportSession.status {
                case .completed:
                    localPath = savePath
                
                default:
                    break
                }
                DispatchQueue.main.async {
                    handle(localPath)
                }
            }
        }
    }
}

// MARK: action
extension ZQTZImagePickerController {
    @objc private func actionForButton() {
        guard let picker = TZImagePickerController(maxImagesCount: 9, delegate: self) else {
            return
        }
        picker.selectedAssets = NSMutableArray(array: sourceAssetsArr)
        navigationController?.present(picker, animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDataSource
extension ZQTZImagePickerController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ZQTZImagePickerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZQTZImagePickerCollectionViewCell.self), for: indexPath) as! ZQTZImagePickerCollectionViewCell
        cell.image = imagesArr[indexPath.item]
        return cell
    }
}

// MARK: TZImagePickerControllerDelegate
extension ZQTZImagePickerController : TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: PHAsset!) {
        getVideoLocalPath(asset: asset as Any) { (path) in
            print("--__--|| videoPath___\(path)")
        }
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        imagesArr = photos
        sourceAssetsArr = assets
        collectionView.reloadData()
    }
}

/// cell
class ZQTZImagePickerCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView:UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
    
    var image:UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  ZQIGListKitViewModel.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/23.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// IGListKit ViewModel
class ZQIGListKitViewModel: NSObject {
    
    private let vc: () -> UIViewController?
    
    private let collectionView: () -> UICollectionView?
    
    private var adapter: ListAdapter!
    
    private lazy var objects: [ListDiffable] = [ListDiffable]()
    
    private lazy var datasArr: [ZQIGListKitModel] = [ZQIGListKitModel]()
    
    init(vc: @escaping () -> UIViewController?, collectionView: @escaping () -> UICollectionView?) {
        self.vc = vc
        self.collectionView = collectionView
        super.init()
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: vc()).then {
            $0.collectionView = collectionView()
            $0.dataSource = self
        }
    }
}

// MARK: public
extension ZQIGListKitViewModel {
    func requestData() {
        
        /// 这里省略网络请求
        for i in 0..<20 {
            let data = ZQIGListKitModel()
            
            let result = i % 3
            switch result {
            case 0:
                let topic = ZQIGListKitTopicModel()
                data.topic = topic
                
            case 1:
                let course = ZQIGListKitCourseModel()
                data.course = course
                
            case 2:
                let news = ZQIGListKitNewsModel()
                news.content = [ZQIGListKitNewModel(), ZQIGListKitNewModel(), ZQIGListKitNewModel()]
                data.news = news
                
            default:break
            }
            datasArr.append(data)
        }
        configData()
    }
}

// MARK: private
extension ZQIGListKitViewModel {
    private func configData() {
        objects.removeAll()
        datasArr.forEach {
            if let topic = $0.topic {
                objects.append(ZQDiffableBox<ZQIGListKitTopicModel>(value:topic))
            }
            else if let course = $0.course {
                objects.append(ZQDiffableBox<ZQIGListKitCourseModel>(value:course))
            }
            else if let news = $0.news {
                objects.append(ZQDiffableBox<ZQIGListKitNewsModel>(value:news))
            }
        }
        adapter.performUpdates(animated: true, completion: nil)
    }
}

// MARK: ListAdapterDataSource
extension ZQIGListKitViewModel : ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is ZQDiffableBox<ZQIGListKitTopicModel>:
            return ZQTopicSectionController()
            
        case is ZQDiffableBox<ZQIGListKitCourseModel>:
            return ZQCourseSectionController()
            
        case is ZQDiffableBox<ZQIGListKitNewsModel>:
            return ZQNewsSectionController()
        default: return ListSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let view = UIView().then {
            $0.backgroundColor = .white
        }
        return view
    }
}

//
//  ZQNewsSectionController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/23.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 新闻分区控制器
class ZQNewsSectionController: ListBindingSectionController<ListDiffable> {
    
    private var vms = [ZQDiffableBox<ZQIGListKitNewModel>]()
    
    private lazy var contentHeight:CGFloat = 0
    
    override func didUpdate(to object: Any) {
        guard let aModel = object as? ZQDiffableBox<ZQIGListKitNewsModel> else { return }
        
        vms.removeAll()
        for model in aModel.value.content {
            let box = ZQDiffableBox<ZQIGListKitNewModel>(value: model)
            vms.append(box)
        }
        
        /// 这里计算高度
        /// 没办法用约束自适应高度,只能自己计算 --__--||
        contentHeight = 100
        
        super.didUpdate(to: object)
    }
    
    override init() {
        super.init()
        dataSource = self
        selectionDelegate = self
        supplementaryViewSource = self
    }
}

// MARK: ListBindingSectionControllerDataSource & ListBindingSectionControllerSelectionDelegate & ListSupplementaryViewSource
extension ZQNewsSectionController : ListBindingSectionControllerDataSource, ListBindingSectionControllerSelectionDelegate, ListSupplementaryViewSource {
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        return vms
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        guard let cell = collectionContext?.dequeueReusableCell(of: ZQNewsCollectionViewCell.self, for: self, at: index) as? ZQNewsCollectionViewCell else { return ZQNewsCollectionViewCell() }
        return cell
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        return CGSize(width: zq.selfWidth(), height: contentHeight)
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didSelectItemAt index: Int, viewModel: Any) {
        let title = vms[index].value.title
        print("--__--|| didSelected___\(title)")
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didDeselectItemAt index: Int, viewModel: Any) {}
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didHighlightItemAt index: Int, viewModel: Any) {}
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didUnhighlightItemAt index: Int, viewModel: Any) {}
    
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader, UICollectionView.elementKindSectionFooter]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            let header:ZQIGListKitCollectionSectionHeaderView = collectionContext?.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: ZQIGListKitCollectionSectionHeaderView.self, at: index) as! ZQIGListKitCollectionSectionHeaderView
            header.title = "新闻分区头"
            header.textColor = vms[index].value.color
            return header
            
        case UICollectionView.elementKindSectionFooter:
            let footer:ZQIGListKitCollectionSectionFooterView = collectionContext?.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: ZQIGListKitCollectionSectionFooterView.self, at: index) as! ZQIGListKitCollectionSectionFooterView
            return footer
        default:
            return UICollectionReusableView()
        }
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return CGSize(width: zq.selfWidth(), height: elementKind == UICollectionView.elementKindSectionHeader ? 44 : 8)
    }
}


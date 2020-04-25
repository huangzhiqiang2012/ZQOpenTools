//
//  ZQIGListKitController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/23.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// IGListKit 控制器
class ZQIGListKitController: ZQBaseController {
    
    /**
     Instagram在2016年年底发布了基于数据驱动的UICollectionView框架IGListKit。使用数据驱动去创造更为快速灵活的列表控件。以下是该框架的特点：
     数据驱动（数据改变 -> Diff算法 -> update界面）
     可重复单元和组件的更好体系结构
     解耦的差异算法
     可以为数据模型自定义差异算法
     可扩展的API
     
     架构图                                 SectionController   --->  Cell
     CollectionView                                                  Cell
                     --->  Adapter   --->  SectionController   --->  Cell
     ViewController                                                  Cell
                                           SectionController   --->  Cell
     
     IGListKit的管理者--IGListAdapter
     该框架直接通过IGListAdapter对象去管理UICollectionView并封装了UICollectionViewDelegate、UICollectionViewDataSource的相关实现，同时Adapter和Controller互相持有，用户只需要实现IGListAdapterDataSource就可以实现一个灵活的列表。
     
     IGListAdapter的三个参数：
     IGListAdapterUpdater : 是一个实现了IGListUpdatingDelegate协议的对象，负责处理row和section的刷新。
     Controller : Adapter和Controller互相持有的同时，也负责管理着SectionController。
     WorkingRange : 可以为不可见范围的section准备内容。
     
     IGListAdapter是如何管理UICollectionView的呢？
     我们在和IGListAdapter中寻找和UICollectionViewDelegate、UICollectionViewDataSource相关的方法，发现在IGListAdapter+UICollectionView中有相关实现，以下是代码：
     - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
         return self.sectionMap.objects.count;
     }

     - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
         IGListSectionController * sectionController = [self sectionControllerForSection:section];
         IGAssert(sectionController != nil, @"Nil section controller for section %li for item %@. Check your -diffIdentifier and -isEqual: implementations.",
                  (long)section, [self.sectionMap objectForSection:section]);
         const NSInteger numberOfItems = [sectionController numberOfItems];
         IGAssert(numberOfItems >= 0, @"Cannot return negative number of items %li for section controller %@.", (long)numberOfItems, sectionController);
         return numberOfItems;
     }

     - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
         id<IGListAdapterPerformanceDelegate> performanceDelegate = self.performanceDelegate;
         [performanceDelegate listAdapterWillCallDequeueCell:self];

         IGListSectionController *sectionController = [self sectionControllerForSection:indexPath.section];

         // flag that a cell is being dequeued in case it tries to access a cell in the process
         _isDequeuingCell = YES;
         UICollectionViewCell *cell = [sectionController cellForItemAtIndex:indexPath.item];
         _isDequeuingCell = NO;

         IGAssert(cell != nil, @"Returned a nil cell at indexPath <%@> from section controller: <%@>", indexPath, sectionController);

         // associate the section controller with the cell so that we know which section controller is using it
         [self mapView:cell toSectionController:sectionController];

         [performanceDelegate listAdapter:self didCallDequeueCell:cell onSectionController:sectionController atIndex:indexPath.item];
         return cell;
     }

     - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
         IGListSectionController *sectionController = [self sectionControllerForSection:indexPath.section];
         id <IGListSupplementaryViewSource> supplementarySource = [sectionController supplementaryViewSource];
         UICollectionReusableView *view = [supplementarySource viewForSupplementaryElementOfKind:kind atIndex:indexPath.item];
         IGAssert(view != nil, @"Returned a nil supplementary view at indexPath <%@> from section controller: <%@>, supplementary source: <%@>", indexPath, sectionController, supplementarySource);

         // associate the section controller with the cell so that we know which section controller is using it
         [self mapView:view toSectionController:sectionController];

         return view;
     }

     通过这段代码，我们可以清晰地看到IGListAdapter通过管理着IGListSectionController去实现UICollectionViewDelegate和UICollectionViewDataSource的相关实现，现在，我们去看看几个关键性的方法的实现去探索IGListAdapter的结构。
     - (nullable IGListSectionController *)sectionControllerForSection:(NSInteger)section {
         IGAssertMainThread();
         
         return [self.sectionMap sectionControllerForSection:section];
     }

     - (NSInteger)sectionForSectionController:(IGListSectionController *)sectionController {
         IGAssertMainThread();
         IGParameterAssert(sectionController != nil);

         return [self.sectionMap sectionForSectionController:sectionController];
     }

     - (IGListSectionController *)sectionControllerForObject:(id)object {
         IGAssertMainThread();
         IGParameterAssert(object != nil);

         return [self.sectionMap sectionControllerForObject:object];
     }

     - (id)objectForSectionController:(IGListSectionController *)sectionController {
         IGAssertMainThread();
         IGParameterAssert(sectionController != nil);

         const NSInteger section = [self.sectionMap sectionForSectionController:sectionController];
         return [self.sectionMap objectForSection:section];
     }
     
     上述几个方法，都是IGListAdapter+UICollectionView中实现UICollectionViewDelegate、UICollectionViewDataSource时经常使用的方法，可以清晰地看到sectionMap是这些方法共同使用的属性，sectionMap是IGListKit中自定义的Map类型（IGListSectionMap），通过IGListSectionMap的代码，来一窥IGListAdapter实现管理者的方式。
     
     @interface IGListSectionMap : NSObject <NSCopying>

     - (instancetype)initWithMapTable:(NSMapTable *)mapTable NS_DESIGNATED_INITIALIZER;

     /**
      The objects stored in the map.
      */
     @property (nonatomic, strong, readonly) NSArray *objects;

     /**
      Update the map with objects and the section controller counterparts.

      @param objects The objects in the collection.
      @param sectionControllers The section controllers that map to each object.
      */
     - (void)updateWithObjects:(NSArray <id <NSObject>> *)objects sectionControllers:(NSArray <IGListSectionController *> *)sectionControllers;

     /**
      Fetch a section controller given a section.

      @param section The section index of the section controller.

      @return A section controller.
      */
     - (nullable IGListSectionController *)sectionControllerForSection:(NSInteger)section;

     /**
      Fetch the object for a section

      @param section The section index of the object.

      @return The object corresponding to the section.
      */
     - (nullable id)objectForSection:(NSInteger)section;

     /**
      Fetch a section controller given an object. Can return nil.

      @param object The object that maps to a section controller.

      @return A section controller.
      */
     - (nullable id)sectionControllerForObject:(id)object;

     /**
      Look up the section index for a section controller.

      @param sectionController The list to look up.

      @return The section index of the given section controller if it exists, NSNotFound otherwise.
      */
     - (NSInteger)sectionForSectionController:(id)sectionController;

     /**
      Look up the section index for an object.

      @param object The object to look up.

      @return The section index of the given object if it exists, NSNotFound otherwise.
      */
     - (NSInteger)sectionForObject:(id)object;
     
     这是IGListSectionMap中主要的几个实现，也是经常用到的几个，我们再看看IGListSectionMap中的变量，很简单。
     @interface IGListSectionMap ()

     // both of these maps allow fast lookups of objects, list objects, and indexes
     @property (nonatomic, strong, readonly, nonnull) NSMapTable<id, IGListSectionController *> *objectToSectionControllerMap;
     @property (nonatomic, strong, readonly, nonnull) NSMapTable<IGListSectionController *, NSNumber *> *sectionControllerToSectionMap;

     @property (nonatomic, strong, nonnull) NSMutableArray *mObjects;

     @end
     
     通过这两个变量的名称以及注释，也可以判断出该结构支持“双向查找”。再看看更新方法，确认一下是不是这么回事。
     - (void)updateWithObjects:(NSArray *)objects sectionControllers:(NSArray *)sectionControllers {
         IGParameterAssert(objects.count == sectionControllers.count);

         [self reset];

         self.mObjects = [objects mutableCopy];

         id firstObject = objects.firstObject;
         id lastObject = objects.lastObject;

         [objects enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
             IGListSectionController *sectionController = sectionControllers[idx];

             // set the index of the list for easy reverse lookup
             [self.sectionControllerToSectionMap setObject:@(idx) forKey:sectionController];
             [self.objectToSectionControllerMap setObject:sectionController forKey:object];

             sectionController.isFirstSection = (object == firstObject);
             sectionController.isLastSection = (object == lastObject);
             sectionController.section = (NSInteger)idx;
         }];
     }
     由此可见，该结构是很灵活的，在IGListSectionMap结构的辅助下，IGListAdapter可以控制UICollectionView下层的IGListSectionController，通过IGListSectionController也通过IGListBindingSectionControllerDataSource去管理着UICollectionViewCell、ViewModel以及Cell的展示。
     */
    
    private var viewModel:ZQIGListKitViewModel!
    
    private lazy var layout:ListCollectionViewLayout = ListCollectionViewLayout(stickyHeaders: true, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: true).then {
        $0.showHeaderWhenEmpty = true
    }
    
    private lazy var collectionView:ListCollectionView = ListCollectionView(frame: .zero, listCollectionViewLayout: layout).then {
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ZQIGListKitViewModel(vc: {[weak self] () -> UIViewController? in
            return self
        }, collectionView: {[weak self] () -> UICollectionView? in
            return self?.collectionView
        })
        viewModel.requestData()
    }
    
    override func setupViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

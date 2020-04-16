//
//  ZQTextureController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/30.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Texture 控制器
class ZQTextureController: ZQBaseASViewController {
    
    /**
     Texture也就是AsyncDisplayKit,是一个UI框架，最初诞生于 Facebook 的 Paper 应用程序。它是为了解决 Paper 团队面临的核心问题之一：尽可能缓解主线程的压力。它能在异步线程绘制修改UI，然后统一添加进内存渲染出来。
     
     1.解决的问题
     很多时候用户在操作app的时候，会感觉到不适那么流畅，有所卡顿。
     ASDK主要就是解决的问题就是操作页面过程中的保持帧率在60fps（理想状态下）的问题。

     造成卡顿的原因有很多，总结一句话基本上就是：
     CPU或GPU消耗过大，导致在一次同步信号之间没有准备完成，没有内容提交，导致掉帧的问题。
     
     2.优化原理
     1) 布局：
     iOS自带的Autolayout在布局性能上存在瓶颈，并且只能在主线程进行计算。因此ASDK弃用了Autolayout，自己参考自家的ComponentKit设计了一套布局方式。
     2) 渲染
     对于大量文本，图片等的渲染，UIKit组件只能在主线程并且可能会造成GPU绘制的资源紧张。ASDK使用了一些方法，比如图层的预混合等，并且异步的在后台绘制图层，不阻塞主线程的运行。
     3) 系统对象创建与销毁
     UIKit组件封装了CALayer图层的对象，在创建、调整、销毁的时候，都会在主线程消耗资源。ASDK自己设计了一套Node机制，也能够调用。
     实际上，从上面的一些解释也可以看出，ASDK最大的特点就是"异步"。
     将消耗时间的渲染、图片解码、布局以及其它 UI 操作等等全部移出主线程，这样主线程就可以对用户的操作及时做出反应，来达到流畅运行的目的。
     ASDK 认为，阻塞主线程的任务，主要分为上面这三大类。
     为了尽量优化性能，ASDK 尝试对 UIKit 组件进行封装：
     
     3.Nodes节点
     如果你之前使用过views，那么你应该已经知道如何使用nodes，大部分的方法都有一个等效的node，大部分的UIView和CALayer的属性都有类似的可用的。任何情况都会有一点点命名差异（例如，clipsToBounds和masksToBounds），node基本上都是默认使用UIView的名字，唯一的例外是node使用position而不是center
     当然，你也可以直接访问底层view和layer，使用node.view和node.layer
     这是常见的 UIView 和 CALayer 的关系：View 持有 Layer 用于显示，View 响应触摸事件。
               .view                 .layer
     ASNode  ---------->  UIView   ----------> CALayer
             <----------           <----------
                .node                .delegate
     
     二、使用
     1.ASImageNode
     使用ASNetworkImageNode的URL设置网络图片。
     ASNetworkImageNode有图片下载的ASNetworkImageNodeDelegate
     ASImageNode使用ASDK的图片管理类PINCache,PINRemoteImage
     如果不打算引入PINRemoteImage和PINCache，你会失去对jpeg的更好的支持，你需要自行引入你自己的cache系统，需要遵从ASImageCacheProtocol

     2.ASTextNode
     ASTextNode没有text属性，只能使用attributedText
     NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
     paragraphStyle.alignment = NSTextAlignmentCenter;
     labelNode.attributedText = [[NSAttributedString alloc] initWithString:@"居中文字" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                                                                                           NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                                           NSBackgroundColorAttributeName : [UIColor clearColor],
                                                                                                           NSParagraphStyleAttributeName:paragraphStyle}];
     
     3.ASTableNode/ASCollectionNode
     ASTableNode/ASCollectionNode不支持复用机制，每次滚动都会重新创建cell。
     ASTableNode并不提供类似UITableview的-tableView:heightForRowAtIndexPath:方法，这是因为节点基于自己的约束来确定自己的高度，就是说你不再需要写代码来确定这个细节，一个node通过-layoutSpecThatFits:方法返回的布局规则确定了行高，所有的节点只要提供了约束大小，就有能力自己确定自己的尺寸
     使用 Batch Fetching 进行无限滚动，即预加载功能
    
     AsyncDispalyKit reloadData刷新列表闪屏问题分析
     ASTableNode和ASCollectionNode进行reloadData时，每次都需要将之前cellNode移除，然后重新添加新的cellNode。这个过程中，当异步计算cell的布局时，cell使用placeholder占位（通常是白图），布局完成时，才用渲染好的内容填充cell，placeholder到渲染好的内容切换引起闪烁。UITableViewCell因为都是同步，不存在占位图的情况，因此也就不会闪。
     
     这个官方给出的解决方案是：

     cellNode.neverShowPlaceholders = YES;
     
     这样设置以后，会让cell从异步加载衰退回同步状态，若reload某个indexPath的cell, 在渲染完成之前，主线程是卡死的，这就和tableView原始的加载方式一样了，但会比tableView速度快很多，因为UITableView的布局计算、资源解压、视图合成等都是在主线程进行，而ASTableNode则是多个线程并发进行，何况布局等还有缓存。但当页面布局很多，刷新cell很多的时候，下拉掉帧就比较明显，但我们知道ASTableNode具有预加载的相关设置，可以设置leadingScreensForBatching减缓卡顿，但仍然不完美，时间换空间而已。我们要做到的是该异步的异步，又能不卡顿，又可以预加载。为此提供解决方案：
     参见ZQExtensions.swift文件中对ASTableNode的延展

     三、布局
     ASDK 拥有自己的一套成熟布局方案，虽然学习成本略高，但至少比原生的 AutoLayout 写起来舒服，重点是性能比起 AutoLayout 好的不是一点点。（ASDK不支持autoLayout）
     
     //下面这个方法就是用来建立布局规则对象，产生 node 大小以及所有子 node 大小的地方，你创建的布局规则对象一直持续到这个方法返回的时间点，经过了这个时间点后，它就不可变了。尤其重要要记住的一点事，千万不要缓存布局规则对象，当你以后需要他的时候，请重新创建。
     //调用时机：ASDisplayNode 在初始化之后会检查是否有子视图，如果有就会调用
     - (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
     
     1. 布局类
     ASAbsoluteLayoutSpec（绝对布局约束)
     ASBackgroundLayoutSpec（背景布局规则）
     ASInsetLayoutSpec（边距布局规则）
     ASOverlayLayoutSpec（覆盖布局规则）
     ASRatioLayoutSpec（比例布局规则）
     ASRelativeLayoutSpec（相对布局规则）
     ASCenterLayoutSpec（中心布局规则）
     ASStackLayoutSpec（堆叠布局规则）
     ASWrapperLayoutSpec （填充布局规则）
     
     2.示例
     ASAbsoluteLayoutSpec
     - (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
       self.childNode.style.layoutPosition = CGPointMake(100, 100);
       self.childNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(100), ASDimensionMake(100));
       ASAbsoluteLayoutSpec *absoluteLayout = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[self.childNode]];
       return absoluteLayout;
     }
     使用方法和原生的绝对布局类似
     
     ASBackgroundLayoutSpec
     - (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
       ASBackgroundLayoutSpec *backgroundLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:self.childNodeB background:self.childNodeA];
       return backgroundLayout;
     }
     把childNodeA 做为 childNodeB 的背景，也就是 childNodeB 在上层，要注意的是 ASBackgroundLayoutSpec 事实上根本不会改变视图的层级关系
     
     ASInsetLayoutSpec
     - (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
         ASInsetLayoutSpec *inset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_childNode];
         return insetLayout;
     }
     _childNode 相对于父视图边距都为 0，相当于填充整个父视图。
     
     ASOverlayLayoutSpec
     - (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
       _photoNode.style.preferredSize = CGSizeMake(USER_IMAGE_HEIGHT*2, USER_IMAGE_HEIGHT*2);

       // INIFINITY(插入无边界)
       UIEdgeInsets insets = UIEdgeInsetsMake(INFINITY, 12, 12, 12);
       ASInsetLayoutSpec *textInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:_titleNode];
       return [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_photoNode
                                                      overlay:textInsetSpec];
     }
     类似于ASBackgroundLayoutSpec，都是设置层级关系
     
     ASRatioLayoutSpec
     - (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
         ASRatioLayoutSpec *ratioLayout = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1.0f child:self.childNodeA];
         return ratioLayout;
     }
     比较常用的一个类，作用是设置自身的高宽比，例如设置正方形的视图
     
     ASRelativeLayoutSpec
     //把 childNodeA 显示在右上角。
         self.childNodeA.style.preferredSize = CGSizeMake(100, 100);
         ASRelativeLayoutSpec *relativeLayout = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionEnd verticalPosition:ASRelativeLayoutSpecPositionStart sizingOption:ASRelativeLayoutSpecSizingOptionDefault child:self.childNodeA];
         return relativeLayout;
     }
     它可以把视图布局在：左上、左下、右上、右下四个顶点以外，还可以设置成居中布局。
     
     ASCenterLayoutSpec
     - (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
         self.childNodeA.style.preferredSize = CGSizeMake(100, 100);
         ASCenterLayoutSpec *relativeLayout = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:self.childNodeA];
         return relativeLayout;
     }
     
     ASWrapperLayoutSpec
     - (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
         ASWrapperLayoutSpec *wrapperLayout = [ASWrapperLayoutSpec wrapperWithLayoutElement:self.childNodeA];
         return wrapperLayout;
     }
     填充整个视图
     
     ASStackLayoutSpec
     可以说这是最常用的类，而且相对于其他类来说在功能上是最接近于 AutoLayout 的。
     之所以称之为盒子布局是因为它和 CSS 中 Flexbox 很相似，不清楚 Flexbox 的可以看下
     - (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{

       // 当用户名和位置信息文本太长时,收缩堆放视图来适应屏幕,而不是将所有内容向右堆放
       ASStackLayoutSpec *nameLocationStack = [ASStackLayoutSpec verticalStackLayoutSpec];
       nameLocationStack.style.flexShrink = 1.0;
       nameLocationStack.style.flexGrow = 1.0;

       //如果从服务器获取位置信息,并检查位置信息是否可用
       if (_postLocationNode.attributedText) {
         nameLocationStack.children = @[_usernameNode, _postLocationNode];
       } else {
         nameLocationStack.children = @[_usernameNode];
       }

       //水平堆放
       ASStackLayoutSpec *headerStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                          spacing:40
                   justifyContent:ASStackLayoutJustifyContentStart
                       alignItems:ASStackLayoutAlignItemsCenter
                         children:@[nameLocationStack, _postTimeNode]];

       //插入堆放
       return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 10, 0, 10)
                                                     child:headerStackSpec];

     }
     简单的说明下各个参数的作用：
     1.direction：主轴的方向，有两个可选值：
     纵向：ASStackLayoutDirectionVertical(默认)
     横向：ASStackLayoutDirectionHorizontal
     
     2.spacing: 主轴上视图排列的间距，比如有四个视图，那么它们之间的存在三个间距值都应该是spacing
     
     3.justifyContent: 主轴上的排列方式，有五个可选值：
     ASStackLayoutJustifyContentStart 从前往后排列
     ASStackLayoutJustifyContentCenter 居中排列
     ASStackLayoutJustifyContentEnd 从后往前排列
     ASStackLayoutJustifyContentSpaceBetween 间隔排列，两端无间隔
     ASStackLayoutJustifyContentSpaceAround 间隔排列，两端有间隔
     
     4.alignItems: 交叉轴上的排列方式，有五个可选值：
     ASStackLayoutAlignItemsStart 从前往后排列
     ASStackLayoutAlignItemsEnd 从后往前排列
     ASStackLayoutAlignItemsCenter 居中排列
     ASStackLayoutAlignItemsStretch 拉伸排列
     ASStackLayoutAlignItemsBaselineFirst 以第一个文字元素基线排列（主轴是横向才可用）
     ASStackLayoutAlignItemsBaselineLast 以最后一个文字元素基线排列（主轴是横向才可用）
     
     5.children: 包含的视图。数组内元素顺序同样代表着布局时排列的顺序
     
     四、优缺点
     不支持大家常用的storyboard、xib、autoLayout，影响开发效率
     代码没有UIKit使用熟练
     网上资源少
     但是可以和UIKit混合开发
     */
    
    private let uid:String = "300763"
    
    private lazy var disposeBag:DisposeBag = DisposeBag()
    
    private lazy var viewModel:ZQTextureViewModel = ZQTextureViewModel()
    
    private lazy var tableNode:ZQASTableNode = ZQASTableNode(style:.grouped, dataSource: self, delegate: self).then {
        $0.backgroundColor = .white
        $0.view.zq.addMJRefreshHeader { [weak self] in
            self?.requestData(isFirstFetch: true)
        }
        $0.view.zq.addMJRefreshFooter { [weak self] in
            self?.requestData(isFirstFetch: false)
        }
    }
    
    /**
     建议不要使用这个方法，因为它相对于 viewDidLoad 来说没有明显的优势反而有很多不足的地方。但如果你不去设置 self.view 的属性就没什么问题。调用 [super loadView]它就会执行 node.view 。
     */
//    override func loadView() {
//        super.loadView()
//    }
    
    /**
     它会在 ASViewController 的生命周期的最开始调用，仅次于 -loadView 。这是你使用节点的 view 最早的时机。在这个方法里适合放只执行一次并且要使用 view/layer 的代码，比如加手势。
     布局的代码千万不要放在这个方法里，因为界面发生改变也不会再调用这个方法重新布局。
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        creatNode()
        addObserve()
        requestData(isFirstFetch: true)
    }
    
    /**
     这个方法调用的时机和节点 -layout 方法调用的时机一样，它可以被执行很多次。只要它的节点被改变（比如旋转，分屏，显示键盘）或者继承（）都会立即被调用。
     */
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//    }
}

// MARK: private
extension ZQTextureController {
    
    private func requestData(isFirstFetch:Bool) {
        viewModel.requestListData(isFirstFetch: isFirstFetch, uid: uid, scrollView: tableNode.view) {[weak self] in
            if let self = self {
                self.tableNode.reloadData()
            }
        }
    }
    
    private func addObserve() {
        tableNode.view.rx.observe(String.self, "contentSize").subscribe(onNext: {[weak self] value in
            if let self = self {
                let height = self.tableNode.view.contentSize.height
                if height > 0 {
                    self.tableNode.transitionLayout(withAnimation: false, shouldMeasureAsync: false)
                    self.contentNode.transitionLayout(withAnimation: false, shouldMeasureAsync: false)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func creatNode() {
        contentNode.layoutSpecBlock = {[weak self] (node, constrainedSize) -> ASLayoutSpec in
            guard let self = self else { return ASLayoutSpec()}
            let inset = ASInsetLayoutSpec(insets:node.safeAreaInsets, child: self.tableNode)
            return inset
        }
    }
}

// MARK: ASTableDataSource & ASTableDelegate
extension ZQTextureController : ASTableDataSource, ASTableDelegate {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return viewModel.articleListDic.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articleListDic[section].value.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] () -> ASCellNode in
            let cellNode = ZQTextureListCellNode()
            if let self = self {
                let value = self.viewModel.articleListDic[indexPath.section].value
                cellNode.hideLine = indexPath.row == value.count - 1
                let model = value[indexPath.row]
                
                /// 配合reloadDataWithoutFlashing刷新方法一起使用
                if tableNode.reloadIndexPaths.contains(indexPath) {
                    cellNode.neverShowPlaceholders = true
                    cellNode.model = model
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        cellNode.neverShowPlaceholders = false
                    }
                }
                else {
                    cellNode.neverShowPlaceholders = false
                    cellNode.model = model
                }
            }
            return cellNode
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let vc = ZQTextureDetailController()
        vc.id = "\(viewModel.articleListDic[indexPath.section].value[indexPath.row].id)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView().then {
            $0.backgroundColor = .clear
        }
        let dateArr = viewModel.articleListDic[section].key.components(separatedBy: "-")
        if let month = dateArr[safe:1], let day = dateArr[safe: 2] {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 60)).then {
                $0.numberOfLines = 2
            }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let att = NSMutableAttributedString(string: day, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.paragraphStyle : paragraphStyle])
            att.append(NSAttributedString(string: "\n\(month)月", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.paragraphStyle : paragraphStyle]))
            label.attributedText = att
            view.addSubview(label)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView().then {
            $0.backgroundColor = .systemGroupedBackground
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
}



//
//  ZQHeroController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/5/10.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Hero 控制器
class ZQHeroController: ZQBaseController {
    
    private let defaultButtonTag = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        let titles = ["Built in Animations", "Match Animation", "Match Cell in CollectionView", "App Store Transition"]
        let top = 50
        let height = 30
        for i in 0..<titles.count {
            let button = UIButton(type: .custom).then {
                $0.backgroundColor = .blue
                $0.setTitle(titles[i], for: .normal)
                $0.zq.addRadius(radius: 20)
                $0.tag = defaultButtonTag + i
                $0.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
            }
            view.addSubview(button)
            button.snp.makeConstraints { (m) in
                m.centerX.equalToSuperview()
                m.top.equalTo(top + (height + top) * i)
                m.width.equalTo(250)
                m.height.equalTo(40)
            }
        }
    }
    
    @objc private func actionForButton(_ sender:UIButton) {
        switch sender.tag - defaultButtonTag {
        case 0:
            let vc = ZQHeroBuiltInTransitionController()
            vc.hero.isEnabled = false  // 用系统原生的present动画
            present(vc, animated: true, completion: nil)
            
        case 1:
            let vc = ZQHeroMatchController()
            vc.hero.isEnabled = false  // 用系统原生的present动画
            present(vc, animated: true, completion: nil)
            
        case 2:
            let vc = ZQHeroMatchInCollectionController()
            vc.hero.isEnabled = false  // 用系统原生的present动画
            present(vc, animated: true, completion: nil)
            
        case 3:
            let vc = ZQHeroAppStoreController()
            vc.hero.isEnabled = false  // 用系统原生的present动画
            present(vc, animated: true, completion: nil)
            
        default:
            break
        }
    }
}

// MARK: 动画基础控制器
class ZQHeroAnimationBaseController: ZQBaseController {
    
    let dismissButton = UIButton(type: .custom).then {
        $0.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        $0.center = CGPoint(x: 30, y: 60)
        $0.setTitle("Back", for: .normal)
        $0.setTitleColor(.red, for: .normal)
        $0.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    var tapGesture:UITapGestureRecognizer?
    
    override func setupViews() {
        view.backgroundColor = .lightGray
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tapGesture)
        self.tapGesture = tapGesture
        view.addSubview(dismissButton)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hero.isEnabled = true
        
        /// 不设置全屏的话, 上面会有一些黑色空白 --__--||
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onTap() {
        back()
    }

    @objc private func back() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Built in Animations 控制器
class ZQHeroBuiltInTransitionController: ZQHeroAnimationBaseController {
    
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = .brown
    }
    
    override func onTap() {
        let vc = ZQHeroAnimationBaseController()
//        vc.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .left), dismissing: .slide(direction: .down))
//        vc.hero.modalAnimationType = .zoom
//        vc.hero.modalAnimationType = .pageIn(direction: .left)
//        vc.hero.modalAnimationType = .pull(direction: .left)
        vc.hero.modalAnimationType = .autoReverse(presenting: .pageIn(direction: .left))
        present(vc, animated: true, completion: nil)
    }
}

// MARK: Match Animation 控制器
class ZQHeroMatchController: ZQHeroAnimationBaseController {
    
    override func setupViews() {
        super.setupViews()
        let backView = UIView().then {
            $0.backgroundColor = .black
            $0.zq.addRadius(radius: 8)
            $0.hero.id = "batMan"
        }
        let redView = UIView().then {
            $0.backgroundColor = .red
            $0.zq.addRadius(radius: 8)
            $0.hero.id = "ironMan"
        }
        view.zq.addSubViews([backView, redView])
        backView.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalTo(100)
            m.width.equalTo(200)
            m.height.equalTo(80)
        }
        redView.snp.makeConstraints { (m) in
            m.top.equalTo(backView.snp.bottom)
            m.centerX.width.equalTo(backView)
            m.height.equalTo(200)
        }
    }
    
    override func onTap() {
        present(ZQHeroMatchController1(), animated: true, completion: nil)
    }
}

class ZQHeroMatchController1: ZQHeroAnimationBaseController {
    
    override func setupViews() {
        super.setupViews()
        let backView = UIView().then {
            $0.backgroundColor = .black
            $0.zq.addRadius(radius: 8)
            $0.hero.id = "batMan"
        }
        let redView = UIView().then {
            $0.backgroundColor = .red
            $0.zq.addRadius(radius: 8)
            $0.hero.id = "ironMan"
        }
        let backgroundView = UIView().then {
            $0.backgroundColor = .blue
            $0.zq.addRadius(radius: 8)
            $0.hero.modifiers = [.translate(y: 500), .useGlobalCoordinateSpace]
        }
        view.zq.addSubViews([redView, backView, backgroundView])
        backView.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.centerY.equalTo(130)
            m.width.equalTo(250)
            m.height.equalTo(60)
        }
        redView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints { (m) in
            m.top.equalTo(backView.snp.bottom).offset(50)
            m.centerX.width.equalTo(backView)
            m.height.equalTo(view.bounds.size.height - 320)
        }
    }
}

// MARK: Match Cell in CollectionView 控制器
class ZQHeroMatchInCollectionController: ZQHeroAnimationBaseController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func setupViews() {
        super.setupViews()
        
        /// view添加了点击手势,有穿透,不会执行这个方法,只会执行点击手势方法, 不会执行didSelectItem方法,因此需要移除手势--__--||
        if let tap = tapGesture {
            view.removeGestureRecognizer(tap)
        }
        
        let layout = UICollectionViewFlowLayout()
        let width = (view.bounds.size.width - 60) / 3
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .white
            $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
            $0.delegate = self
            $0.dataSource = self
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (m) in
            m.top.equalTo(100)
            m.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            m.leading.trailing.equalToSuperview()
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.self), for: indexPath)
        let item = indexPath.item
        cell.zq.addRadius(radius: 8)
        cell.backgroundColor = UIColor(hue: CGFloat(item) / 30, saturation: 0.68, brightness: 0.98, alpha: 1)
        let tag = 2000
        let label = UILabel(frame: cell.contentView.bounds).then {
            $0.text = "\(item)"
            $0.textColor = .white
            $0.textAlignment = .center
            $0.tag = tag
            $0.isUserInteractionEnabled = true
        }
        cell.viewWithTag(tag)?.removeFromSuperview()
        cell.contentView.addSubview(label)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let heroId = "cell\(indexPath.item)"
        cell.hero.id = heroId
        let vc = ZQHeroMatchInCollectionController1()
        vc.contentView.backgroundColor = cell.backgroundColor
        vc.contentView.hero.id = heroId
        present(vc, animated: true, completion: nil)
    }
}

class ZQHeroMatchInCollectionController1: ZQHeroAnimationBaseController {
    let contentView = UIView().then {
        $0.zq.addRadius(radius: 8)
    }
    override func setupViews() {
        super.setupViews()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (m) in
            m.top.equalTo(140)
            m.centerX.equalToSuperview()
            m.width.equalTo(250)
            m.height.equalTo(view.bounds.size.height - 280)
        }
    }
}

class ZQHeroAppStoreCardView: UIView {
    
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let titleLabel = UILabel().then {
        $0.text = "Hero"
        $0.font = UIFont.boldSystemFont(ofSize: 32)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "App Store Card Transition"
        $0.font = UIFont.systemFont(ofSize: 17)
    }
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        zq.addSubViews([imageView, visualEffectView, titleLabel, subtitleLabel])
        
        /// 不要用约束,不然动画切换时不会重新布局--__--||
//        imageView.snp.makeConstraints { (m) in
//            m.edges.equalToSuperview()
//        }
//        visualEffectView.snp.makeConstraints { (m) in
//            m.top.leading.trailing.equalToSuperview()
//            m.height.equalTo(90)
//        }
//        titleLabel.snp.makeConstraints { (m) in
//            m.leading.top.equalTo(20)
//            m.trailing.equalTo(-20)
//            m.height.equalTo(30)
//        }
//        subtitleLabel.snp.makeConstraints { (m) in
//            m.leading.width.height.equalTo(titleLabel)
//            m.top.equalTo(titleLabel.snp.bottom)
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        visualEffectView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 90)
        titleLabel.frame = CGRect(x: 20, y: 20, width: bounds.width - 40, height: 30)
        subtitleLabel.frame = CGRect(x: 20, y: 50, width: bounds.width - 40, height: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ZQHeroRoundedCardWrapperView: UIView {
    let cardView = ZQHeroAppStoreCardView().then {
        $0.zq.addRadius(radius: 16)
    }
    
    var isTouched: Bool = false {
        didSet {
            var transform = CGAffineTransform.identity
            if isTouched { transform = transform.scaledBy(x: 0.96, y: 0.96) }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                self.transform = transform
            }, completion: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 8)
        addSubview(cardView)
        
        /// 不要用约束,不然动画切换时不会重新布局--__--||
//        cardView.snp.makeConstraints { (m) in
//            m.edges.equalToSuperview()
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if cardView.superview == self {
          // this is necessary because we used `.useNoSnapshot` modifier on cardView.
          // we don't want cardView to be resized when Hero is using it for transition
          cardView.frame = bounds
        }
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isTouched = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isTouched = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isTouched = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ZQHeroAppStoreCollectionViewCell: UICollectionViewCell {
    
    let wrapperView = ZQHeroRoundedCardWrapperView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(wrapperView)
        
        /// 不要用约束,不然动画切换时不会重新布局--__--||
//        wrapperView.snp.makeConstraints { (m) in
//            m.edges.equalToSuperview()
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wrapperView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: App Store Transition 控制器
class ZQHeroAppStoreController: ZQHeroAnimationBaseController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let layout = UICollectionViewFlowLayout().then {
        let width = UIScreen.main.bounds.size.width - 30
        $0.itemSize = CGSize(width: width, height: width)
        $0.sectionInset = UIEdgeInsets(top: 100, left: 15, bottom: 0, right: 15)
    }
    
    private var collectionView:UICollectionView!
        
    override func setupViews() {
        super.setupViews()
        
        /// view添加了点击手势,有穿透,不会执行这个方法,只会执行点击手势方法, 不会执行didSelectItem方法,因此需要移除手势--__--||
        if let tap = tapGesture {
            view.removeGestureRecognizer(tap)
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .white
            $0.delaysContentTouches = false
            $0.register(ZQHeroAppStoreCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZQHeroAppStoreCollectionViewCell.self))
            $0.delegate = self
            $0.dataSource = self
        }
        view.insertSubview(collectionView, belowSubview: dismissButton)
        
        /// 不要用约束,不然动画切换时不会重新布局--__--||
//        collectionView.snp.makeConstraints { (m) in
//            m.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//            m.top.leading.trailing.equalToSuperview()
//        }
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      collectionView.frame = view.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ZQHeroAppStoreCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZQHeroAppStoreCollectionViewCell.self), for: indexPath) as! ZQHeroAppStoreCollectionViewCell
        cell.wrapperView.cardView.imageView.image = UIImage(named: "Unsplash\(indexPath.item)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell:ZQHeroAppStoreCollectionViewCell = collectionView.cellForItem(at: indexPath) as? ZQHeroAppStoreCollectionViewCell else { return }
        let cardHeroId = "cell\(indexPath.item)"
        let modifiers:[HeroModifier] = [.useNoSnapshot, .spring(stiffness: 250, damping: 25)]
        cell.wrapperView.cardView.hero.modifiers = modifiers
        cell.wrapperView.cardView.hero.id = cardHeroId
        
        let vc = ZQHeroAppStoreController1()
        vc.hero.modalAnimationType = .none
        vc.cardView.hero.id = cardHeroId
        vc.cardView.hero.modifiers = modifiers
        vc.cardView.imageView.image = UIImage(named: "Unsplash\(indexPath.item)")
        
        vc.contentCard.hero.modifiers = [.source(heroID: cardHeroId), .spring(stiffness: 250, damping: 25)]
        vc.contentView.hero.modifiers = [.useNoSnapshot, .forceAnimate, .spring(stiffness: 250, damping: 25)]
        vc.visualEffectView.hero.modifiers = [.fade, .useNoSnapshot]
        present(vc, animated: true, completion: nil)
    }
}

class ZQHeroAppStoreController1: ZQHeroAnimationBaseController {
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    let cardView = ZQHeroAppStoreCardView()
    
    let contentView = UILabel().then {
        $0.numberOfLines = 0
        $0.text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent neque est, hendrerit vitae nibh ultrices, accumsan elementum ante. Phasellus fringilla sapien non lorem consectetur, in ullamcorper tortor condimentum. Nulla tincidunt iaculis maximus. Sed ut urna urna. Nulla at sem vel neque scelerisque imperdiet. Donec ornare luctus dapibus. Donec aliquet ante augue, at pellentesque ipsum mollis eget. Cras vulputate mauris ac eleifend sollicitudin. Vivamus ut posuere odio. Suspendisse vulputate sem vel felis vehicula iaculis. Fusce sagittis, eros quis consequat tincidunt, arcu nunc ornare nulla, non egestas dolor ex at ipsum. Cras et massa sit amet quam imperdiet viverra. Mauris vitae finibus nibh, ac vulputate sapien.
        """
    }
    
    let contentCard = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = .clear
        contentCard.zq.addSubViews([cardView, contentView])
        view.zq.addSubViews([visualEffectView, contentCard])
        
        /// 不要用约束,不然动画切换时不会重新布局--__--||
//        visualEffectView.snp.makeConstraints { (m) in
//            m.edges.equalToSuperview()
//        }
//        contentCard.snp.makeConstraints { (m) in
//            m.edges.equalToSuperview()
//        }
//        cardView.snp.makeConstraints { (m) in
//            m.leading.top.equalToSuperview()
//            m.width.height.equalTo(width)
//        }
//        contentView.snp.makeConstraints { (m) in
//            m.left.equalTo(20)
//            m.top.equalTo(width + 20)
//            m.width.equalTo(width - 40)
//            m.height.equalTo(200)
//        }
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(gr:))))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bounds = view.bounds
        visualEffectView.frame  = bounds
        contentCard.frame  = bounds
        cardView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width)
        contentView.frame = CGRect(x: 20, y: bounds.width + 20, width: bounds.width - 40, height: bounds.height - bounds.width - 20)
    }
    
    @objc func handlePan(gr: UIPanGestureRecognizer) {
      let translation = gr.translation(in: view)
      switch gr.state {
      case .began:
        dismiss(animated: true, completion: nil)
      case .changed:
        Hero.shared.update(translation.y / view.bounds.height)
      default:
        let velocity = gr.velocity(in: view)
        if ((translation.y + velocity.y) / view.bounds.height) > 0.5 {
          Hero.shared.finish()
        }
        else {
          Hero.shared.cancel()
        }
      }
    }
}

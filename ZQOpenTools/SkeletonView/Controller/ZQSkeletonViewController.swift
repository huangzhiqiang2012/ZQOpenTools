//
//  ZQSkeletonViewController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/4/21.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

class ZQSkeletonHeaderFooterSection: UITableViewHeaderFooterView {
    lazy var titleLabel: UILabel = UILabel().then {
        
        /// 赋值,才能显示Skeleton
        $0.text = "Header Footer View"
        $0.isSkeletonable = true
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        backgroundView = UIView()
        backgroundView?.backgroundColor = .white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (m) in
            m.leading.top.equalTo(10)
            m.bottom.equalTo(-10).priority(.high)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ZQSkeletonTableViewCell: UITableViewCell {
    private lazy var headerImageView:UIImageView = UIImageView().then {
        $0.image = UIImage(named: "skeleton_avatar")
        $0.isSkeletonable = true
    }
    
    lazy var desLabel:UILabel = UILabel().then {
        
        /// 赋值,才能显示Skeleton
        $0.text = "ZQSkeletonTableViewCell"
        $0.numberOfLines = 0
        $0.isSkeletonable = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        selectionStyle = .none
        contentView.zq.addSubViews([headerImageView, desLabel])
        headerImageView.snp.makeConstraints { (m) in
            m.leading.top.equalTo(15)
            m.width.height.equalTo(82)
            m.bottom.equalTo(-15).priority(.high)
        }
        desLabel.snp.makeConstraints { (m) in
            m.leading.equalTo(headerImageView.snp.trailing).offset(10)
            m.trailing.equalTo(-15)
            m.top.equalTo(headerImageView)
                        
            /// 这样约束不能正确显示Skeleton
//            m.height.lessThanOrEqualTo(headerImageView)
            
            /// 这样约束不能正确显示Skeleton
//            m.bottom.equalTo(headerImageView)
            
            /// 必须规定高,同时得是具体的数值,才能显示Skeleton
            m.height.lessThanOrEqualTo(82)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// SkeletonView控制器
class ZQSkeletonViewController: ZQBaseController {
    
    /**
     本质上是为View添加相同形状的mask，然后在Mask上添加动画
     1 找到需要添加骨骼视图的View
     2 根据View生成具有相同形状的骨骼Mask视图
     3 对骨骼Mask视图进行插入，更新和删除
     */
    
    private lazy var headerImageView:UIImageView = UIImageView().then {
        $0.image = UIImage(named: "skeleton_avatar")
        $0.zq.addRadius(radius: 46)
        $0.isSkeletonable = true
    }
    
    private lazy var desTextView:UITextView = UITextView().then {
        $0.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
        $0.font = .systemFont(ofSize: 15)
        $0.isEditable = false
        $0.isSkeletonable = true
    }
    
    private lazy var tableView:UITableView = UITableView().then {
        
        /// 必须设置预估高度,才能显示Skeleton
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.sectionFooterHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 112.0
        $0.estimatedSectionFooterHeight = 20.0
        $0.estimatedSectionHeaderHeight = 20.0
        
        $0.separatorStyle = .none
        $0.register(ZQSkeletonHeaderFooterSection.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(ZQSkeletonHeaderFooterSection.self))
        $0.register(ZQSkeletonHeaderFooterSection.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(ZQSkeletonHeaderFooterSection.self))
        $0.register(ZQSkeletonTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ZQSkeletonTableViewCell.self))
        $0.dataSource = self
        $0.delegate = self
        $0.isSkeletonable = true
    }
    
    private lazy var styleSegment:UISegmentedControl = UISegmentedControl(items: ["Solid", "Gradient"]).then {
        $0.selectedSegmentIndex = 0
        $0.addTarget(self, action: #selector(actionForStyleSegment), for: .valueChanged)
    }
    
    private lazy var animatedLabel:UILabel = UILabel().then {
        $0.text = "Animated"
    }
    
    private lazy var animatedSwitch:UISwitch = UISwitch().then {
        $0.isOn = true
        $0.addTarget(self, action: #selector(actionForAnimatedSwitch), for: .valueChanged)
    }
    
    private lazy var colorButton:UIButton = UIButton(type: .custom).then {
        $0.setTitle("Color", for: .normal)
        $0.setTitleColor(SkeletonAppearance.default.tintColor, for: .normal)
        $0.addTarget(self, action: #selector(actionForColorButton), for: .touchUpInside)
    }
    
    private lazy var showHideButton:UIButton = UIButton(type: .custom).then {
        $0.setTitle("Hide skeleton", for: .normal)
        $0.setTitle("Show skeleton", for: .selected)
        $0.setTitleColor(.blue, for: .normal)
        $0.setTitleColor(.blue, for: .selected)
        $0.addTarget(self, action: #selector(actionForShowHideButton), for: .touchUpInside)
    }
    
    private lazy var durationLabel:UILabel = UILabel().then {
        $0.text = "Fade Duration: 0.25 sec"
    }
    
    private lazy var durationStepper:UIStepper = UIStepper().then {
        $0.value = 0.25
        $0.minimumValue = 0
        $0.maximumValue = 5
        $0.stepValue = 0.25
        $0.addTarget(self, action: #selector(actionForDurationStepper), for: .valueChanged)
    }
    
    private var type: SkeletonType {
        return styleSegment.selectedSegmentIndex == 0 ? .solid : .gradient
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configSkeleton()
    }
    
    override func setupViews() {
        view.zq.addSubViews([headerImageView, desTextView, tableView, styleSegment, animatedLabel, animatedSwitch, colorButton, showHideButton, durationLabel, durationStepper])
        headerImageView.snp.makeConstraints { (m) in
            m.top.equalTo(20)
            m.width.height.equalTo(92)
            m.centerX.equalToSuperview()
        }
        desTextView.snp.makeConstraints { (m) in
            m.top.equalTo(headerImageView.snp.bottom).offset(10)
            m.leading.equalTo(15)
            m.trailing.equalTo(-15)
            m.height.equalTo(60)
        }
        tableView.snp.makeConstraints { (m) in
            m.leading.trailing.equalToSuperview()
            m.top.equalTo(desTextView.snp.bottom).offset(20)
            m.height.equalTo(300)
        }
        styleSegment.snp.makeConstraints { (m) in
            m.leading.equalTo(15)
            m.top.equalTo(tableView.snp.bottom).offset(20)
        }
        animatedSwitch.snp.makeConstraints { (m) in
            m.trailing.equalTo(-15)
            m.centerY.equalTo(styleSegment)
        }
        animatedLabel.snp.makeConstraints { (m) in
            m.trailing.equalTo(animatedSwitch.snp.leading).offset(-5)
            m.centerY.equalTo(animatedSwitch)
        }
        colorButton.snp.makeConstraints { (m) in
            m.top.equalTo(styleSegment.snp.bottom).offset(20)
            m.centerX.equalTo(styleSegment)
        }
        showHideButton.snp.makeConstraints { (m) in
            m.trailing.equalTo(animatedSwitch)
            m.centerY.equalTo(colorButton)
        }
        durationStepper.snp.makeConstraints { (m) in
            m.trailing.equalTo(animatedSwitch)
            m.top.equalTo(showHideButton.snp.bottom).offset(20)
        }
        durationLabel.snp.makeConstraints { (m) in
            m.trailing.equalTo(durationStepper.snp.leading).offset(-5)
            m.centerY.equalTo(durationStepper)
        }
    }
}

// MARK: private
extension ZQSkeletonViewController {
    private func configSkeleton() {
        SkeletonAppearance.default.multilineHeight = 20
        SkeletonAppearance.default.multilineCornerRadius = 8
        SkeletonAppearance.default.multilineLastLineFillPercent = 20
        //        SkeletonAppearance.default.tintColor = .green
        
        view.isSkeletonable = true
        view.showAnimatedSkeleton()
    }
    
    private func refreshSkeleton() {
        type == .gradient ? showOrUpdateGradientSkeleton() : showOrUpdateSolidSkeleton()
    }
    
    private func showOrUpdateSolidSkeleton() {
        animatedSwitch.isOn ? view.updateAnimatedSkeleton(usingColor: colorButton.currentTitleColor) : view.updateSkeleton(usingColor: colorButton.currentTitleColor)
    }
    
    private func showOrUpdateGradientSkeleton() {
        let gradient = SkeletonGradient(baseColor: colorButton.currentTitleColor)
        animatedSwitch.isOn ? view.updateAnimatedGradientSkeleton(usingGradient: gradient) : view.updateGradientSkeleton(usingGradient: gradient)
    }
    
    private func showSkeleton() {
        if type == .gradient {
            let gradient = SkeletonGradient(baseColor: colorButton.currentTitleColor)
            animatedSwitch.isOn ? view.showAnimatedGradientSkeleton(usingGradient: gradient, transition: .crossDissolve(durationStepper.value)) : view.showGradientSkeleton(usingGradient: gradient, transition: .crossDissolve(durationStepper.value))
        }
        else {
            animatedSwitch.isOn ? view.showAnimatedSkeleton(usingColor: colorButton.currentTitleColor, transition: .crossDissolve(durationStepper.value)) : view.showSkeleton(usingColor: colorButton.currentTitleColor, transition: .crossDissolve(durationStepper.value))
        }
    }
    
    private func hideSkeleton() {
        view.hideSkeleton(transition: .crossDissolve(durationStepper.value))
    }
}

// MARK: action
extension ZQSkeletonViewController {
    @objc private func actionForStyleSegment(_ sender:UISegmentedControl) {
        refreshSkeleton()
    }
    
    @objc private func actionForAnimatedSwitch(_ sender:UISwitch) {
        sender.isOn ? view.startSkeletonAnimation() : view.stopSkeletonAnimation()
    }
    
    @objc private func actionForColorButton(_ sender:UIButton) {
        let andom = arc4random()
        let value = andom % 5
        var color:UIColor?
        switch value {
        case 0:
            color = .green
        
        case 1:
            color = .red
            
        case 2:
            color = .purple
            
        case 3:
            color = .brown
            
        case 4:
            color = .yellow
        default: break
        }
        colorButton.setTitleColor(color, for: .normal)
    }
    
    @objc private func actionForShowHideButton(_ sender:UIButton) {
        sender.isSelected = view.isSkeletonActive
        view.isSkeletonActive ? hideSkeleton() : showSkeleton()
    }
    
    @objc private func actionForDurationStepper(_ sender:UIStepper) {
        durationLabel.text = "Transition duration: \(sender.value) sec"
    }
}

// MARK: SkeletonTableViewDataSource
extension ZQSkeletonViewController : SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return NSStringFromClass(ZQSkeletonTableViewCell.self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ZQSkeletonTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ZQSkeletonTableViewCell.self), for: indexPath) as! ZQSkeletonTableViewCell
        cell.desLabel.text = "cell => \(indexPath.row)"
        return cell
    }
}

// MARK: SkeletonTableViewDelegate
extension ZQSkeletonViewController : SkeletonTableViewDelegate {
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        return NSStringFromClass(ZQSkeletonHeaderFooterSection.self)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(ZQSkeletonHeaderFooterSection.self)) as! ZQSkeletonHeaderFooterSection
        header.titleLabel.text = "header => \(section)"
        return header
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForFooterInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        return NSStringFromClass(ZQSkeletonHeaderFooterSection.self)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(ZQSkeletonHeaderFooterSection.self)) as! ZQSkeletonHeaderFooterSection
        footer.titleLabel.text = "footer => \(section)"
        return footer
    }
}





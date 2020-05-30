//
//  ZQSpreadsheetViewCell.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/5/13.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

class ZQSpreadsheetViewHeaderCell: Cell {
    
    let label = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.numberOfLines = 2
    }
    
    let sortArrow = UILabel().then {
        $0.text = ""
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.zq.addSubViews([label, sortArrow])
        label.snp.makeConstraints { (m) in
            m.edges.equalTo(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        }
        sortArrow.snp.makeConstraints { (m) in
            m.trailing.equalToSuperview()
            m.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ZQSpreadsheetViewTextCell: Cell {
    
    let label = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .left
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.2)
        selectedBackgroundView = backgroundView
        contentView.addSubview(label)
        label.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ZQSpreadsheetViewDateCell: Cell {
    let label = UILabel().then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.font = UIFont.boldSystemFont(ofSize: 10)
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = bounds
        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ZQSpreadsheetViewDayTitleCell: Cell {
    let label = UILabel().then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = bounds
        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ZQSpreadsheetViewTimeTitleCell: Cell {
    let label = UILabel().then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = bounds
        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ZQSpreadsheetViewTimeCell: Cell {
    let label = UILabel().then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: UIFont.Weight.medium)
        $0.textAlignment = .right
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = bounds
        contentView.addSubview(label)
    }

    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 6, dy: 0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ZQSpreadsheetViewScheduleCell: Cell {
    let label = UILabel().then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textAlignment = .left
    }
    
    var color: UIColor = .clear {
        didSet {
            backgroundView?.backgroundColor = color
        }
    }

    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 4, dy: 0)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = UIView()
        label.frame = bounds
        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ZQSpreadsheetViewHeaderCell1: Cell {
    let label = UILabel().then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.font = UIFont.boldSystemFont(ofSize: 10)
        $0.textAlignment = .center
        $0.textColor = .gray
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        label.frame = bounds
        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ZQSpreadsheetViewTextCell1: Cell {
    let label = UILabel().then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.font = UIFont.boldSystemFont(ofSize: 10)
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = bounds
        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ZQSpreadsheetViewTaskCell: Cell {
    let label = UILabel().then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.font = UIFont.boldSystemFont(ofSize: 10)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }

    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 2, dy: 2)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = bounds
        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ZQSpreadsheetViewChartBarCell: Cell {
    private let colorBarView = UIView()
    
    let label = UILabel().then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.font = UIFont.boldSystemFont(ofSize: 10)
        $0.textAlignment = .center
        $0.textColor = .white
    }

    var color: UIColor = .clear {
        didSet {
            colorBarView.backgroundColor = color
        }
    }

    override var frame: CGRect {
        didSet {
            colorBarView.frame = bounds.insetBy(dx: 2, dy: 2)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorBarView)
        label.frame = bounds
        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ZQSpreadsheetViewHourCell: Cell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = bounds

        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.backgroundColor = UIColor(red: 0.220, green: 0.471, blue: 0.871, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2

        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ZQSpreadsheetViewChannelCell: Cell {
    let label = UILabel()

    var channel = "" {
        didSet {
            label.text = String(channel)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.backgroundColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 2

        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ZQSpreadsheetViewSlotCell: Cell {
    @IBOutlet private weak var minutesLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableHighlightLabel: UILabel!

    var minutes = 0 {
        didSet {
            minutesLabel.text = String(format: "%02d", minutes)
        }
    }
    
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var tableHighlight = "" {
        didSet {
            tableHighlightLabel.text = tableHighlight
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ZQSpreadsheetViewBlankCell: Cell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.9, alpha: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

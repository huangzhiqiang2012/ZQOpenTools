//
//  ZQSpreadsheetViewController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/5/13.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// SpreadsheetView 控制器
class ZQSpreadsheetViewController: ZQBaseController {

    private let defaultButtonTag = 1000
    
    private let titles = ["Class Data", "Schedule", "GanttChart", "Timetable"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
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
        var vc:ZQBaseController!
        let index = sender.tag - defaultButtonTag
        switch index {
        case 0:
            vc = ZQSpreadsheetViewClassDataController()
            
        case 1:
            vc = ZQSpreadsheetViewScheduleController()
            
        case 2:
            vc = ZQSpreadsheetViewGanttChartController()
            
        case 3:
            vc = ZQSpreadsheetViewTimetableController()
            
        default:
            break
        }
        vc.title = titles[index]
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Base
class ZQSpreadsheetViewBaseController: ZQBaseController {
    
    var spreadsheetView:SpreadsheetView = SpreadsheetView()
    
    override func setupViews() {
        
        /// 父类签协议,子类重写协议方法会有问题,无法显示数据--__--|| 
//        spreadsheetView.dataSource = self
//        spreadsheetView.delegate = self
        view.addSubview(spreadsheetView)
        spreadsheetView.snp.makeConstraints { (m) in
            m.leading.top.trailing.equalToSuperview()
            m.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
//    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat { return 0}
//
//    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow column: Int) -> CGFloat { return 0 }
//
//    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int { return 0 }
//
//    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int { return 0 }
}

// MARK: Class Data
class ZQSpreadsheetViewClassDataController: ZQSpreadsheetViewBaseController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    
    private var header = [String]()
    
    private var data = [[String]]()
    
    private enum Sorting {
        case ascending
        case descending

        var symbol: String {
            switch self {
            case .ascending:
                return "\u{25B2}"
            case .descending:
                return "\u{25BC}"
            }
        }
    }
    private var sortedColumn = (column: 0, sorting: Sorting.ascending)

    override func setupViews() {
        super.setupViews()
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        spreadsheetView.register(ZQSpreadsheetViewHeaderCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZQSpreadsheetViewHeaderCell.self))
        spreadsheetView.register(ZQSpreadsheetViewTextCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZQSpreadsheetViewTextCell.self))
        let data = try! String(contentsOf: Bundle.main.url(forResource: "data", withExtension: "tsv")!, encoding: .utf8)
            .components(separatedBy: "\r\n")
            .map { $0.components(separatedBy: "\t") }
        header = data[0]
        self.data = Array(data.dropFirst())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return header.count
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + data.count
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 140
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow column: Int) -> CGFloat {
        return column == 0 ? 60 : 44
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if indexPath.row == 0 {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZQSpreadsheetViewHeaderCell.self), for: indexPath) as! ZQSpreadsheetViewHeaderCell
            cell.label.text = header[indexPath.column]
            if indexPath.column == sortedColumn.column {
                cell.sortArrow.text = sortedColumn.sorting.symbol
            }
            else {
                cell.sortArrow.text = ""
            }
            return cell
        }
        else {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZQSpreadsheetViewTextCell.self), for: indexPath) as! ZQSpreadsheetViewTextCell
            cell.label.text = data[indexPath.row - 1][indexPath.column]
            return cell
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        if case 0 = indexPath.row {
            if sortedColumn.column == indexPath.column {
                sortedColumn.sorting = sortedColumn.sorting == .ascending ? .descending : .ascending
            } else {
                sortedColumn = (indexPath.column, .ascending)
            }
            data.sort {
                let ascending = $0[sortedColumn.column] < $1[sortedColumn.column]
                return sortedColumn.sorting == .ascending ? ascending : !ascending
            }
            spreadsheetView.reloadData()
        }
    }
}

// MARK: Schedule
class ZQSpreadsheetViewScheduleController: ZQSpreadsheetViewBaseController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    
    private let dates = ["7/10/2017", "7/11/2017", "7/12/2017", "7/13/2017", "7/14/2017", "7/15/2017", "7/16/2017"]
    
    private let days = ["MONDAY", "TUESDAY", "WEDNSDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
    
    private let dayColors = [UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1),
                     UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
                     UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
                     UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1),
                     UIColor(red: 0.400, green: 0.584, blue: 0.141, alpha: 1),
                     UIColor(red: 0.835, green: 0.655, blue: 0.051, alpha: 1),
                     UIColor(red: 0.153, green: 0.569, blue: 0.835, alpha: 1)]
    
    private let hours = ["6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 AM", "1:00 PM", "2:00 PM",
                 "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM"]
    
    private let evenRowColor = UIColor(red: 0.914, green: 0.914, blue: 0.906, alpha: 1)
    
    private let oddRowColor: UIColor = .white
    
    private let data = [
        ["", "", "Take medicine", "", "", "", "", "", "", "", "", "", "", "Movie with family", "", "", "", "", "", ""],
        ["Leave for cabin", "", "", "", "", "Lunch with Tim", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "Downtown parade", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "Fireworks show", "", "", ""],
        ["", "", "", "", "", "Family BBQ", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "Return home", "", "", "", "", "", ""]
    ]

    override func setupViews() {
        super.setupViews()
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        spreadsheetView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        spreadsheetView.intercellSpacing = CGSize(width: 4, height: 1)
        spreadsheetView.gridStyle = .none
        spreadsheetView.register(ZQSpreadsheetViewDateCell.self, forCellWithReuseIdentifier: String(describing: ZQSpreadsheetViewDateCell.self))
        spreadsheetView.register(ZQSpreadsheetViewTimeTitleCell.self, forCellWithReuseIdentifier: String(describing: ZQSpreadsheetViewTimeTitleCell.self))
        spreadsheetView.register(ZQSpreadsheetViewTimeCell.self, forCellWithReuseIdentifier: String(describing: ZQSpreadsheetViewTimeCell.self))
        spreadsheetView.register(ZQSpreadsheetViewDayTitleCell.self, forCellWithReuseIdentifier: String(describing: ZQSpreadsheetViewDayTitleCell.self))
        spreadsheetView.register(ZQSpreadsheetViewScheduleCell.self, forCellWithReuseIdentifier: String(describing: ZQSpreadsheetViewScheduleCell.self))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }

    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + days.count
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + 1 + hours.count
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if column == 0 {
            return 70
        } else {
            return 120
        }
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if row == 0 {
            return 24
        } else if row == 1 {
            return 32
        } else {
            return 40
        }
    }

    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 2
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case (1...(dates.count + 1), 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewDateCell.self), for: indexPath) as! ZQSpreadsheetViewDateCell
            cell.label.text = dates[indexPath.column - 1]
            return cell
        } else if case (1...(days.count + 1), 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewDayTitleCell.self), for: indexPath) as! ZQSpreadsheetViewDayTitleCell
            cell.label.text = days[indexPath.column - 1]
            cell.label.textColor = dayColors[indexPath.column - 1]
            return cell
        } else if case (0, 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewTimeTitleCell.self), for: indexPath) as! ZQSpreadsheetViewTimeTitleCell
            cell.label.text = "TIME"
            return cell
        } else if case (0, 2...(hours.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewTimeCell.self), for: indexPath) as! ZQSpreadsheetViewTimeCell
            cell.label.text = hours[indexPath.row - 2]
            cell.backgroundColor = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
            return cell
        } else if case (1...(days.count + 1), 2...(hours.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewScheduleCell.self), for: indexPath) as! ZQSpreadsheetViewScheduleCell
            let text = data[indexPath.column - 1][indexPath.row - 2]
            if !text.isEmpty {
                cell.label.text = text
                let color = dayColors[indexPath.column - 1]
                cell.label.textColor = color
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
            } else {
                cell.label.text = nil
                cell.color = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
                cell.borders.top = .none
                cell.borders.bottom = .none
            }
            return cell
        }
        return nil
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("--__--|| selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }
}

// MARK: GanttChart
class ZQSpreadsheetViewGanttChartController: ZQSpreadsheetViewBaseController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    private let weeks = ["Week #14", "Week #15", "Week #16", "Week #17", "Week #18", "Week #19", "Week #20"]
    
    private let tasks = [
        ["Office itinerancy", "2", "17", "0"],
        ["Office facing", "2", "8", "0"],
        ["Interior office", "2", "7", "1"],
        ["Air condition check", "3", "7", "1"],
        ["Furniture installation", "11", "8", "1"],
        ["Workplaces preparation", "11", "8", "2"],
        ["The emproyee relocation", "14", "5", "2"],
        ["Preparing workspace", "14", "5", "1"],
        ["Workspaces importation", "14", "4", "1"],
        ["Workspaces exportation", "14", "3", "0"],
        ["Product launch", "2", "13", "0"],
        ["Perforn Initial testing", "3", "5", "0"],
        ["Development", "3", "11", "1"],
        ["Develop System", "3", "2", "1"],
        ["Beta Realese", "6", "2", "1"],
        ["Integrate System", "8", "2", "1"],
        ["Test", "10", "4", "2"],
        ["Promotion", "22", "8", "2"],
        ["Service", "18", "12", "2"],
        ["Marketing", "10", "4", "1"],
        ["The emproyee relocation", "14", "5", "1"],
        ["Land Survey", "4", "8", "1"],
        ["Plan Design", "6", "2", "1"],
        ["Test", "10", "4", "0"],
        ["Determine Cost", "18", "4", "0"],
        ["Review Hardware", "20", "6", "0"],
        ["Engineering", "6", "8", "1"],
        ["Define Concept", "9", "10", "1"],
        ["Compile Report", "14", "10", "1"],
        ["Air condition check", "3", "7", "1"],
        ["Review Data", "16", "20", "2"],
        ["Integrate System", "8", "2", "2"],
        ["Test", "10", "4", "2"],
        ["Determine Cost", "18", "4", "0"],
        ["Review Hardware", "20", "6", "0"],
        ["User Interview", "14", "5", "1"],
        ["Network", "16", "6", "1"],
        ["Software", "8", "8", "1"],
        ["Preparing workspace", "14", "5", "0"],
        ["Workspaces importation", "14", "4", "0"],
        ["Procedure", "10", "4", "0"],
        ["Perforn Initial testing", "3", "5", "0"],
        ["Development", "3", "11", "2"],
        ["Develop System", "3", "2", "2"],
        ["Interior office", "2", "7", "2"],
        ["Air condition check", "3", "7", "1"],
        ["Furniture installation", "11", "8", "1"],
        ["Beta Realese", "6", "2", "0"],
        ["Marketing", "10", "4", "0"],
        ["The emproyee relocation", "14", "5", "0"],
        ["Land Survey", "4", "8", "0"],
        ["Forms", "12", "3", "1"],
        ["Workspaces importation", "14", "4", "1"],
        ["Procedure", "10", "4", "2"],
        ["Perforn Initial testing", "3", "5", "2"],
        ["Development", "3", "11", "2"],
        ["Website", "14", "6", "2"],
        ["Assemble", "3", "4", "0"],
        ["Air condition check", "3", "7", "0"],
        ["Furniture installation", "11", "8", "0"],
        ["Workplaces preparation", "11", "8", "1"],
        ["Sales", "5", "6", "1"],
        ["Unit Test", "7", "8", "2"],
        ["Integration Test", "20", "10", "2"],
        ["Service", "18", "12", "2"],
        ["Promotion", "22", "8", "1"],
        ["Air condition check", "3", "7", "1"],
        ["Furniture installation", "11", "8", "1"]
    ]
    
    private let colors = [UIColor(red: 0.314, green: 0.698, blue: 0.337, alpha: 1),
                  UIColor(red: 1.000, green: 0.718, blue: 0.298, alpha: 1),
                  UIColor(red: 0.180, green: 0.671, blue: 0.796, alpha: 1)]
    
    override func setupViews() {
        super.setupViews()
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        let hairline = 1 / UIScreen.main.scale
        spreadsheetView.intercellSpacing = CGSize(width: hairline, height: hairline)
        spreadsheetView.gridStyle = .solid(width: hairline, color: .lightGray)
        spreadsheetView.register(ZQSpreadsheetViewHeaderCell1.self, forCellWithReuseIdentifier: String(describing: ZQSpreadsheetViewHeaderCell1.self))
        spreadsheetView.register(ZQSpreadsheetViewTextCell1.self, forCellWithReuseIdentifier: String(describing: ZQSpreadsheetViewTextCell1.self))
        spreadsheetView.register(ZQSpreadsheetViewTaskCell.self, forCellWithReuseIdentifier: String(describing: ZQSpreadsheetViewTaskCell.self))
        spreadsheetView.register(ZQSpreadsheetViewChartBarCell.self, forCellWithReuseIdentifier: String(describing: ZQSpreadsheetViewChartBarCell.self))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }

    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 3 + 7 * weeks.count
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 2 + tasks.count
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if case 0 = column {
            return 90
        } else if case 1...2 = column {
            return 50
        } else {
            return 50
        }
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0...1 = row {
            return 28
        } else {
            return 34
        }
    }

    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 3
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 2
    }

    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        let titleHeader = [CellRange(from: (0, 0), to: (1, 0)),
                           CellRange(from: (0, 1), to: (1, 1)),
                           CellRange(from: (0, 2), to: (1, 2))]
        let weakHeader = weeks.enumerated().map { (index, _) -> CellRange in
            return CellRange(from: (0, index * 7 + 3), to: (0, index * 7 + 9))
        }
        let charts = tasks.enumerated().map { (index, task) -> CellRange in
            let start = Int(task[1])!
            let end = Int(task[2])!
            return CellRange(from: (index + 2, start + 2), to: (index + 2, start + end + 2))
        }
        return titleHeader + weakHeader + charts
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        switch (indexPath.column, indexPath.row) {
        case (0, 0):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewHeaderCell1.self), for: indexPath) as! ZQSpreadsheetViewHeaderCell1
            cell.label.text = "Task"
            cell.gridlines.left = .default
            cell.gridlines.right = .none
            return cell
        case (1, 0):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewHeaderCell1.self), for: indexPath) as! ZQSpreadsheetViewHeaderCell1
            cell.label.text = "Start"
            cell.gridlines.left = .solid(width: 1 / UIScreen.main.scale, color: cell.backgroundColor!)
            cell.gridlines.right = cell.gridlines.left
            return cell
        case (2, 0):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewHeaderCell1.self), for: indexPath) as! ZQSpreadsheetViewHeaderCell1
            cell.label.text = "Duration"
            cell.label.textColor = .gray
            cell.gridlines.left = .none
            cell.gridlines.right = .default
            return cell
        case (3..<(3 + 7 * weeks.count), 0):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewHeaderCell1.self), for: indexPath) as! ZQSpreadsheetViewHeaderCell1
            cell.label.text = weeks[(indexPath.column - 3) / 7]
            cell.gridlines.left = .default
            cell.gridlines.right = .default
            return cell
        case (3..<(3 + 7 * weeks.count), 1):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewHeaderCell1.self), for: indexPath) as! ZQSpreadsheetViewHeaderCell1
            cell.label.text = String(format: "%02d Apr", indexPath.column - 2)
            cell.gridlines.left = .default
            cell.gridlines.right = .default
            return cell
        case (0, 2..<(2 + tasks.count)):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewTaskCell.self), for: indexPath) as! ZQSpreadsheetViewTaskCell
            cell.label.text = tasks[indexPath.row - 2][0]
            cell.gridlines.left = .default
            cell.gridlines.right = .none
            return cell
        case (1, 2..<(2 + tasks.count)):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewTextCell1.self), for: indexPath) as! ZQSpreadsheetViewTextCell1
            cell.label.text = String(format: "April %02d", Int(tasks[indexPath.row - 2][1])!)
            cell.gridlines.left = .none
            cell.gridlines.right = .none
            return cell
        case (2, 2..<(2 + tasks.count)):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewTextCell1.self), for: indexPath) as! ZQSpreadsheetViewTextCell1
            cell.label.text = tasks[indexPath.row - 2][2]
            cell.gridlines.left = .none
            cell.gridlines.right = .none
            return cell
        case (3..<(3 + 7 * weeks.count), 2..<(2 + tasks.count)):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewChartBarCell.self), for: indexPath) as! ZQSpreadsheetViewChartBarCell
            let start = Int(tasks[indexPath.row - 2][1])!
            if start == indexPath.column - 2 {
                cell.label.text = tasks[indexPath.row - 2][0]
                let colorIndex = Int(tasks[indexPath.row - 2][3])!
                cell.color = colors[colorIndex]
            } else {
                cell.label.text = ""
                cell.color = .clear
            }
            return cell
        default:
            return nil
        }
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("--__--|| selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }

}

// MARK: Timetable
class ZQSpreadsheetViewTimetableController: ZQSpreadsheetViewBaseController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    
    private let channels = [
        "ABC", "NNN", "BBC", "J-Sports", "OK News", "SSS", "Apple", "CUK", "KKR", "APAR",
        "SU", "CCC", "Game", "Anime", "Tokyo NX", "NYC", "SAN", "Drama", "Hobby", "Music"]

    private let numberOfRows = 24 * 60 + 1
    
    private var slotInfo = [IndexPath: (Int, Int)]()

    private let hourFormatter = DateFormatter()
    
    private let twelveHourFormatter = DateFormatter()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func setupViews() {
        super.setupViews()
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        spreadsheetView.register(ZQSpreadsheetViewHourCell.self, forCellWithReuseIdentifier: String(describing: ZQSpreadsheetViewHourCell.self))
        spreadsheetView.register(ZQSpreadsheetViewChannelCell.self, forCellWithReuseIdentifier: String(describing: ZQSpreadsheetViewChannelCell.self))
        spreadsheetView.register(UINib(nibName: String(describing: ZQSpreadsheetViewSlotCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ZQSpreadsheetViewSlotCell.self))
        spreadsheetView.register(ZQSpreadsheetViewBlankCell.self, forCellWithReuseIdentifier: String(describing: ZQSpreadsheetViewBlankCell.self))
        spreadsheetView.backgroundColor = .black
        let hairline = 1 / UIScreen.main.scale
        spreadsheetView.intercellSpacing = CGSize(width: hairline, height: hairline)
        spreadsheetView.gridStyle = .solid(width: hairline, color: .lightGray)
        spreadsheetView.circularScrolling = CircularScrolling.Configuration.horizontally.rowHeaderStartsFirstColumn
        hourFormatter.calendar = Calendar(identifier: .gregorian)
        hourFormatter.locale = Locale(identifier: "en_US_POSIX")
        hourFormatter.dateFormat = "h\na"
        twelveHourFormatter.calendar = Calendar(identifier: .gregorian)
        twelveHourFormatter.locale = Locale(identifier: "en_US_POSIX")
        twelveHourFormatter.dateFormat = "H"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }

    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return channels.count + 1
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return numberOfRows
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if column == 0 {
            return 30
        }
        return 130
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if row == 0 {
            return 44
        }
        return 2
    }

    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }

    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        var mergedCells = [CellRange]()

        for row in 0..<24 {
            mergedCells.append(CellRange(from: (60 * row + 1, 0), to: (60 * (row + 1), 0)))
        }

        let seeds = [5, 10, 20, 20, 30, 30, 30, 30, 40, 40, 50, 50, 60, 60, 60, 60, 90, 90, 90, 90, 120, 120, 120]
        for (index, _) in channels.enumerated() {
            var minutes = 0
            while minutes < 24 * 60 {
                let duration = seeds[Int(arc4random_uniform(UInt32(seeds.count)))]
                guard minutes + duration + 1 < numberOfRows else {
                    mergedCells.append(CellRange(from: (minutes + 1, index + 1), to: (numberOfRows - 1, index + 1)))
                    break
                }
                let cellRange = CellRange(from: (minutes + 1, index + 1), to: (minutes + duration + 1, index + 1))
                mergedCells.append(cellRange)
                slotInfo[IndexPath(row: cellRange.from.row, column: cellRange.from.column)] = (minutes, duration)
                minutes += duration + 1
            }
        }
        return mergedCells
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if indexPath.column == 0 && indexPath.row == 0 {
            return nil
        }

        if indexPath.column == 0 && indexPath.row > 0 {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewHourCell.self), for: indexPath) as! ZQSpreadsheetViewHourCell
            cell.label.text = hourFormatter.string(from: twelveHourFormatter.date(from: "\((indexPath.row - 1) / 60 % 24)")!)
            cell.gridlines.top = .solid(width: 1, color: .white)
            cell.gridlines.bottom = .solid(width: 1, color: .white)
            return cell
        }
        if indexPath.column > 0 && indexPath.row == 0 {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewChannelCell.self), for: indexPath) as! ZQSpreadsheetViewChannelCell
            cell.label.text = channels[indexPath.column - 1]
            cell.gridlines.top = .solid(width: 1, color: .black)
            cell.gridlines.bottom = .solid(width: 1, color: .black)
            cell.gridlines.left = .solid(width: 1 / UIScreen.main.scale, color: UIColor(white: 0.3, alpha: 1))
            cell.gridlines.right = cell.gridlines.left
            return cell
        }

        if let (minutes, duration) = slotInfo[indexPath] {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewSlotCell.self), for: indexPath) as! ZQSpreadsheetViewSlotCell
            cell.minutes = minutes % 60
            cell.title = "Dummy Text"
            cell.tableHighlight = duration > 20 ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit" : ""
            return cell
        }
        return spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ZQSpreadsheetViewBlankCell.self), for: indexPath)
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("--__--|| selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }

}



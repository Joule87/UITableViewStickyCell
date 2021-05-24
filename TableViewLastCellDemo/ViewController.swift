//
//  ViewController.swift
//  TableViewLastCellDemo
//
//  Created by Julio Collado on 5/20/21.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
            tableView.allowsSelection = false
        }
    }
    
    //MARK: - Properties
    private let cellId = "commonCell"
    private var items: [NiceItem] = [.firstCell, .secondCell, .lastCell]
    private var currentLastCellHeight: CGFloat?
    private let lastCellHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func didTapAddItem(_ sender: UIBarButtonItem) {
        guard let newCell = NiceItem(rawValue: Int.random(in: 0...3)) else { return }
        items.insert(newCell, at: 0)
        tableView.reloadData()
    }
    
    @IBAction func didTapRemoveItem(_ sender: UIBarButtonItem) {
        guard items.count > 3 else { return }
        items.remove(at: 0)
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ?? UITableViewCell()
        let item = items[indexPath.row]
        cell.textLabel?.text = item.content
        cell.backgroundColor = item.color
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.row]
        switch item {
        case .firstCell:
            return UITableView.automaticDimension
        case .secondCell:
            return 200
        case .thirdCell:
            return 90
        case .fourthCell:
            return UITableView.automaticDimension
        case .lastCell:
            let height = currentLastCellHeight ?? lastCellHeight
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        switch item {
        case .lastCell:
            guard let lastCellHeight = tableView.getStickyCellHeight(for: indexPath, emptySpaceSize: currentLastCellHeight, fixedLastCellHeight: lastCellHeight) else {
                return
            }
            self.currentLastCellHeight = lastCellHeight
            tableView.reloadData()
        default:
            break
        }
    }
    
}

extension UITableView {
    ///If returns nil cell already have the right size.
    func getStickyCellHeight(for indexPath: IndexPath, emptySpaceSize: CGFloat?, fixedLastCellHeight: CGFloat) -> CGFloat? {
        var newHeight: CGFloat?
        let sectionHeight = self.rect(forSection: indexPath.section).height
        
        ///Last cell is not visible but is about to appear because some data was removed
        if let leftSpace = emptySpaceSize, sectionHeight < self.frame.height {
            let recalculatedCellHeight = (self.frame.height - (sectionHeight - leftSpace))
            newHeight = recalculatedCellHeight < fixedLastCellHeight ? fixedLastCellHeight : recalculatedCellHeight
            return newHeight
        }
        
        guard emptySpaceSize != fixedLastCellHeight else {
            ///Last cell does not need to be recalculated if last cell is partial visible/ Have the size right at the end of the table.  So it will have a default value (fixedLastCellHeight)
            return newHeight
        }
        
        let newLastCellHeight = (self.frame.height - sectionHeight) + fixedLastCellHeight
        ///Sets initial las cell height
        if emptySpaceSize == nil, newLastCellHeight >= 0 {
            newHeight = newLastCellHeight
            return newHeight
        }
        
        guard let emptySpaceSize = emptySpaceSize else {
            return  nil
        }
        let isLastCellHidden = (sectionHeight - emptySpaceSize) >= self.frame.height
        ///Sets the default height if last cell is not visible
        if isLastCellHidden {
            newHeight = fixedLastCellHeight
            return newHeight
        }
        
        let contentWithoutLastCell = sectionHeight - emptySpaceSize
        let recalculatedCellHeight = (self.frame.height - contentWithoutLastCell)
        let isReCalculatedCell = recalculatedCellHeight == emptySpaceSize
        let shouldReCalculateLastCellHeight = !isLastCellHidden && !isReCalculatedCell
        ///Controls if last cell should recalculate it's size
        if shouldReCalculateLastCellHeight {
            newHeight = recalculatedCellHeight >= fixedLastCellHeight ? recalculatedCellHeight : fixedLastCellHeight
            return newHeight
        }
        return newHeight
    }
}

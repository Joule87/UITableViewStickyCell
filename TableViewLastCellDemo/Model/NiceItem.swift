//
//  NiceItem.swift
//  TableViewLastCellDemo
//
//  Created by Julio Collado on 5/23/21.
//

import UIKit

enum NiceItem: Int {
    case firstCell
    case secondCell
    case thirdCell
    case fourthCell
    case lastCell
    
    var content: String {
        switch self {
        case .firstCell:
            return "Nice YELLOW right"
        case .secondCell:
            return "MAGENTA is so cool"
        case .thirdCell:
            return "GREEN like grass"
        case .fourthCell:
            return "BROW makes me think on wine"
        case .lastCell:
            return "last ORANGE resizable cell"
        }
    }
    
    var color: UIColor {
        switch self {
        case .firstCell:
            return .yellow
        case .secondCell:
            return .magenta
        case .thirdCell:
            return .green
        case .fourthCell:
            return .brown
        case .lastCell:
            return .orange
        }
    }
}

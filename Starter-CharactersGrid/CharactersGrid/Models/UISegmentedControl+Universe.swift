//
//  UISegmentedControl+Universe.swift
//  CharactersGrid
//
//  Created by Alfian Losari on 9/22/20.
//

import UIKit

extension UISegmentedControl {
    var selectedUniverse: Universe {
        switch self.selectedSegmentIndex {
        case 0: return .ff7r
        case 1: return .marvel
        case 2: return .dc
        default: return .starwars
        }
    }
}

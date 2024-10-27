//
//  ExpandableOptions.swift
//  MovieDB
//
//  Created by Ritika Gupta on 27/10/24.
//

import Foundation
class ExpandableOption {
    var title: String
    var subOptions: [ExpandableSubOption]
    var isExpanded: Bool = false
    
    init(title: String, subOptions: [ExpandableSubOption], isExpanded: Bool = false) {
        self.title = title
        self.subOptions = subOptions
        self.isExpanded = isExpanded
    }
}


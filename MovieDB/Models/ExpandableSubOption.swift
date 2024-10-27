//
//  ExpandableSubOption.swift
//  MovieDB
//
//  Created by Ritika Gupta on 27/10/24.
//

import Foundation
class ExpandableSubOption {
    var title: String
    var movieOptions: [Movie]
    var isExpanded: Bool = false
    
    init(title: String, options: [Movie], isExpanded: Bool = false) {
        self.title = title
        self.movieOptions = options
        self.isExpanded = isExpanded
    }
}

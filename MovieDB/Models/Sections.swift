//
//  Sections.swift
//  MovieDB
//
//  Created by Ritika Gupta on 26/10/24.
//

import Foundation
enum Sections: Int, CaseIterable {
    case year
    case genre
    case director
    case actor
    case allMovies
    
    var title: String {
        switch self {
        case .year:
            "Year"
        case .genre:
            "Genre"
        case .director:
            "Directors"
        case .actor:
            "Actors"
        case .allMovies:
            "All Movies"
        }
    }
}

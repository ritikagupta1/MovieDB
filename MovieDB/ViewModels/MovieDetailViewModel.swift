//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by Ritika Gupta on 27/10/24.
//

import UIKit
class MovieDetailViewModel {
    private let movie: Movie
    
    // Published properties that the view controller will observe
    var title: String { movie.title }
    var releaseDate: String { movie.released }
    var genres: String { movie.genre }
    var plot: String { movie.plot }
    var cast: String { movie.actors }
    var directors: String { movie.director }
    var posterURL: String { movie.poster }
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func getRatingViews() -> [RatingDetails] {
        return movie.ratings.map { rating in
            let percentage = convertRatingToPercentage(rating.value)
            return RatingDetails(title: rating.source, percentage: percentage)
        }
    }
    
    private func convertRatingToPercentage(_ ratingString: String) -> Double {
        if ratingString.contains("/") {
            let components = ratingString.split(separator: "/")
            if let rating = Double(components[0]),
               let total = Double(components[1]) {
                return (rating / total) * 100
            }
        } else if ratingString.hasSuffix("%") {
            let numberString = ratingString.dropLast()
            if let percentage = Double(numberString) {
                return percentage
            }
        }
        return 0.0
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        NetworkManager.shared.downloadImage(from: posterURL) { image in
            DispatchQueue.main.async {
                completion(image ?? .placeholder)
            }
        }
    }
}

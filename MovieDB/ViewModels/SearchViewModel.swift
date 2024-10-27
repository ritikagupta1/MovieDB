//
//  SearchViewModel.swift
//  MovieDB
//
//  Created by Ritika Gupta on 27/10/24.
//

import Foundation
protocol SearchViewModelDelegate: AnyObject {
    func moviesDidFetch()
    func didUpdateSection(_ section: Int)
}

protocol SearchViewModelProtocol: AnyObject {
    var movies: [Movie]? { get }
    var sections: [ExpandableOption] { get }
    var delegate: SearchViewModelDelegate? { get set }
    var searchResults: [Movie] { get}
    var isSearchActive: Bool { get }
    
    func loadMovies()
    func toggleSectionExpansion(at index: Int)
    func toggleOptionExpansion(sectionIndex: Int, optionIndex: Int)
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func updateSearchResults(with query: String)
}

class SearchViewModel: SearchViewModelProtocol {
    private(set) var movies: [Movie]?
    private(set) var sections: [ExpandableOption] = []
    private var yearMovies: [String: [Movie]] = [:]
    private var genreMovies: [String: [Movie]] = [:]
    private var directorMovies: [String: [Movie]] = [:]
    private var actorsMovies: [String: [Movie]] = [:]
    
    private(set) var isSearchActive: Bool = false
    private(set) var searchResults: [Movie] = []
    
    weak var delegate: SearchViewModelDelegate?
    
    func updateSearchResults(with query: String) {
        isSearchActive = !query.isEmpty
        if isSearchActive {
            searchResults = (movies ?? []).filter { movie in
                movie.title.lowercased().contains(query.lowercased()) ||
                movie.genreCollection.contains{ $0.lowercased().contains(query.lowercased()) } ||
                movie.actorCollection.contains { $0.lowercased().contains(query.lowercased()) } ||
                movie.directorCollection.contains { $0.lowercased().contains(query.lowercased()) }
            }
        } else {
            searchResults = []
        }
    }
    
    
    func loadMovies() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let movies = FileCacheManager.shared.getFromFileCache() {
                self?.handleMoviesLoaded(movies)
            } else {
                self?.loadMoviesFromJSON()
            }
        }
    }
    
    private func handleMoviesLoaded(_ movies: [Movie]) {
        DispatchQueue.main.async { [weak self] in
            self?.movies = movies
            self?.groupMovies()
            self?.configureDataSource()
        }
    }
    
    private func loadMoviesFromJSON() {
        guard let fileURL = Bundle.main.url(forResource: "movies", withExtension: "json"),
              let data = try? Data(contentsOf: fileURL) else {
            return
        }
        
        do {
            let moviesData = try JSONDecoder().decode([Movie].self, from: data)
            handleMoviesLoaded(moviesData)
            FileCacheManager.shared.setInToFileCache(movies: moviesData)
        } catch {
            print("Error decoding movies: \(error)")
        }
    }
    
    private func groupMovies() {
        guard let movies = self.movies else {
            print("Movies not present")
            return
        }
        
        // group based on year
        yearMovies = Dictionary(grouping: movies, by: { $0.year })
        
        // group based on genre
        movies.forEach({ movie in
            for genre in movie.genreCollection {
                if var existingMoviesForGenre = genreMovies[genre.trimmingCharacters(in: .whitespacesAndNewlines)] {
                    existingMoviesForGenre.append(movie)
                    genreMovies[genre.trimmingCharacters(in: .whitespacesAndNewlines)] = existingMoviesForGenre
                } else {
                    genreMovies[genre.trimmingCharacters(in: .whitespacesAndNewlines)] = [movie]
                }
            }
        })
        
        
        // group based on actors
        movies.forEach({ movie in
            for actor in movie.actorCollection {
                if var existingMoviesForActor = actorsMovies[actor] {
                    existingMoviesForActor.append(movie)
                    actorsMovies[actor] = existingMoviesForActor
                } else {
                    actorsMovies[actor] = [movie]
                }
            }
        })
        
        // group based on director
        movies.forEach({ movie in
            for director in movie.directorCollection {
                if var existingMoviesForDirector = directorMovies[director] {
                    existingMoviesForDirector.append(movie)
                    directorMovies[director] = existingMoviesForDirector
                } else {
                    directorMovies[director] = [movie]
                }
            }
        })
    }
    
    
    private func configureDataSource() {
        self.sections = Sections.allCases.map { section in
            var options: [ExpandableSubOption] = []
            switch section {
            case .year:
                options = self.yearMovies.map({ ExpandableSubOption(title: $0.key, options: $0.value) }).sorted(by: { $0.title < $1.title })
            case .genre:
                options = self.genreMovies.map({ ExpandableSubOption(title: $0.key, options: $0.value) }).sorted(by: { $0.title < $1.title })
            case .director:
                options = self.directorMovies.map({ ExpandableSubOption(title: $0.key, options: $0.value) }).sorted(by: { $0.title < $1.title })
            case .actor:
                options = self.actorsMovies.map({ ExpandableSubOption(title: $0.key, options: $0.value) }).sorted(by: { $0.title < $1.title })
            case .allMovies:
                break
            }
            return ExpandableOption(title: section.title, subOptions: options) }
        delegate?.moviesDidFetch()
    }
    
    func toggleSectionExpansion(at index: Int) {
        sections[index].isExpanded.toggle()
        delegate?.didUpdateSection(index)
    }
    
    func toggleOptionExpansion(sectionIndex: Int, optionIndex: Int) {
        sections[sectionIndex].subOptions[optionIndex].isExpanded.toggle()
        delegate?.didUpdateSection(sectionIndex)
    }
    
    func numberOfSections() -> Int {
        if isSearchActive {
            return 1
        }
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        if isSearchActive {
            return searchResults.count
        }
        
        guard !sections.isEmpty else { return 0 }
        let currentSection = sections[section]
        
        if section == Sections.allMovies.rawValue {
            return currentSection.isExpanded ? 2 : 1
        }
        
        if !currentSection.isExpanded {
            return 1
        }
        
        return 1 + currentSection.subOptions.reduce(0) { count, option in
            count + 1 + (option.isExpanded ? 1 : 0)
        }
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        if isSearchActive {
            return 180
        }
        
        let section = sections[indexPath.section]
        
        if indexPath.row == 0 {
            return 44
        }
        
        if indexPath.section == Sections.allMovies.rawValue && section.isExpanded && indexPath.row == 1 {
            return 200
        }
        
        if section.isExpanded {
            var currentRow = 1
            for option in section.subOptions {
                if currentRow == indexPath.row {
                    return 44
                }
                currentRow += 1
                if option.isExpanded {
                    if currentRow == indexPath.row {
                        return 200
                    }
                    currentRow += 1
                }
            }
        }
        
        return 44
    }
}

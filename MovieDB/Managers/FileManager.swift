//
//  FileManager.swift
//  MovieDB
//
//  Created by Ritika Gupta on 26/10/24.
//

import Foundation
final class FileCacheManager {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let fileURL: URL
    
    static let shared = FileCacheManager()
    
    private init() {
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        cacheDirectory = urls[0].appendingPathComponent("MovieDataCache")
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory,
                                             withIntermediateDirectories: true)
        }
        fileURL = cacheDirectory.appendingPathComponent("movies.json")
    }
    
    func setInToFileCache(movies: [Movie]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(movies)
            try data.write(to: fileURL, options: .atomicWrite)
        } catch {
            print("Error persisting cache: \(error.localizedDescription)")
        }
    }
    
    func getFromFileCache() -> [Movie]? {
        guard let data = try? Data(contentsOf: fileURL),
              let decodedData = try? JSONDecoder().decode([Movie].self, from: data) else {
            return nil
        }
        
        return decodedData
    }
}

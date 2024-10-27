//
//  ViewController.swift
//  MovieDB
//
//  Created by Ritika Gupta on 26/10/24.
//

import UIKit
class SearchViewController: UIViewController, UISearchBarDelegate {
    func moviesFetched() {
        self.tableView.reloadData()
    }
    
    private let viewModel: SearchViewModelProtocol
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OptionCell.self, forCellReuseIdentifier: OptionCell.identifier)
        tableView.register(MovieCollectionTableCell.self, forCellReuseIdentifier: MovieCollectionTableCell.identifier)
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        return tableView
    }()
    
    init(viewModel: SearchViewModelProtocol = SearchViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.searchTitle
        self.view.backgroundColor = .systemBackground
        (viewModel as? SearchViewModel)?.delegate = self
        viewModel.loadMovies()
        configureSearchController()
        configureTableView()
    }
    
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = Constants.searchBarPlaceHolder
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    func configureTableView() {
        self.view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        viewModel.updateSearchResults(with: query)
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isSearchActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as? SearchResultCell
            let movie = viewModel.searchResults[indexPath.row]
            cell?.configure(with: movie)
            return cell ?? UITableViewCell()
        }
        
        let section = viewModel.sections[indexPath.section]
        
        if indexPath.section == Sections.allMovies.rawValue {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.identifier, for: indexPath) as? OptionCell
                cell?.configure(title: section.title, isExpanded: section.isExpanded, indentationLevel: 0)
                return cell ?? UITableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MovieCollectionTableCell.identifier, for: indexPath) as? MovieCollectionTableCell
                cell?.delegate = self
                cell?.configure(with: viewModel.movies ?? [])
                return cell ?? UITableViewCell()
            }
        }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.identifier, for: indexPath) as? OptionCell
            cell?.configure(title: section.title, isExpanded: section.isExpanded, indentationLevel: 0)
            return cell ?? UITableViewCell()
        }
        
        var currentRow = 1
        for option in section.subOptions {
            if currentRow == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.identifier, for: indexPath) as? OptionCell
                cell?.configure(title: option.title, isExpanded: option.isExpanded, indentationLevel: 1)
                return cell ?? UITableViewCell()
            }
            
            currentRow += 1
            
            if option.isExpanded {
                if indexPath.row == currentRow {
                    let cell = tableView.dequeueReusableCell(withIdentifier: MovieCollectionTableCell.identifier, for: indexPath) as? MovieCollectionTableCell
                    cell?.delegate = self
                    cell?.configure(with: option.movieOptions)
                    return cell ?? UITableViewCell()
                }
            }
            
            if option.isExpanded {
                currentRow += 1
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isSearchActive {
            let movie = viewModel.searchResults[indexPath.row]
            let detailVC = MovieDetailViewController(movie: movie)
            self.navigationController?.pushViewController(detailVC, animated: true)
            return
        }
        if indexPath.row == 0 {
            viewModel.sections[indexPath.section].isExpanded.toggle()
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            return
        }
        
        var currentRow = 1
        for (optionIndex, option) in viewModel.sections[indexPath.section].subOptions.enumerated() {
            if currentRow == indexPath.row {
                viewModel.sections[indexPath.section].subOptions[optionIndex].isExpanded.toggle()
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                return
            }
            currentRow += 1 + (option.isExpanded ? 1 : 0)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRow(at: indexPath)
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func moviesDidFetch() {
        tableView.reloadData()
    }
    
    func didUpdateSection(_ section: Int) {
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

extension SearchViewController: MovieCollectionTableCellDelegate {
    func didSelectMovie(movie: Movie) {
        let detailVC = MovieDetailViewController(movie: movie)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Ritika Gupta on 27/10/24.
//

import UIKit
class MovieDetailViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray6
        imageView.image = .placeholder
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let releaseDateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Release Date"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let genresTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Genres"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let plotTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Plot"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let plotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let castTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cast"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let castLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let directorsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Directors"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let directorsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateTitleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(genresTitleLabel)
        contentView.addSubview(genresLabel)
        contentView.addSubview(plotTitleLabel)
        contentView.addSubview(plotLabel)
        contentView.addSubview(castTitleLabel)
        contentView.addSubview(castLabel)
        contentView.addSubview(directorsTitleLabel)
        contentView.addSubview(directorsLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Poster Image
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 240),
            posterImageView.heightAnchor.constraint(equalToConstant: 300),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Release Date Title
            releaseDateTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            releaseDateTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            releaseDateTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Release Date
            releaseDateLabel.topAnchor.constraint(equalTo: releaseDateTitleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Genres Title
            genresTitleLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 24),
            genresTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genresTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Genres
            genresLabel.topAnchor.constraint(equalTo: genresTitleLabel.bottomAnchor, constant: 8),
            genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Plot Title
            plotTitleLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 24),
            plotTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            plotTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Plot
            plotLabel.topAnchor.constraint(equalTo: plotTitleLabel.bottomAnchor, constant: 8),
            plotLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            plotLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Cast Title
            castTitleLabel.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: 24),
            castTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            castTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Cast
            castLabel.topAnchor.constraint(equalTo: castTitleLabel.bottomAnchor, constant: 8),
            castLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            castLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Directors Title
            directorsTitleLabel.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 24),
            directorsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            directorsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Directors
            directorsLabel.topAnchor.constraint(equalTo: directorsTitleLabel.bottomAnchor, constant: 8),
            directorsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            directorsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            directorsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureUI() {
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.released
        genresLabel.text = movie.genre
        plotLabel.text = movie.plot
        castLabel.text = movie.actors
        directorsLabel.text = movie.director
        loadImage(from: movie.poster)
    }
    
    private func loadImage(from urlString: String) {
        NetworkManager.shared.downloadImage(from: movie.poster) { [weak self] image in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
                self.posterImageView.image = image ?? .placeholder
            }
        }
    }
}

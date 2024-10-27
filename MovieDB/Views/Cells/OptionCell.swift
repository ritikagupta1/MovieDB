//
//  TitleCell.swift
//  MovieDB
//
//  Created by Ritika Gupta on 27/10/24.
//

import UIKit

class OptionCell: UITableViewCell {
    static let identifier = "OptionCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(title: String, isExpanded: Bool, indentationLevel: Int = 0) {
        titleLabel.text = title
        
        titleLabel.font = indentationLevel == 0 ?
            .boldSystemFont(ofSize: 16) :
            .systemFont(ofSize: 15)
        
        backgroundColor = indentationLevel == 0 ?
            .systemBackground :
            .systemGray6
        
        self.indentationLevel = indentationLevel
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.tintColor = .darkGray
        imageView.image = isExpanded ? UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysOriginal) : UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysOriginal)
        accessoryView = imageView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        indentationLevel = 0
    }
}

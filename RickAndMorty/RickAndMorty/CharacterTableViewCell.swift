//
//  CharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by Sharun Garg on 2022-04-27.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    static let identifier = "CharacterTableViewCell"
    private static let defaultImage = UIImage(systemName: "person.fill")!
    
    private let characterImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.image = defaultImage
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    private var imageViewConstraints: [NSLayoutConstraint] {
        var constrainsts: [NSLayoutConstraint] = []
        
        let padding:CGFloat = 5
        let imageSize = contentView.frame.height - (padding * 3)
        let height = characterImageView.heightAnchor.constraint(equalToConstant: imageSize)
        let width = characterImageView.widthAnchor.constraint(equalToConstant: imageSize)
        let leading = characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding)
        let centerY = characterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        constrainsts.append(contentsOf: [height, width, leading, centerY])
        return constrainsts
    }
    
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let episodesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()

    private let labelsStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.alignment = .leading
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 5
        return view
    }()
    
    private var labelsStackViewConstraints: [NSLayoutConstraint] {
        var constrainsts: [NSLayoutConstraint] = []
        let leading = labelsStackView.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10)
        let trailing = labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -10)
        let top = labelsStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10)
        let bottom = labelsStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        let centerY = labelsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        constrainsts.append(contentsOf: [top, leading, bottom, trailing, centerY])
        return constrainsts
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(characterImageView)
        
        labelsStackView.addArrangedSubview(characterNameLabel)
        labelsStackView.addArrangedSubview(episodesLabel)
        contentView.addSubview(labelsStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate(self.imageViewConstraints)
        NSLayoutConstraint.activate(self.labelsStackViewConstraints)
    }
    
    func configure(for char: Character) {
        characterImageView.image = CharacterTableViewCell.defaultImage
        characterNameLabel.text = char.name
        episodesLabel.text = "Number of episodes: \(char.episode.count)"
        setCharacterImage(imageURL: char.image)
    }
    
    private func setCharacterImage(imageURL: String) {
        ImageHandler.shared.getImage(forURL: imageURL) { [weak self] image in
            guard let charImage = image else { return }
            
            DispatchQueue.main.async { 
                self?.characterImageView.image = charImage
            }
        }
    }
    
    override func prepareForReuse() {
        characterImageView.image = nil
        characterNameLabel.text = nil
        episodesLabel.text = nil
    }
}

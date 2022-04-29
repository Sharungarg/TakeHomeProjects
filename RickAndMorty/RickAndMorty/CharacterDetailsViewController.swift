//
//  CharacterDetailsViewController.swift
//  RickAndMorty
//
//  Created by Sharun Garg on 2022-04-28.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    private let char: Character
    
    private let charImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let nameLabel = labelGenerator()
    private let statusLabel = labelGenerator()
    private let speciesLabel = labelGenerator()
    private let genderLabel = labelGenerator()
    private let locationLabel = labelGenerator()
    
    private let labelsStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .leading
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    private var stackViewContraints: [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let padding: CGFloat = 30
        let top = labelsStackView.topAnchor.constraint(equalTo: charImageView.bottomAnchor, constant: padding)
        let leading = labelsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding)
        let trailing = labelsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
        let bottom = labelsStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        constraints.append(contentsOf: [top, leading, bottom, trailing])
        return constraints
    }
    
    private var charImageViewContraints: [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let imageSize = view.bounds.width - 40
        
        let height = charImageView.heightAnchor.constraint(equalToConstant: imageSize)
        let width = charImageView.widthAnchor.constraint(equalToConstant: imageSize)
        let centerX = charImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        let top = charImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        constraints.append(contentsOf: [height, width, top, centerX])
        return constraints
    }
    
    init(withCharacter char: Character) {
        self.char = char
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(charImageView)
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = .black
        for label in [nameLabel, statusLabel, speciesLabel, genderLabel, locationLabel] {
            labelsStackView.addArrangedSubview(label)
        }
        
        view.addSubview(labelsStackView)
        
        NSLayoutConstraint.activate(charImageViewContraints)
        NSLayoutConstraint.activate(stackViewContraints)
        configureView()
    }
    
    private func configureView() {
        nameLabel.text = char.name
        statusLabel.text = "Status: \(char.status)"
        speciesLabel.text = "Species: \(char.species)"
        genderLabel.text = "Gender: \(char.gender)"
        locationLabel.text = "Location: \(char.location.name)"
        
        ImageHandler.shared.getImage(forURL: self.char.image) { [weak self] image in
            guard let charImage = image else { return }
            DispatchQueue.main.async {
                self?.charImageView.image = charImage
            }
        }
    }
    
    private static func labelGenerator() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.text = ""
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }
}

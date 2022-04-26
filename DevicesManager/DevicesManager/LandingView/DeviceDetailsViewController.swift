//
//  DeviceDetailsViewController.swift
//  DevicesManager
//
//  Created by Sharun Garg on 2022-04-25.
//

import UIKit

class DeviceDetailsViewController: UIViewController {
    
    let device: Device
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var stackViewConstraints: [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let centerX = self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let centerY = self.stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        constraints.append(contentsOf: [centerX, centerY])
        return constraints
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupSubview()
        self.title = "Details"
    }
    
    init(withDevice device: Device) {
        self.device = device
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubview() {
        let nameLabel = UILabel()
        nameLabel.text = "Name: \(self.device.title)"
        
        let typeLabel = UILabel()
        typeLabel.text = "Type: \(self.device.type)"

        let priceLabel = UILabel()
        priceLabel.text = "Price: \(self.device.price)"
        
        for labelView in [nameLabel, typeLabel, priceLabel] {
            self.stackView.addArrangedSubview(labelView)
        }
        self.view.addSubview(self.stackView)
        NSLayoutConstraint.activate(self.stackViewConstraints)
    }
}

//
//  LandingMenuViewController.swift
//  DevicesManager
//
//  Created by Sharun Garg on 2022-04-25.
//

import UIKit

fileprivate enum MenuOptions: String, CaseIterable {
    case home = "Home"
    case devices = "My Devices"
    case settings = "Settings"
    
    func image() -> UIImage {
        var defaultImage: UIImage
        if let sysImage = UIImage(systemName: "pencil") { defaultImage = sysImage } else { defaultImage = UIImage() }
        switch self {
        case .home:
            return UIImage(systemName: "house") ?? defaultImage
        case .devices:
            return UIImage(systemName: "iphone") ?? defaultImage
        case .settings:
            return UIImage(systemName: "gear") ?? defaultImage
        }
    }
}

protocol MenuViewDelegate: AnyObject {
    func didSelectMenuItem()
}

class LandingMenuViewController: UIViewController {

    weak var delegate: MenuButtonDelegate?

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.frame = CGRect(x: self.view.safeAreaInsets.left, y: self.view.safeAreaInsets.top, width: self.view.bounds.width, height: self.view.bounds.height)
    }
}

extension LandingMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.imageView?.image = MenuOptions.allCases[indexPath.row].image()
        cell.backgroundColor = .darkGray
        cell.contentView.backgroundColor = .darkGray
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.didPressMenuButton()
    }
}

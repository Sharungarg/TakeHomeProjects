//
//  DevicesListViewController.swift
//  DevicesManager
//
//  Created by Sharun Garg on 2022-04-25.
//

import UIKit

protocol MenuButtonDelegate: AnyObject {
    func didPressMenuButton()
}

class DevicesListViewController: UIViewController, UISearchResultsUpdating {
    weak var delegate: MenuButtonDelegate?
    var viewModel: DevicesListViewModelDelegate
    var devicesList: [Device]?
    var filteredDeviceList: [Device]?
    
    init(viewModel: DevicesListViewModelDelegate) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .darkGray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    let tableView : UITableView  = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var tableViewContraints: [NSLayoutConstraint] {
        var tableViewContraints: [NSLayoutConstraint] = []
        let topAnchor = tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let bottomAnchor = tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        let leadingAnchor = tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        let trailingAnchor = tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        tableViewContraints.append(contentsOf: [topAnchor, bottomAnchor, leadingAnchor, trailingAnchor])
        return tableViewContraints
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Devices"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didPressMenuButton))
        self.addTableView()
        self.addLoadingIndicator()
        self.setupSearchBar()
        self.populateTableView()
        
    }
    
    private func setupSearchBar() {
        let seachController = UISearchController()
        seachController.searchResultsUpdater = self
        self.navigationItem.searchController = seachController
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            DispatchQueue.main.async {
                self.filteredDeviceList = self.devicesList
                self.tableView.reloadData()
            }
            return
        }
        
        let filteredList = self.devicesList?.filter { device in
            return device.title.lowercased().contains(text.lowercased())
        }
        
        DispatchQueue.main.async {
            self.filteredDeviceList = filteredList
            self.tableView.reloadData()
        }
    }
    
    private func addTableView() {
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate(tableViewContraints)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func addLoadingIndicator() {
        self.view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loadingIndicator.startAnimating()
    }
    
    private func populateTableView() {
        self.viewModel.fetchDevicesList() { [weak self] devices in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { //delay added to imitate network call time
                self?.loadingIndicator.stopAnimating()
                self?.devicesList = devices
                self?.filteredDeviceList = devices
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func didPressMenuButton() {
        self.delegate?.didPressMenuButton()
    }
}

extension DevicesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let devices = self.filteredDeviceList else { return 0 }
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let devices = self.filteredDeviceList else { return cell }
        
        cell.textLabel?.text = devices[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let device = self.filteredDeviceList?[indexPath.row] else { return }
        let detailsView = DeviceDetailsViewController(withDevice: device)
        present(detailsView, animated: true)
    }
}

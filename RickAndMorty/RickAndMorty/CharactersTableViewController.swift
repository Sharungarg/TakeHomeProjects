//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Sharun Garg on 2022-04-23.
//

import UIKit

class CharactersTableViewController: UIViewController, UISearchResultsUpdating {
    private var originalCharsList: [Character]?
    private var filteredCharsList: [Character]?
    var viewModel: CharacterTableViewModelProtocol
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let tableView : UITableView  = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
        return tableView
    }()
    
    private var tableViewContraints: [NSLayoutConstraint] {
        var contactTableViewContraints: [NSLayoutConstraint] = []
        let topAnchor = tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let bottomAnchor = tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        let leadingAnchor = tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        let trailingAnchor = tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        contactTableViewContraints.append(contentsOf: [topAnchor, bottomAnchor, leadingAnchor, trailingAnchor])
        return contactTableViewContraints
    }
    
    init(withViewModel vm: CharacterTableViewModelProtocol) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Rick and Morty Characters"
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate(tableViewContraints)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(loadingIndicator)
        self.loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadingIndicator.startAnimating()
        self.populateTableView()
    }
    
    private func setupSearchController() {
        let controller = UISearchController()
        controller.searchResultsUpdater = self
        self.navigationItem.searchController = controller
        self.navigationItem.searchController?.searchBar.placeholder = "Search Characters"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 0 else {
            DispatchQueue.main.async { [weak self] in
                self?.filteredCharsList = self?.originalCharsList
                self?.tableView.reloadData()
            }
            return
        }
        
        let filteredList = self.originalCharsList?.filter { char in
            char.name.lowercased().contains(text.lowercased())
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.filteredCharsList = filteredList
            self?.tableView.reloadData()
        }
    }
    
    private func populateTableView() {
        self.viewModel.fetchCharacters { [weak self] characterList in
            guard let charsList = characterList else { return }
            
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.originalCharsList = charsList
                self?.filteredCharsList = charsList
                self?.tableView.reloadData()
            }
        }
    }
}

extension CharactersTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath)
                as? CharacterTableViewCell,
              let character = self.filteredCharsList?[indexPath.row] else { return UITableViewCell() }
        
        cell.configure(for: character)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = self.filteredCharsList else { return 0 }
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let char = self.filteredCharsList?[indexPath.row] else { return }
        
        present(CharacterDetailsViewController(withCharacter: char), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}


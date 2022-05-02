//
//  ContactsTableViewController.swift
//  Contacts
//
//  Created by Sharun Garg on 2022-03-29.
//

import UIKit

class ContactsTableViewController: UIViewController {
    enum Constants {
        static let screenTitleLabel = "Contacts"
    }
    
    private static let contactsViewModel = ContactsListViewModel()
    var contactsList: [String] = contactsViewModel.contactsList
    
    lazy var contactsTableView : UITableView  = {
        let tableView = UITableView()
        return tableView
    }()
    
    var contactsTableViewContraints: [NSLayoutConstraint] {
        var contactTableViewContraints: [NSLayoutConstraint] = []
        let topAnchor = contactsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let bottomAnchor = contactsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        let leadingAnchor = contactsTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        let trailingAnchor = contactsTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        contactTableViewContraints.append(contentsOf: [topAnchor, bottomAnchor, leadingAnchor, trailingAnchor])
        return contactTableViewContraints
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup Navigation Title
        self.navigationItem.title = Constants.screenTitleLabel
        self.view.backgroundColor = .white
        
        // Add tableView to the view
        self.view.addSubview(contactsTableView)
        contactsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(contactsTableViewContraints)
        
        contactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableView.self))
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
    }
}

extension ContactsTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableView.self), for: indexPath)
        cell.textLabel?.lineBreakMode = .byCharWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = contactsList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


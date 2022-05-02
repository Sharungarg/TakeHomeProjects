//
//  ContactsListModel.swift
//  Contacts
//
//  Created by Sharun Garg on 2022-03-29.
//

import Foundation

struct ContactsListModel {
    private(set) var contacts: [Contact]
    
    init(with rawContactsList: [String], separator: String) {
        contacts = rawContactsList.compactMap { (contact) -> Contact? in
            let contactComponents = contact.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: separator)
            
            guard let firstName = contactComponents.first?.trimmingCharacters(in: .whitespacesAndNewlines),
                  firstName.count > 0 else { return  nil }
            
            var hasLastName: String?
            if contactComponents.count > 1,
               let lastName = contactComponents.last?.trimmingCharacters(in: .whitespacesAndNewlines),
               lastName.count > 0 {
                hasLastName = lastName
            }
            
            return Contact(firstName: firstName.capitalized, lastName: hasLastName?.capitalized)
        }
    }
    
    struct Contact: Comparable {
        let firstName: String
        let lastName: String?
        
        static func < (lhs: ContactsListModel.Contact, rhs: ContactsListModel.Contact) -> Bool {
            let this = "\(lhs.firstName)\(lhs.lastName ?? "")"
            let that = "\(rhs.firstName)\(rhs.lastName ?? "")"
            return this < that
        }
    }
}

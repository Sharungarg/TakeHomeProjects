//
//  ContactsListViewModel.swift
//  Contacts
//
//  Created by Sharun Garg on 2022-03-29.
//

import Foundation

struct ContactsListViewModel {
    private static let contactsTestData = ["", // empty string
                                           "testjustfirstname lastname",
                                           "testJustFirstName", // just first name
                                           "testfirstname middlename lastname", // first name with middle and last name
                                           "   ", // emtpy name
                                           "veryveryveryveryveryveryveryveryveryveryveryverylongname", // very long name
                                           "Jason Doherty", "Aliesha Cordova", "Vivien Walton","Vivien Kumar", "Megan Martins", "Zac Eastwood", "Jordana Shea", "Jason Schmitt", "Caroline Mccabe", "Ottilie Koch", "Jason Davison", "Anwen Boyer", "Mekhi Muir", "Haniya Sadler", "Asa Eastwood", "Megan Mendez", "Tashan Boone", "Tristan Bautista", "Nelly Clarke", "Megan Hebert", "Daniel Milla", "Meg Roberts", "Aliesha Rohaman"]
    
    typealias Contact = ContactsListModel.Contact
    
    private static let separator = " "
    private let contactListModel = getContactsModel()
    var contactsList: [String] {
        generateContactsListWithCustomNames()
    }
    
    private static func getContactsModel() -> [Contact] {
        ContactsListModel(with: contactsTestData, separator: separator).contacts
    }
    
    private func generateContactsListWithCustomNames() -> [String] {
        let sortedContactList = contactListModel.sorted(by: <)
        let contactsList = sortedContactList.enumerated().map { (index, contact) -> String in
            var displayName = contact.firstName
            
            // If there's no last name in contact, first name should be displayed
            guard let lastName = contact.lastName else  { return displayName }
            
            let previousContactIndex = index - 1
            let nextContactIndex = index + 1
            var matchingContact: Contact?
            
            if previousContactIndex >= 0,
               sortedContactList[previousContactIndex].firstName == contact.firstName {
                matchingContact = sortedContactList[previousContactIndex]
            }
            
            if nextContactIndex < sortedContactList.count,
               sortedContactList[nextContactIndex].firstName == contact.firstName {
                let nextMatchingContact = sortedContactList[nextContactIndex]
                if matchingContact == nil { // if the contact at previous index didn't have same first name and there was no match
                    matchingContact = nextMatchingContact
                } else if nextMatchingContact.lastName?.prefix(1) == lastName.prefix(1) { // if the next index contact has same last name prefix, override matchingContact
                    matchingContact = nextMatchingContact
                }
            }
            
            // If there's a match of firstNames, modify lastName to display
            if let matchingContact = matchingContact {
                let lastNameToDisplay = matchingContact.lastName?.prefix(1) == lastName.prefix(1) ? " \(lastName)" : " \(lastName.prefix(1))"
                displayName.append(contentsOf: " \(lastNameToDisplay)")
            }
            
            return displayName
        }
        
        return contactsList
    }
}

/*
 |  _   ____   ____   _
 | ⎛ |‾|  ⚈ |-| ⚈  |‾| ⎞
 | ⎝ |  ‾‾‾‾| |‾‾‾‾  | ⎠
 |  ‾        ‾        ‾
 */

import Foundation
import Contacts

public protocol NamePresentable {
    var givenName: String? { get }
    var familyName: String? { get }
}


public extension NamePresentable {
    
    public var name: String {
        let contact = CNMutableContact()
        contact.givenName = givenName ?? ""
        contact.familyName = familyName ?? ""
        let fullName: String
        if let formattedName = CNContactFormatter.stringFromContact(contact, style: .FullName) {
            fullName = formattedName
        } else {
            var name = givenName ?? ""
            if name.isEmpty {
                fullName = familyName ?? ""
            } else if let familyName = familyName where familyName.characters.count > 0 {
                fullName = "\(name) \(familyName)"
            } else {
                fullName = name
            }
        }
        return fullName
    }
    
    public var initials: String {
        var initialsString = String()
        if let givenName = givenName where givenName.characters.count > 0 {
            initialsString += givenName.substringToIndex(givenName.startIndex.successor())
        }
        if let familyName = familyName where familyName.characters.count > 0 {
            initialsString += familyName.substringToIndex(familyName.startIndex.successor())
        }
        if initialsString.characters.count == 0 {
            initialsString = "?"
        }
        return initialsString.uppercaseString
    }
    
}


// MARK: - Sorting functions

public extension CollectionType where Self.Generator.Element: NamePresentable {
    
    public func sortedByName(ascending ascending: Bool = true) -> [Self.Generator.Element] {
        return self.sort { ascending ? $0.name < $1.name : $0.name > $1.name }
    }
    
}

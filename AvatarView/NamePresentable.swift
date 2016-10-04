/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
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
        if let formattedName = CNContactFormatter.string(from: contact, style: .fullName) {
            fullName = formattedName
        } else {
            let name = givenName ?? ""
            if name.isEmpty {
                fullName = familyName ?? ""
            } else if let familyName = familyName , familyName.characters.count > 0 {
                fullName = "\(name) \(familyName)"
            } else {
                fullName = name
            }
        }
        return fullName
    }
    
    public var initials: String {
        var initialsString = String()
        if let givenName = givenName , givenName.characters.count > 0 {
            initialsString += givenName.substring(to: givenName.characters.index(after: givenName.startIndex))
        }
        if let familyName = familyName , familyName.characters.count > 0 {
            initialsString += familyName.substring(to: familyName.characters.index(after: familyName.startIndex))
        }
        if initialsString.characters.count == 0 {
            initialsString = "?"
        }
        return initialsString.uppercased()
    }
    
}


// MARK: - Sorting functions

public extension Collection where Self.Iterator.Element: NamePresentable {
    
    public func sortedByName(ascending: Bool = true) -> [Self.Iterator.Element] {
        return self.sorted { ascending ? $0.name < $1.name : $0.name > $1.name }
    }
    
}

/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import Foundation
import Contacts

public protocol AvatarPresentable {
    var initialsString: String? { get }
    var image: UIImage? { get }
    var imageURL: URL? { get }
}

extension AvatarPresentable {
    
    func isIdentical(to other: AvatarPresentable) -> Bool {
        return initialsString == other.initialsString
            && image == other.image
            && imageURL == other.imageURL
    }
    
}


public protocol NamePresentable {
    var givenName: String? { get }
    var familyName: String? { get }
}

public extension NamePresentable {
    
    var name: String {
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
            } else if let familyName = familyName , familyName.count > 0 {
                fullName = "\(name) \(familyName)"
            } else {
                fullName = name
            }
        }
        return fullName
    }
    
    var initials: String? {
        var initialsString = String()
        if let givenName = givenName , givenName.count > 0 {
            initialsString += String(givenName[..<givenName.index(after: givenName.startIndex)])
        }
        if let familyName = familyName , familyName.count > 0 {
            initialsString += String(familyName[..<familyName.index(after: familyName.startIndex)])
        }
        if initialsString.count == 0 {
            return nil
        }
        return initialsString.uppercased()
    }
    
}


// MARK: - Sorting functions

public extension Collection where Self.Iterator.Element: NamePresentable {
    
    func sortedByName(ascending: Bool = true) -> [Self.Iterator.Element] {
        return self.sorted { ascending ? $0.name < $1.name : $0.name > $1.name }
    }
    
    func sortedByGivenName(ascending: Bool = true) -> [Self.Iterator.Element] {
        return self.sorted { first, second in
            guard let firstName = first.givenName, !firstName.isEmpty, let secondName = second.givenName, !secondName.isEmpty else { return ascending }
            return ascending ? firstName < secondName : firstName > secondName
        }
    }
    
    func sortedByFamilyName(ascending: Bool = true) -> [Self.Iterator.Element] {
        return self.sorted { first, second in
            guard let firstName = first.familyName, !firstName.isEmpty, let secondName = second.familyName, !secondName.isEmpty else { return ascending }
            return ascending ? firstName < secondName : firstName > secondName
        }
    }
    
}

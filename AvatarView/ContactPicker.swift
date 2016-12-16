/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit
import ContactsUI

protocol ContactPickerDelegate {
    func contactSelected(_ firstName: String?, lastName: String?, photoData: Data?)
}

class ContactPicker: NSObject {
    
    let viewController: UIViewController
    let delegate: ContactPickerDelegate
    var photoRequired = false
    
    init(viewController: UIViewController, delegate: ContactPickerDelegate) {
        self.viewController = viewController
        self.delegate = delegate
        super.init()
    }
    
    func showContactPicker() {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        let contactPredicate = photoRequired ? "(imageData != nil)" : "(givenName != '') OR (familyName != '')"
        picker.predicateForEnablingContact = NSPredicate(format: contactPredicate, argumentArray: nil)
        picker.modalPresentationStyle = .overCurrentContext
        viewController.present(picker, animated: true, completion: nil)
    }
    
}


// MARK: - Contact picker delegate

extension ContactPicker: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        var firstName = contact.givenName.characters.count > 0 ? contact.givenName : contact.familyName
        if contact.middleName.characters.count > 0 {
            firstName += " \(contact.middleName)"
        }
        let lastName: String? = contact.familyName == firstName ? nil : contact.familyName
        var photoData: Data?
        if let thumbnailImageData = contact.thumbnailImageData , contact.imageDataAvailable {
            photoData = thumbnailImageData
        }
        delegate.contactSelected(firstName, lastName: lastName, photoData: photoData)
    }
    
}

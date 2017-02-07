/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit
import ContactsUI

public protocol ContactPickerDelegate {
    func contactSelected(_ contact: CNContact, firstName: String?, lastName: String?, photoData: Data?, thumbnailData: Data?)
    func contactPickerCanceled()
}

open class ContactPicker: NSObject {
    
    // MARK: - Internal properties
    
    let viewController: UIViewController
    let delegate: ContactPickerDelegate
    let photoRequired: Bool
    
    
    // MARK: - Initializer
    
    public init(viewController: UIViewController, delegate: ContactPickerDelegate, photoRequired: Bool = false) {
        self.viewController = viewController
        self.delegate = delegate
        self.photoRequired = photoRequired
        super.init()
    }
    
    
    // MARK: - Public functions
    
    public func showContactPicker(from sender: Any?, completion: (() -> Void)? = nil) {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        let contactPredicate = photoRequired ? "(imageData != nil)" : "(givenName != '') OR (familyName != '')"
        picker.predicateForEnablingContact = NSPredicate(format: contactPredicate, argumentArray: nil)
        picker.modalPresentationStyle = .overCurrentContext
        if let barButtonItem = sender as? UIBarButtonItem {
            picker.popoverPresentationController?.barButtonItem = barButtonItem
        } else if let view = sender as? UIView {
            picker.popoverPresentationController?.sourceView = view.superview
            picker.popoverPresentationController?.sourceRect = view.frame
        }
        viewController.present(picker, animated: true) { _ in
            completion?()
        }
    }
    
}


// MARK: - Contact picker delegate

extension ContactPicker: CNContactPickerDelegate {
    
    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        var firstName = contact.givenName.characters.count > 0 ? contact.givenName : contact.familyName
        if contact.middleName.characters.count > 0 {
            firstName += " \(contact.middleName)"
        }
        let lastName: String? = contact.familyName == firstName ? nil : contact.familyName
        var photoData: Data?
        var thumbnailData: Data?
        if contact.imageDataAvailable {
            photoData = contact.imageData
            thumbnailData = contact.thumbnailImageData
        }
        delegate.contactSelected(contact, firstName: firstName, lastName: lastName, photoData: photoData, thumbnailData: thumbnailData)
    }
    
    public func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        delegate.contactPickerCanceled()
    }
    
}

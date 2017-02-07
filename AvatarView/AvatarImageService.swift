/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit
import Contacts

public protocol AvatarImageServiceDelegate: class {
    func updateImage(with image: UIImage?)
    func updateFromContact(with photoData: Data?, and thumbnailData: Data?)
}

open class AvatarImageService: NSObject {
    
    // MARK: - Internal properties
    
    let viewController: UIViewController
    let delegate: AvatarImageServiceDelegate
    static var statusBarStyle = UIStatusBarStyle.default
    var contactPicker: ContactPicker!
    
    
    // MARK: - Initializers
    
    required public init(viewController: UIViewController, delegate: AvatarImageServiceDelegate) {
        self.viewController = viewController
        self.delegate = delegate
        super.init()
        contactPicker = ContactPicker(viewController: self.viewController, delegate: self, photoRequired: true)
    }
    
    
    // MARK: - Public functions
    
    public func presentImageOptions(from sender: Any?, existingPhoto: Bool = false, namedPerson: NamePresentable? = nil, tintColor: UIColor? = nil, statusBarStyle: UIStatusBarStyle = .default) {
        AvatarImageService.statusBarStyle = statusBarStyle
        let title: String
        if let namedPerson = namedPerson {
            if existingPhoto {
                title = String.localizedStringWithFormat(NSLocalizedString("Update photo for %@", comment: "Parameter is person's name"), namedPerson.name)
            } else {
                title = String.localizedStringWithFormat(NSLocalizedString("Add photo for %@", comment: "Parameter is person's name"), namedPerson.name)
            }
        } else {
            title = NSLocalizedString("Avatar image options", comment: "Name of action sheet with options to edit avatar image")
        }
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        if let tintColor = tintColor {
            actionSheet.view.tintColor = tintColor
        }
//        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Use last photo", comment: "Action title to use most recent photo in library"), style: .default) { _ in
//            // TODO: Grab last photo
//        })
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Take photo", comment: "Action title to take a new photo"), style: .default) { _ in
                self.pickImage(fromLibrary: false)
            })
        }
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Choose from Photos", comment: "Action title to take a new photo"), style: .default) { _ in
            self.pickImage(fromLibrary: true, sender: sender)
        })
        actionSheet.addAction(UIAlertAction(title: "Choose from Contacts", style: .default, handler: { (action) -> Void in
            self.contactPicker.showContactPicker(from: sender)
        }))
        if existingPhoto {
            actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Remove photo", comment: "Action title to remove photo"), style: .destructive) { _ in
                self.delegate.updateImage(with: nil)
            })
        }
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button title"), style: .cancel, handler: nil))
        if let barButtonItem = sender as? UIBarButtonItem {
            actionSheet.popoverPresentationController?.barButtonItem = barButtonItem
        } else if let view = sender as? UIView {
            actionSheet.popoverPresentationController?.sourceView = view.superview
            actionSheet.popoverPresentationController?.sourceRect = view.frame
        }
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
}


// MARK: - Image picker controller delegate

extension AvatarImageService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer { picker.dismiss(animated: true, completion: nil) }
        if picker.sourceType == .camera, let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil)
        }
        guard let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        delegate.updateImage(with: editedImage)
    }
    
}


// MARK: - Contact picker delegate

extension AvatarImageService: ContactPickerDelegate {

    public func contactPickerCanceled() {
        // Do nothing
    }
    
    public func contactSelected(_ contact: CNContact, firstName: String?, lastName: String?, photoData: Data?, thumbnailData: Data?) {
        delegate.updateFromContact(with: photoData, and: thumbnailData)
    }
    
}


// MARK: - Private functions

private extension AvatarImageService {
    
    func pickImage(fromLibrary: Bool, sender: Any? = nil) {
        let imagePicker = CustomStatusBarImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if fromLibrary {
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .popover
            if let barButtonItem = sender as? UIBarButtonItem {
                imagePicker.popoverPresentationController?.barButtonItem = barButtonItem
            } else if let view = sender as? UIView {
                imagePicker.popoverPresentationController?.sourceView = view.superview
                imagePicker.popoverPresentationController?.sourceRect = view.frame
            }
        } else {
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            imagePicker.modalPresentationStyle = .fullScreen
        }
        
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
}


// MARK: - Light status bar image picker

private final class CustomStatusBarImagePickerController: UIImagePickerController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return AvatarImageService.statusBarStyle
    }
    
}

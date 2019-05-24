/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit
import Contacts
import Photos

public protocol AvatarImageServiceDelegate: class {
    func updateImage(with image: UIImage?)
    func updateFromContact(with photoData: Data?, and thumbnailData: Data?)
}

open class AvatarImageService: NSObject {
    
    // MARK: - Internal properties
    
    weak var viewController: UIViewController?
    weak var delegate: AvatarImageServiceDelegate?
    let cameraDevice: UIImagePickerController.CameraDevice
    static var statusBarStyle = UIStatusBarStyle.default
    var contactPicker: ContactPicker!
    
    
    // MARK: - Initializers
    
    required public init(viewController: UIViewController, delegate: AvatarImageServiceDelegate, cameraDevice: UIImagePickerController.CameraDevice = .front) {
        self.viewController = viewController
        self.delegate = delegate
        self.cameraDevice = cameraDevice
        super.init()
        contactPicker = ContactPicker(viewController: self.viewController, delegate: self, photoRequired: true)
    }
    
    
    // MARK: - Public functions
    
    public func presentImageOptions(from sender: Any?, existingPhoto: Bool = false, namedPerson: NamePresentable? = nil, tintColor: UIColor? = nil, statusBarStyle: UIStatusBarStyle = .default, resizedTo targetSize: CGSize? = nil) {
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
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Use last photo", comment: "Action title to use most recent photo in library"), style: .default) { _ in
            self.getLastImage(resizedTo: targetSize)
        })
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
                self.delegate?.updateImage(with: nil)
            })
        }
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button title"), style: .cancel, handler: nil))
        if let barButtonItem = sender as? UIBarButtonItem {
            actionSheet.popoverPresentationController?.barButtonItem = barButtonItem
        } else if let view = sender as? UIView {
            actionSheet.popoverPresentationController?.sourceView = view.superview
            actionSheet.popoverPresentationController?.sourceRect = view.frame
        }
        viewController?.present(actionSheet, animated: true, completion: nil)
    }
    
}


// MARK: - Image picker controller delegate

extension AvatarImageService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        defer { picker.dismiss(animated: true, completion: nil) }
        if picker.sourceType == .camera, let originalImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil)
        }
        guard let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage else { return }
        delegate?.updateImage(with: editedImage)
    }
    
}


// MARK: - Contact picker delegate

extension AvatarImageService: ContactPickerDelegate {

    public func contactPickerCanceled() {
        // Do nothing
    }
    
    public func contactSelected(_ contact: CNContact, firstName: String?, lastName: String?, photoData: Data?, thumbnailData: Data?) {
        delegate?.updateFromContact(with: photoData, and: thumbnailData)
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
            imagePicker.cameraDevice = cameraDevice
            imagePicker.modalPresentationStyle = .fullScreen
        }
        
        viewController?.present(imagePicker, animated: true, completion: nil)
    }
    
    func getLastImage(resizedTo targetSize: CGSize?) {
        let manager = PHImageManager.default()
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResults = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        guard let asset = fetchResults.firstObject else { return }
        let size: CGSize
        if let targetSize = targetSize {
            size = targetSize
        } else {
            size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        }
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { image, info in
            if let degraded = info?[PHImageResultIsDegradedKey] as? Bool, degraded {
                print("status=degraded-image-returned")
            }
            if let cancelled = info?[PHImageCancelledKey] as? Bool, cancelled {
                print("status=image-request-cancelled")
                return
            }
            if let error = info?[PHImageErrorKey] as? Error {
                print("status=image-request-failed error=\(error)")
                return
            }
            self.delegate?.updateImage(with: image)
        }
    }
    
}


// MARK: - Light status bar image picker

private final class CustomStatusBarImagePickerController: UIImagePickerController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return AvatarImageService.statusBarStyle
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

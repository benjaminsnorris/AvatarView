/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit

public protocol AvatarImageServiceDelegate {
    
}

public struct AvatarImageService {
    
    // MARK: - Public properties
    
    public var delegate: AvatarImageServiceDelegate?
    
    
    // MARK: - Initializers
    
    public init() { }
    
    
    // MARK: - Public functions
    
    public func presentImageOptions(from viewController: UIViewController, sender: Any?, existingPhoto: Bool = false, tintColor: UIColor? = nil) {
        let actionSheet = UIAlertController(title: NSLocalizedString("Avatar image options", comment: "Name of action sheet with options to edit avatar image"), message: nil, preferredStyle: .actionSheet)
        if let tintColor = tintColor {
            actionSheet.view.tintColor = tintColor
        }
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Use last photo", comment: "Action title to use most recent photo in library"), style: .default) { _ in
            // Grab last photo
        })
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Take photo", comment: "Action title to take a new photo"), style: .default) { _ in
            // Take photo
        })
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Choose from library", comment: "Action title to take a new photo"), style: .default) { _ in
            // Choose photo
        })
        let removeAction = UIAlertAction(title: NSLocalizedString("Remove photo", comment: "Action title to remove photo"), style: .destructive) { _ in
            // Remove photo
        }
        if !existingPhoto {
            actionSheet.addAction(removeAction)
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

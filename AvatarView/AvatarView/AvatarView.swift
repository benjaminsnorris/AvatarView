/*
 |  _   ____   ____   _
 | ⎛ |‾|  ⚈ |-| ⚈  |‾| ⎞
 | ⎝ |  ‾‾‾‾| |‾‾‾‾  | ⎠
 |  ‾        ‾        ‾
 */

import UIKit

@IBDesignable public class AvatarView: UIView {
    
    // MARK: - Inspectable properties
    
    @IBInspectable public var borderColor: UIColor = UIColor(red: 50 / 255.0, green: 137 / 255.0, blue: 68 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable public var textColor: UIColor = UIColor(red: 50 / 255.0, green: 137 / 255.0, blue: 68 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 8.0 {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable public var initials: String? {
        didSet {
            updateInitials()
        }
    }
    
    @IBInspectable public var image: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    @IBInspectable public var innerMargin: CGFloat = 2.0 {
        didSet {
            
        }
    }
    
    
    // MARK: - Private properties
    
    private let backgroundView = UIView()
    private let initialsLabel = UILabel()
    private let imageView = UIImageView()
    private var initialsLeadingConstraint: NSLayoutConstraint!
    private var initialsTrailingConstraint: NSLayoutConstraint!

    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    
    // MARK: - Lifecycle overrides
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let minSideSize = min(frame.size.width, frame.size.height)
        layer.cornerRadius = minSideSize / 2.0
        
        initialsLabel.font = UIFont.systemFontOfSize(minSideSize / 2.5, weight: UIFontWeightLight)
    }
    
    
    // MARK: - Public API
    
    public func reset() {
        imageView.image = nil
        initialsLabel.text = nil
    }
    
}


// MARK: - Private methods

private extension AvatarView {
    
    func setupViews() {
        updateColors()
        updateBorder()
        
        clipsToBounds = true
        
        setupFullSize(backgroundView)

        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        initialsLabel.textAlignment = .Center
        addSubview(initialsLabel)
        
        initialsLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        initialsLeadingConstraint = initialsLabel.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: innerMargin)
        initialsLeadingConstraint.active = true
        initialsTrailingConstraint = trailingAnchor.constraintEqualToAnchor(initialsLabel.trailingAnchor, constant: innerMargin)
        initialsTrailingConstraint.active = true
        
        // Add image as an overlay to hide initials once it's been added
        imageView.contentMode = .ScaleAspectFill
        setupFullSize(imageView)
    }
    
    func setupFullSize(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        view.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
    }
    
    func updateColors() {
        layer.borderColor = borderColor.CGColor
        initialsLabel.textColor = textColor
    }
    
    func updateBorder() {
        layer.borderWidth = borderWidth
    }
    
    func updateInitials() {
        initialsLabel.text = initials
    }
    
    func updateImage() {
        imageView.image = image
    }
    
    func updateInnerMargin() {
        initialsLeadingConstraint.constant = innerMargin
        initialsTrailingConstraint.constant = innerMargin
    }
    
}

/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit
import Kingfisher

public protocol AvatarPresentable {
    var initialsString: String? { get }
    var image: UIImage? { get }
    var imageURL: URL? { get }
}

@IBDesignable open class AvatarView: UIView {
    
    // MARK: - Inspectable properties
    
    @IBInspectable open var borderColor: UIColor = UIColor(red: 29 / 255.0, green: 30 / 255.0, blue: 29 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var innerColor: UIColor = UIColor(red: 232 / 255.0, green: 236 / 255.0, blue: 237 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var textColor: UIColor = UIColor(red: 29 / 255.0, green: 30 / 255.0, blue: 29 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0.0 {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable open var innerMargin: CGFloat = 2.0 {
        didSet {
            updateInnerMargin()
        }
    }
    
    @IBInspectable open var fontName: String? = nil {
        didSet {
            updateInitials()
        }
    }
    
    @IBInspectable open var fontSize: CGFloat = 17.0 {
        didSet {
            updateInitials()
        }
    }
    
    @IBInspectable open var automaticSize: Bool = true {
        didSet {
            layoutIfNeeded()
        }
    }
    
    @IBInspectable open var initials: String? {
        didSet {
            updateInitials()
        }
    }
    
    @IBInspectable open var image: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    
    // MARK: - Public properties
    
    /// `imageView` is exposed for compatibility with frameworks such as Kingfisher.
    public let imageView = UIImageView()
    /// Avoid accessing this often as it involve expensive operations
    public var imageRepresentation: UIImage {
        return drawAsImage()
    }
    
    
    // MARK: - Private properties
    
    fileprivate let backgroundView = UIView()
    fileprivate let initialsLabel = UILabel()
    fileprivate var initialsLeadingConstraint: NSLayoutConstraint!
    fileprivate var initialsTrailingConstraint: NSLayoutConstraint!

    
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
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let minSideSize = min(frame.size.width, frame.size.height)
        layer.cornerRadius = minSideSize / 2.0
        
        if automaticSize {
            fontSize = minSideSize / 2.5
        }
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initials = "AV"
    }
    
    // MARK: - Public API
    
    open func reset() {
        image = nil
        initials = nil
    }
    
    open func update(with presenter: AvatarPresentable) {
        initials = presenter.initialsString
        if let image = presenter.image {
            self.image = image
        } else if let imageURL = presenter.imageURL {
            imageView.kf.setImage(with: imageURL)
        } else {
            image = nil
        }
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
        initialsLabel.textAlignment = .center
        addSubview(initialsLabel)
        initialsLabel.isAccessibilityElement = false
        
        initialsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        initialsLeadingConstraint = initialsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: innerMargin)
        initialsLeadingConstraint.isActive = true
        initialsTrailingConstraint = trailingAnchor.constraint(equalTo: initialsLabel.trailingAnchor, constant: innerMargin)
        initialsTrailingConstraint.isActive = true
        
        // Add image as an overlay to hide initials once it's been added
        imageView.contentMode = .scaleAspectFill
        setupFullSize(imageView)
        imageView.isAccessibilityElement = false
    }
    
    func setupFullSize(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateColors() {
        backgroundView.backgroundColor = innerColor
        layer.borderColor = borderColor.cgColor
        initialsLabel.textColor = textColor
    }
    
    func updateBorder() {
        layer.borderWidth = borderWidth
    }
    
    func updateInitials() {
        let customFont: UIFont
        if let fontName = fontName, let font = UIFont(name: fontName, size: fontSize) {
            customFont = font
        } else {
            customFont = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightLight)
        }
        initialsLabel.text = initials
        initialsLabel.font = customFont
    }
    
    func updateImage() {
        imageView.image = image
    }
    
    func updateInnerMargin() {
        initialsLeadingConstraint.constant = innerMargin
        initialsTrailingConstraint.constant = innerMargin
    }
    
    func drawAsImage() -> UIImage {
        layoutIfNeeded()
        var image: UIImage
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        let currentContext = UIGraphicsGetCurrentContext()!
        layer.render(in: currentContext)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

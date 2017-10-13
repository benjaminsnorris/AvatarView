/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit
import Kingfisher

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
    
    @IBInspectable open var spacingColor: UIColor = UIColor.white {
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
    
    @IBInspectable open var outerMargin: CGFloat = 0.0 {
        didSet {
            updateOuterMargin()
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
    
    fileprivate let spacingView = UIView()
    fileprivate let backgroundView = UIView()
    fileprivate let initialsLabel = UILabel()
    fileprivate var initialsLeadingConstraint: NSLayoutConstraint!
    fileprivate var initialsTrailingConstraint: NSLayoutConstraint!
    fileprivate var spacingLeadingConstraint: NSLayoutConstraint!
    fileprivate var spacingTrailingConstraint: NSLayoutConstraint!
    fileprivate var spacingTopConstraint: NSLayoutConstraint!
    fileprivate var spacingBottomConstraint: NSLayoutConstraint!

    
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
        backgroundView.layer.cornerRadius = (minSideSize - outerMargin * 2.0) / 2.0
        
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
        if let initialsString = presenter.initialsString, !initialsString.characters.isEmpty {
            if CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: initialsString)) {
                initials = initialsString
            } else {
                initials = "#"
            }
        } else {
            initials = nil
        }
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
        backgroundView.clipsToBounds = true
        
        setupFullSize(spacingView)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        spacingView.addSubview(backgroundView)
        spacingLeadingConstraint = backgroundView.leadingAnchor.constraint(equalTo: spacingView.leadingAnchor)
        spacingLeadingConstraint.isActive = true
        spacingTopConstraint = backgroundView.topAnchor.constraint(equalTo: spacingView.topAnchor)
        spacingTopConstraint.isActive = true
        spacingTrailingConstraint = spacingView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor)
        spacingTrailingConstraint.isActive = true
        spacingBottomConstraint = spacingView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        spacingBottomConstraint.isActive = true
        updateOuterMargin()

        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        initialsLabel.textAlignment = .center
        backgroundView.addSubview(initialsLabel)
        initialsLabel.isAccessibilityElement = false
        
        initialsLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        initialsLeadingConstraint = initialsLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: innerMargin)
        initialsLeadingConstraint.priority = 999
        initialsLeadingConstraint.isActive = true
        initialsTrailingConstraint = backgroundView.trailingAnchor.constraint(equalTo: initialsLabel.trailingAnchor, constant: innerMargin)
        initialsTrailingConstraint.priority = 999
        initialsTrailingConstraint.isActive = true
        
        // Add image as an overlay to hide initials once it's been added
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
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
        spacingView.backgroundColor = spacingColor
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
        initialsLabel.text = initials?.trimmingCharacters(in: CharacterSet.whitespaces)
        initialsLabel.font = customFont
    }
    
    func updateImage() {
        imageView.image = image
    }
    
    func updateInnerMargin() {
        initialsLeadingConstraint.constant = innerMargin
        initialsTrailingConstraint.constant = innerMargin
    }
    
    func updateOuterMargin() {
        spacingLeadingConstraint.constant = outerMargin
        spacingTopConstraint.constant = outerMargin
        spacingTrailingConstraint.constant = outerMargin
        spacingBottomConstraint.constant = outerMargin
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

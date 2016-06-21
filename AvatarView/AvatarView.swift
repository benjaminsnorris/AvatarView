/*
 |  _   ____   ____   _
 | ⎛ |‾|  ⚈ |-| ⚈  |‾| ⎞
 | ⎝ |  ‾‾‾‾| |‾‾‾‾  | ⎠
 |  ‾        ‾        ‾
 */

import UIKit

public protocol AvatarPresentable {
    var initialsString: String? { get }
    var image: UIImage? { get }
}

@IBDesignable public class AvatarView: UIView {
    
    // MARK: - Inspectable properties
    
    @IBInspectable public var borderColor: UIColor = UIColor(red: 29 / 255.0, green: 30 / 255.0, blue: 29 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable public var innerColor: UIColor = UIColor(red: 232 / 255.0, green: 236 / 255.0, blue: 237 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable public var textColor: UIColor = UIColor(red: 29 / 255.0, green: 30 / 255.0, blue: 29 / 255.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 2.0 {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable public var innerMargin: CGFloat = 2.0 {
        didSet {
            updateInnerMargin()
        }
    }
    
    @IBInspectable public var fontName: String? = nil {
        didSet {
            updateInitials()
        }
    }
    
    @IBInspectable public var fontSize: CGFloat = 17.0 {
        didSet {
            updateInitials()
        }
    }
    
    @IBInspectable public var automaticSize: Bool = true {
        didSet {
            layoutIfNeeded()
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
        
        if automaticSize {
            fontSize = minSideSize / 2.5
        }
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initials = "AV"
    }
    
    // MARK: - Public API
    
    public func reset() {
        image = nil
        initials = nil
    }
    
    public func update(with presenter: AvatarPresentable) {
        initials = presenter.initialsString
        image = presenter.image
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
        backgroundView.backgroundColor = innerColor
        layer.borderColor = borderColor.CGColor
        initialsLabel.textColor = textColor
    }
    
    func updateBorder() {
        layer.borderWidth = borderWidth
    }
    
    func updateInitials() {
        let customFont: UIFont
        if let fontName = fontName, font = UIFont(name: fontName, size: fontSize) {
            customFont = font
        } else {
            customFont = UIFont.systemFontOfSize(fontSize, weight: UIFontWeightLight)
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
    
}

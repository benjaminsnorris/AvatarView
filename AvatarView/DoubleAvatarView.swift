/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit

@IBDesignable open class DoubleAvatarView: UIView {
    
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
    
    @IBInspectable open var spacingColor: UIColor = UIColor.white {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0.0 {
        didSet {
            updateBorders()
        }
    }
    
    @IBInspectable open var innerMargin: CGFloat = 2.0 {
        didSet {
            updateMargins()
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
    
    @IBInspectable open var primaryInitials: String? {
        didSet {
            updateInitials()
        }
    }

    @IBInspectable open var secondaryInitials: String? {
        didSet {
            updateInitials()
        }
    }
    
    @IBInspectable open var secondarySizePercentage: CGFloat = 0.66 {
        didSet {
            updateSize()
        }
    }
    
    @IBInspectable open var secondaryOverlap: CGFloat = 16 {
        didSet {
            updateAllConstraints()
        }
    }
    
    @IBInspectable open var secondarySpacing: CGFloat = 2.0 {
        didSet {
            updateMargins()
        }
    }
    
    @IBInspectable open var isOnRight = true {
        didSet {
            updateAllConstraints()
        }
    }
    
    
    // MARK: - Private properties
    
    fileprivate var primaryAvatarView = AvatarView()
    fileprivate var secondaryAvatarView = AvatarView()
    
    fileprivate var secondaryHeightConstraint: NSLayoutConstraint?
    fileprivate var secondaryLeadingConstraint: NSLayoutConstraint!
    fileprivate var secondaryTrailingConstraint: NSLayoutConstraint!
    fileprivate var primaryLeadingConstraint: NSLayoutConstraint!
    fileprivate var primaryTrailingConstraint: NSLayoutConstraint!
    fileprivate var primaryCenteredConstraint: NSLayoutConstraint!
    fileprivate var secondaryInnerLeadingConstraint: NSLayoutConstraint!
    fileprivate var secondaryInnerTrailingConstraint: NSLayoutConstraint!
    fileprivate var secondaryTopConstraint: NSLayoutConstraint!

    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
}



// MARK: - Public

extension DoubleAvatarView {
    
    open func update(with primary: AvatarPresentable?, secondary: AvatarPresentable?) {
        var hasBoth = true
        if let second = secondary, primary == nil {
            primaryAvatarView.update(with: second)
            hasBoth = false
        } else {
            primaryAvatarView.update(with: primary)
            secondaryAvatarView.update(with: secondary)
            if primary == nil || secondary == nil {
                hasBoth = false
            }
        }
        if !hasBoth {
            secondaryAvatarView.isHidden = true
            primaryCenteredConstraint.isActive = true
            primaryLeadingConstraint.isActive = true
            primaryTrailingConstraint.isActive = true
            secondaryHeightConstraint?.isActive = false
        } else {
            secondaryAvatarView.isHidden = false
            primaryCenteredConstraint.isActive = false
            primaryLeadingConstraint.isActive = isOnRight
            primaryTrailingConstraint.isActive = !isOnRight
            secondaryHeightConstraint?.isActive = true
        }
        
    }
    
    open func reset() {
        primaryAvatarView.reset()
        secondaryAvatarView.reset()
    }
    
}


private extension DoubleAvatarView {
    
    func setUpViews() {
        backgroundColor = .clear
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        primaryAvatarView.translatesAutoresizingMaskIntoConstraints = false
        secondaryAvatarView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(primaryAvatarView)
        addSubview(secondaryAvatarView)
        setupConstraints()
        
        updateAllConstraints()
        updateColors()
        updateBorders()
        updateMargins()
        updateInitials()
    }
    
    func primaryAvatarWidth(fromSuperFrame frame: CGRect) -> CGFloat {
        let smaller = min(frame.height, frame.width)
        return (smaller + secondaryOverlap) / (1 + secondarySizePercentage)
    }
    
    func setupConstraints() {
        // Aspect ratio
        addConstraint(primaryAvatarView.heightAnchor.constraint(equalTo: primaryAvatarView.widthAnchor))
        let primaryWidthConstraint = primaryAvatarView.widthAnchor.constraint(equalToConstant: primaryAvatarWidth(fromSuperFrame: frame))
        primaryWidthConstraint.isActive = true
        primaryWidthConstraint.priority = UILayoutPriority(rawValue: 999)
        
        addConstraint(secondaryAvatarView.heightAnchor.constraint(equalTo: secondaryAvatarView.widthAnchor))
        secondaryHeightConstraint = secondaryAvatarView.heightAnchor.constraint(equalTo: primaryAvatarView.heightAnchor, multiplier: secondarySizePercentage)
        addConstraint(secondaryHeightConstraint!)
        
        // Primary <-> superview
        let primaryTopConstraint = topAnchor.constraint(equalTo: primaryAvatarView.topAnchor)
        primaryTopConstraint.priority = UILayoutPriority(rawValue: 999)
        primaryTopConstraint.isActive = true
        primaryLeadingConstraint = leadingAnchor.constraint(equalTo: primaryAvatarView.leadingAnchor)
        primaryTrailingConstraint = trailingAnchor.constraint(equalTo: primaryAvatarView.trailingAnchor)
        primaryCenteredConstraint = centerYAnchor.constraint(equalTo: primaryAvatarView.centerYAnchor)
        
        // Secondary <-> Primary
        secondaryTopConstraint = primaryAvatarView.bottomAnchor.constraint(equalTo: secondaryAvatarView.topAnchor)
        addConstraint(secondaryTopConstraint)
        secondaryLeadingConstraint = leadingAnchor.constraint(equalTo: secondaryAvatarView.leadingAnchor)
        secondaryTrailingConstraint = trailingAnchor.constraint(equalTo: secondaryAvatarView.trailingAnchor)
        secondaryInnerLeadingConstraint = secondaryAvatarView.leadingAnchor.constraint(equalTo: primaryAvatarView.trailingAnchor)
        secondaryInnerLeadingConstraint.priority = UILayoutPriority(rawValue: 999)
        secondaryInnerTrailingConstraint = secondaryAvatarView.trailingAnchor.constraint(equalTo: primaryAvatarView.leadingAnchor)
        secondaryInnerTrailingConstraint.priority = UILayoutPriority(rawValue: 999)
    }
    
    func updateAllConstraints() {
        secondaryLeadingConstraint.isActive = !isOnRight
        secondaryTrailingConstraint.isActive = isOnRight
        primaryLeadingConstraint.isActive = isOnRight
        primaryTrailingConstraint.isActive = !isOnRight
        secondaryInnerLeadingConstraint.isActive = isOnRight
        secondaryInnerTrailingConstraint.isActive = !isOnRight
        
        secondaryTopConstraint.constant = secondaryOverlap * 0.75 // So secondary is a little more towards the center
        secondaryInnerLeadingConstraint.constant = -secondaryOverlap
        secondaryInnerTrailingConstraint.constant = secondaryOverlap
    }
    
    func updateSize() {
        let sizePercent = min(secondarySizePercentage, 1)
        secondaryHeightConstraint?.constant = primaryAvatarView.frame.size.height * sizePercent
        layoutIfNeeded()
    }
    
    func updateColors() {
        [primaryAvatarView, secondaryAvatarView].forEach { avatarView in
            avatarView.borderColor = borderColor
            avatarView.innerColor = innerColor
            avatarView.textColor = textColor
            avatarView.spacingColor = spacingColor
        }
    }
    
    func updateBorders() {
        primaryAvatarView.borderWidth = borderWidth
        secondaryAvatarView.borderWidth = borderWidth
    }
    
    func updateMargins() {
        primaryAvatarView.innerMargin = innerMargin
        secondaryAvatarView.innerMargin = innerMargin
        secondaryAvatarView.outerMargin = secondarySpacing
    }
    
    func updateInitials() {
        primaryAvatarView.initials = primaryInitials
        primaryAvatarView.fontName = fontName
        primaryAvatarView.fontSize = fontSize
        secondaryAvatarView.initials = secondaryInitials
        secondaryAvatarView.fontName = fontName
        secondaryAvatarView.fontSize = fontSize
    }
    
}

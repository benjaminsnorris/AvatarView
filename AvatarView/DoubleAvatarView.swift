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
    
    @IBInspectable open var separationColor: UIColor = UIColor.white {
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
            updateAllConstraints()
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
    fileprivate var secondaryBorderView = UIView()
    
    fileprivate var secondaryHeightConstraint: NSLayoutConstraint?
    fileprivate var secondaryLeadingConstraint: NSLayoutConstraint!
    fileprivate var secondaryTrailingConstraint: NSLayoutConstraint!
    fileprivate var primaryLeadingConstraint: NSLayoutConstraint!
    fileprivate var primaryTrailingConstraint: NSLayoutConstraint!
    fileprivate var secondaryInnerLeadingConstraint: NSLayoutConstraint!
    fileprivate var secondaryInnerTrailingConstraint: NSLayoutConstraint!
    fileprivate var secondaryTopConstraint: NSLayoutConstraint!
    fileprivate var secondaryBorderLeadingConstraint: NSLayoutConstraint!
    fileprivate var secondaryBorderTrailingConstraint: NSLayoutConstraint!
    fileprivate var secondaryBorderTopConstraint: NSLayoutConstraint!
    fileprivate var secondaryBorderBottomConstraint: NSLayoutConstraint!

    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }

    
    // MARK: - Lifecycle overrides
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let minSideSize = min(secondaryBorderView.frame.size.width, secondaryBorderView.frame.size.height)
        secondaryBorderView.layer.cornerRadius = minSideSize / 2.0
    }
    
}



// MARK: - Public

extension DoubleAvatarView {
    
    open func update(with primary: AvatarPresentable, secondary: AvatarPresentable) {
        primaryAvatarView.update(with: primary)
        secondaryAvatarView.update(with: secondary)
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
        secondaryBorderView.translatesAutoresizingMaskIntoConstraints = false
        secondaryAvatarView.translatesAutoresizingMaskIntoConstraints = false
        secondaryBorderView.clipsToBounds = true
        secondaryBorderView.backgroundColor = .white
        
        secondaryBorderView.layer.cornerRadius = secondaryBorderView.bounds.size.height / 2
        
        addSubview(primaryAvatarView)
        secondaryBorderView.addSubview(secondaryAvatarView)
        addSubview(secondaryBorderView)
        setupConstraints()
        updateAllConstraints()
    }
    
    func primaryAvatarWidth(fromSuperFrame frame: CGRect) -> CGFloat {
        let smaller = min(frame.height, frame.width)
        return (smaller + secondaryOverlap) / (1 + secondarySizePercentage)
    }
    
    func setupConstraints() {
        // Aspect ratio
        addConstraint(primaryAvatarView.heightAnchor.constraint(equalTo: primaryAvatarView.widthAnchor))
        addConstraint(primaryAvatarView.widthAnchor.constraint(equalToConstant: primaryAvatarWidth(fromSuperFrame: frame)))
        
        addConstraint(secondaryBorderView.heightAnchor.constraint(equalTo: secondaryBorderView.widthAnchor))
        secondaryHeightConstraint = secondaryBorderView.heightAnchor.constraint(equalTo: primaryAvatarView.heightAnchor, multiplier: secondarySizePercentage)
        addConstraint(secondaryHeightConstraint!)
        
        // SecondaryAvatar <-> Superview (SecondaryBorder)
        secondaryBorderLeadingConstraint = secondaryAvatarView.leadingAnchor.constraint(equalTo: secondaryBorderView.leadingAnchor)
        addConstraint(secondaryBorderLeadingConstraint)
        secondaryBorderTopConstraint = secondaryAvatarView.topAnchor.constraint(equalTo: secondaryBorderView.topAnchor)
        addConstraint(secondaryBorderTopConstraint)
        secondaryBorderTrailingConstraint = secondaryAvatarView.trailingAnchor.constraint(equalTo: secondaryBorderView.trailingAnchor)
        addConstraint(secondaryBorderTrailingConstraint)
        secondaryBorderBottomConstraint = secondaryAvatarView.bottomAnchor.constraint(equalTo: secondaryBorderView.bottomAnchor)
        addConstraint(secondaryBorderBottomConstraint)
        secondaryLeadingConstraint = leadingAnchor.constraint(equalTo: secondaryBorderView.leadingAnchor)
        secondaryTrailingConstraint = trailingAnchor.constraint(equalTo: secondaryBorderView.trailingAnchor)
        
        // Primary <-> superview
        addConstraint(topAnchor.constraint(equalTo: primaryAvatarView.topAnchor))
        primaryLeadingConstraint = leadingAnchor.constraint(equalTo: primaryAvatarView.leadingAnchor)
        primaryTrailingConstraint = trailingAnchor.constraint(equalTo: primaryAvatarView.trailingAnchor)
        
        // Secondary <-> Primary
        secondaryTopConstraint = primaryAvatarView.bottomAnchor.constraint(equalTo: secondaryBorderView.topAnchor)
        addConstraint(secondaryTopConstraint)
        secondaryInnerLeadingConstraint = secondaryBorderView.leadingAnchor.constraint(equalTo: primaryAvatarView.trailingAnchor)
        secondaryInnerTrailingConstraint = secondaryBorderView.trailingAnchor.constraint(equalTo: primaryAvatarView.leadingAnchor)
    }
    
    func updateAllConstraints() {
        secondaryLeadingConstraint.isActive = !isOnRight
        secondaryTrailingConstraint.isActive = isOnRight
        primaryLeadingConstraint.isActive = isOnRight
        primaryTrailingConstraint.isActive = !isOnRight
        secondaryInnerLeadingConstraint.isActive = isOnRight
        secondaryInnerTrailingConstraint.isActive = !isOnRight
        
        secondaryBorderLeadingConstraint.constant = secondarySpacing
        secondaryBorderTopConstraint.constant = secondarySpacing
        secondaryBorderTrailingConstraint.constant = -secondarySpacing
        secondaryBorderBottomConstraint.constant = -secondarySpacing

        secondaryTopConstraint.constant = secondaryOverlap * 0.75 // So secondary is a little more towards the center
        secondaryInnerLeadingConstraint.constant = secondaryOverlap
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
        }
        secondaryBorderView.backgroundColor = separationColor
    }
    
    func updateBorders() {
        primaryAvatarView.borderWidth = borderWidth
        secondaryAvatarView.borderWidth = borderWidth
    }
    
    func updateMargins() {
        primaryAvatarView.innerMargin = innerMargin
        secondaryAvatarView.innerMargin = innerMargin
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

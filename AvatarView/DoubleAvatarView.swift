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
    
    @IBInspectable open var isOnRight = true {
        didSet {
            updateAllConstraints()
        }
    }
    
    fileprivate var primaryAvatarView = AvatarView()
    fileprivate var secondaryAvatarView = AvatarView()
    fileprivate var secondaryHeightConstraint: NSLayoutConstraint?
    fileprivate var secondaryBorderView = UIView()
    
    
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



//MARK: - Public

extension DoubleAvatarView {
    
    open func update(with primary: AvatarPresentable, secondary: AvatarPresentable) {
        primaryAvatarView.update(with: primary)
        secondaryAvatarView.update(with: secondary)
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
        updateAllConstraints()
    }
    
    func primaryAvatarWidth(fromSuperFrame frame: CGRect) -> CGFloat {
        let smaller = min(frame.height, frame.width)
        return (smaller + secondaryOverlap) / (1 + secondarySizePercentage)
    }
    
    func updateAllConstraints() {
        //Aspect ratio
        addConstraint(primaryAvatarView.heightAnchor.constraint(equalTo: primaryAvatarView.widthAnchor))
        addConstraint(primaryAvatarView.widthAnchor.constraint(equalToConstant: primaryAvatarWidth(fromSuperFrame: frame)))
        
        addConstraint(secondaryBorderView.heightAnchor.constraint(equalTo: secondaryBorderView.widthAnchor))
        secondaryHeightConstraint = secondaryBorderView.heightAnchor.constraint(equalTo: primaryAvatarView.heightAnchor, multiplier: secondarySizePercentage)
        addConstraint(secondaryHeightConstraint!)
        
        // SecondaryAvatar <-> Superview (SecondaryBorder)
        let padding: CGFloat = 2.0
        addConstraint(secondaryAvatarView.leadingAnchor.constraint(equalTo: secondaryBorderView.leadingAnchor, constant: padding))
        addConstraint(secondaryAvatarView.topAnchor.constraint(equalTo: secondaryBorderView.topAnchor, constant: padding))
        addConstraint(secondaryAvatarView.trailingAnchor.constraint(equalTo: secondaryBorderView.trailingAnchor, constant: -padding))
        addConstraint(secondaryAvatarView.bottomAnchor.constraint(equalTo: secondaryBorderView.bottomAnchor, constant: -padding))
        let secondaryLeading = leadingAnchor.constraint(equalTo: secondaryBorderView.leadingAnchor)
        let secondaryTrailing = trailingAnchor.constraint(equalTo: secondaryBorderView.trailingAnchor)
        secondaryLeading.isActive = !isOnRight
        secondaryTrailing.isActive = isOnRight
        
        //Primary <-> superview
        addConstraint(topAnchor.constraint(equalTo: primaryAvatarView.topAnchor))
        let primaryLeading = leadingAnchor.constraint(equalTo: primaryAvatarView.leadingAnchor)
        let primaryTrailing = trailingAnchor.constraint(equalTo: primaryAvatarView.trailingAnchor)
        primaryLeading.isActive = isOnRight
        primaryTrailing.isActive = !isOnRight
        
        //Secondary <-> Primary
        addConstraint(primaryAvatarView.bottomAnchor.constraint(equalTo: secondaryBorderView.topAnchor, constant: secondaryOverlap * 0.75)) // So secondary is a little more towards the center
        let secondaryInnerLeading = secondaryBorderView.leadingAnchor.constraint(equalTo: primaryAvatarView.trailingAnchor, constant: secondaryOverlap)
        let secondaryInnerTrailing = secondaryBorderView.trailingAnchor.constraint(equalTo: primaryAvatarView.leadingAnchor, constant: secondaryOverlap)
        secondaryInnerLeading.isActive = isOnRight
        secondaryInnerTrailing.isActive = !isOnRight
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
    }
    
    func updateBorders() {
        primaryAvatarView.borderWidth = borderWidth
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

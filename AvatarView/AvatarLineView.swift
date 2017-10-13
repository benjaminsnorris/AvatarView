/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit

@IBDesignable open class AvatarLineView: UIView {
    
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
    
    @IBInspectable open var avatarBorderWidth: CGFloat = 0.0 {
        didSet {
            updateBorders()
        }
    }
    
    @IBInspectable open var fontName: String? = nil {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var fontSize: CGFloat = 17.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var overlap: CGFloat = 10 {
        didSet {
            stackView.spacing = -overlap
        }
    }
    
    @IBInspectable open var spacing: CGFloat = 2.0 {
        didSet {
            updateMargins()
        }
    }
    
    @IBInspectable open var maxCircles: Int = 3 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    /// If `true` avatars with initials instead of images will be filtered out if possible
    @IBInspectable open var preferImageAvatars = false {
        didSet {
            layoutIfNeeded()
        }
    }
    
    
    fileprivate var avatars = [AvatarPresentable]()
    fileprivate var avatarViews = [AvatarView]()
    fileprivate var plusAvatar = AvatarView()
    fileprivate let stackView = UIStackView()
    

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



//MARK: - Public

extension AvatarLineView {
    
    open func update(with avatars: [AvatarPresentable]) {
        self.avatars = avatars
        updateAvatars()
    }
    
}


private extension AvatarLineView {
    
    func setUpViews() {
        backgroundColor = .clear
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = -overlap
        addSubview(stackView)
        updateAllConstraints()
        updateMargins()
        updateAvatars()
    }
    
    func updateAvatars() {
        avatarViews.forEach { $0.removeFromSuperview() }
        avatarViews.removeAll()
        
        if avatars.isEmpty {
            addAvatar(for: nil)
        } else {
            for (index, avatar) in avatars.enumerated() {
                if avatars.count > maxCircles && index >= maxCircles - 1 {
                    let remaining = avatars.count - index
                    addAvatar(for: nil, text: "+\(remaining)")
                    break
                } else {
                    addAvatar(for: avatar)
                }
            }
        }
    }
    
    func addAvatar(for person: AvatarPresentable?, text: String? = nil) {
        let avatarView = AvatarView()
        setUpAvatarView(avatarView)
        if let person = person {
            avatarView.update(with: person)
        } else {
            avatarView.reset()
            avatarView.initials = text
        }
        stackView.addArrangedSubview(avatarView)
        self.avatarViews.append(avatarView)
    }
    
    func updateAllConstraints() {
        addConstraint(leadingAnchor.constraint(equalTo: stackView.leadingAnchor))
        addConstraint(topAnchor.constraint(equalTo: stackView.topAnchor))
        addConstraint(bottomAnchor.constraint(equalTo: stackView.bottomAnchor))
        addConstraint(trailingAnchor.constraint(equalTo: stackView.trailingAnchor))
    }
    
    func setUpAvatarView(_ avatarView: AvatarView) {
        avatarView.addConstraint(avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor))
        avatarView.borderColor = borderColor
        avatarView.innerColor = innerColor
        avatarView.textColor = textColor
        avatarView.spacingColor = spacingColor
        avatarView.borderWidth = avatarBorderWidth
        avatarView.fontName = fontName
        avatarView.fontSize = fontSize
        avatarView.outerMargin = spacing
    }
    
    func updateBorders() {
        avatarViews.forEach { $0.layer.borderWidth = avatarBorderWidth }
    }
    
    func updateColors() {
        avatarViews.forEach { avatarView in
            avatarView.borderColor = borderColor
            avatarView.textColor = textColor
            avatarView.spacingColor = spacingColor
        }
    }
    
    func updateMargins() {
        avatarViews.forEach { $0.outerMargin = spacing }
    }
    
}
